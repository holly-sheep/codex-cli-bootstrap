Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Info {
  param([string]$Message)
  Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Warn {
  param([string]$Message)
  Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Test-Command {
  param([string]$Name)
  return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Assert-PackageInstallsAllowed {
  if ($env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS -eq "1") {
    return
  }

  throw "Package installation and update steps are currently disabled. This would call installers such as winget, WSL setup, apt, NodeSource, or npm. Set CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS=1 only after you intentionally lift the supply-chain freeze."
}

function Test-IsAdministrator {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = New-Object Security.Principal.WindowsPrincipal($identity)
  return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Format-CommandForDisplay {
  param(
    [string]$FilePath,
    [string[]]$Arguments = @()
  )

  if ($Arguments.Count -eq 0) {
    return $FilePath
  }

  return "$FilePath $($Arguments -join ' ')"
}

function Invoke-NativeCommand {
  param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath,
    [string[]]$Arguments = @(),
    [switch]$AllowFailure
  )

  & $FilePath @Arguments
  $exitCode = $LASTEXITCODE

  if (-not $AllowFailure -and $exitCode -ne 0) {
    $display = Format-CommandForDisplay -FilePath $FilePath -Arguments $Arguments
    throw "Command failed with exit code ${exitCode}: $display"
  }

  return $exitCode
}

function Invoke-NativeCommandCapture {
  param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath,
    [string[]]$Arguments = @(),
    [switch]$AllowFailure
  )

  $output = & $FilePath @Arguments 2>&1
  $exitCode = $LASTEXITCODE

  if (-not $AllowFailure -and $exitCode -ne 0) {
    $display = Format-CommandForDisplay -FilePath $FilePath -Arguments $Arguments
    throw "Command failed with exit code ${exitCode}: $display"
  }

  return $output
}

function Install-WingetPackage {
  param([string]$PackageId)

  Assert-PackageInstallsAllowed
  Invoke-NativeCommand -FilePath "winget" -Arguments @(
    "install",
    "--id", $PackageId,
    "--exact",
    "--source", "winget",
    "--silent",
    "--disable-interactivity",
    "--accept-package-agreements",
    "--accept-source-agreements"
  ) | Out-Null
}

function Ensure-Winget {
  if (-not (Test-Command "winget")) {
    throw "winget is required. Install or update Microsoft App Installer first."
  }

  Write-Info "winget detected."
}

function Ensure-GitForWindows {
  $gitPath = "C:\Program Files\Git\cmd"
  if (Test-Path $gitPath) {
    $env:Path = "$gitPath;$env:Path"
  }

  if (Test-Command "git") {
    Write-Info "Git for Windows already installed: $(& git --version)"
    return
  }

  Write-Info "Installing Git for Windows..."
  Install-WingetPackage -PackageId "Git.Git"

  if (Test-Path $gitPath) {
    $env:Path = "$gitPath;$env:Path"
  }

  if (-not (Test-Command "git")) {
    throw "Git installation finished, but git is still not available on PATH."
  }

  Write-Info "Git for Windows installed: $(& git --version)"
}

function Ensure-WslCommand {
  if (-not (Test-Command "wsl.exe")) {
    throw "wsl.exe is not available. Update Windows first, then rerun this installer from an elevated PowerShell."
  }
}

function Parse-WslListVerboseOutput {
  param([string[]]$Lines)

  $distros = @()

  foreach ($line in $Lines) {
    if ([string]::IsNullOrWhiteSpace($line)) {
      continue
    }

    if ($line -match '^\s*NAME\s+STATE\s+VERSION\s*$') {
      continue
    }

    if ($line -match '^\s*(\*)?\s*(.+?)\s{2,}(\S+)\s+(\d+)\s*$') {
      $distros += [pscustomobject]@{
        Name = $Matches[2].Trim()
        State = $Matches[3].Trim()
        Version = [int]$Matches[4]
        IsDefault = ($Matches[1] -eq "*")
      }
    }
  }

  return $distros
}

function Get-WslDistroInfo {
  $output = Invoke-NativeCommandCapture -FilePath "wsl.exe" -Arguments @("--list", "--verbose")
  return Parse-WslListVerboseOutput -Lines @($output)
}

function Select-UbuntuDistro {
  param([object[]]$Distros)

  $ubuntuDistros = @($Distros | Where-Object { $_.Name -like "Ubuntu*" })
  if ($ubuntuDistros.Count -eq 0) {
    return $null
  }

  $defaultUbuntu = $ubuntuDistros | Where-Object { $_.IsDefault } | Select-Object -First 1
  if ($null -ne $defaultUbuntu) {
    return $defaultUbuntu
  }

  $exactUbuntu = $ubuntuDistros | Where-Object { $_.Name -eq "Ubuntu" } | Select-Object -First 1
  if ($null -ne $exactUbuntu) {
    return $exactUbuntu
  }

  return $ubuntuDistros | Select-Object -First 1
}

function Test-WslBashReady {
  param([string]$DistroName)

  Invoke-NativeCommand -FilePath "wsl.exe" -Arguments @("-d", $DistroName, "--", "bash", "-lc", "echo ok") -AllowFailure | Out-Null
  return ($LASTEXITCODE -eq 0)
}

function Ensure-WslUbuntu {
  Write-Info "Ensuring WSL2 default version..."
  Invoke-NativeCommand -FilePath "wsl.exe" -Arguments @("--set-default-version", "2") | Out-Null

  $ubuntuDistro = Select-UbuntuDistro -Distros (Get-WslDistroInfo)

  if ($null -eq $ubuntuDistro) {
    Write-Info "Installing Ubuntu on WSL..."
    Assert-PackageInstallsAllowed
    Invoke-NativeCommand -FilePath "wsl.exe" -Arguments @("--install", "-d", "Ubuntu") | Out-Null
    throw "Ubuntu installation was started. Reboot if Windows asks, launch Ubuntu once to create a Linux user, then rerun this script."
  }

  if ($ubuntuDistro.Version -ne 2) {
    Write-Info "Upgrading WSL distro to version 2: $($ubuntuDistro.Name)"
    Assert-PackageInstallsAllowed
    Invoke-NativeCommand -FilePath "wsl.exe" -Arguments @("--set-version", $ubuntuDistro.Name, "2") | Out-Null
    $ubuntuDistro = Select-UbuntuDistro -Distros (Get-WslDistroInfo)
    if ($ubuntuDistro.Version -ne 2) {
      throw "Ubuntu is installed, but WSL version 2 is not active for distro '$($ubuntuDistro.Name)'."
    }
  }

  if (-not (Test-WslBashReady -DistroName $ubuntuDistro.Name)) {
    throw "Ubuntu is installed but not initialized. Open Ubuntu once, complete Linux user creation, then rerun this script."
  }

  Write-Info "WSL Ubuntu is ready: $($ubuntuDistro.Name) (WSL$($ubuntuDistro.Version))"
  return $ubuntuDistro.Name
}

function Get-WslScriptPath {
  param([string]$WslDistro)

  $windowsPath = (Resolve-Path (Join-Path $PSScriptRoot "..\linux\install.sh")).Path
  $wslPathOutput = Invoke-NativeCommandCapture -FilePath "wsl.exe" -Arguments @("-d", $WslDistro, "--", "wslpath", "-a", $windowsPath)
  $wslPath = (@($wslPathOutput) | Select-Object -Last 1).Trim()

  if ([string]::IsNullOrWhiteSpace($wslPath)) {
    throw "Failed to convert Linux installer path to a WSL path."
  }

  return $wslPath
}

function Invoke-WslBootstrap {
  param(
    [string]$WslDistro,
    [string]$WslScriptPath
  )

  Write-Info "Running Linux bootstrap inside Ubuntu WSL..."
  Invoke-NativeCommand -FilePath "wsl.exe" -Arguments @("-d", $WslDistro, "--", "bash", "-lc", "bash '$WslScriptPath'") | Out-Null
}

function Main {
  if ($env:OS -ne "Windows_NT") {
    throw "This installer only supports Windows."
  }

  Write-Info "Starting Windows Codex bootstrap..."

  if (-not (Test-IsAdministrator)) {
    Write-Warn "Running without Administrator privileges. First-run WSL setup or distro upgrades often require an elevated PowerShell."
  }

  Ensure-Winget
  Ensure-GitForWindows
  Ensure-WslCommand
  $wslDistro = Ensure-WslUbuntu
  $wslScriptPath = Get-WslScriptPath -WslDistro $wslDistro
  Invoke-WslBootstrap -WslDistro $wslDistro -WslScriptPath $wslScriptPath

  Write-Host ""
  Write-Info "Installation complete."
  Write-Host "Next steps:"
  Write-Host "  1. Open Ubuntu or your preferred WSL shell."
  Write-Host "  2. Run: codex"
  Write-Host "  3. Sign in with ChatGPT or configure API authentication."
}

if ($MyInvocation.InvocationName -ne ".") {
  Main
}
