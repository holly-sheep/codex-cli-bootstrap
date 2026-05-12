Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Info {
  param([string]$Message)
  Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Test-Command {
  param([string]$Name)
  return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-WingetPackage {
  param([string]$PackageId)

  & winget install `
    --id $PackageId `
    --exact `
    --source winget `
    --silent `
    --disable-interactivity `
    --accept-package-agreements `
    --accept-source-agreements
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

function Ensure-WslUbuntu {
  Write-Info "Ensuring WSL2 default version..."
  & wsl.exe --set-default-version 2 | Out-Host

  $distros = @(& wsl.exe --list --quiet 2>$null)
  $ubuntuDistro = $null

  foreach ($distro in $distros) {
    if ($distro -match "Ubuntu") {
      $ubuntuDistro = $distro.Trim()
      break
    }
  }

  if ([string]::IsNullOrWhiteSpace($ubuntuDistro)) {
    Write-Info "Installing Ubuntu on WSL..."
    & wsl.exe --install -d Ubuntu | Out-Host
    throw "Ubuntu installation was started. Reboot if Windows asks, launch Ubuntu once to create a Linux user, then rerun this script."
  }

  try {
    & wsl.exe -d $ubuntuDistro -- bash -lc "echo ok" | Out-Null
  } catch {
    throw "Ubuntu is installed but not initialized. Open Ubuntu once, complete Linux user creation, then rerun this script."
  }

  Write-Info "WSL Ubuntu is ready: $ubuntuDistro"
  return $ubuntuDistro
}

function Get-WslScriptPath {
  $windowsPath = (Resolve-Path (Join-Path $PSScriptRoot "..\linux\install.sh")).Path
  $wslPath = (& wsl.exe wslpath -a $windowsPath).Trim()

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
  & wsl.exe -d $WslDistro -- bash -lc "bash '$WslScriptPath'"
}

if ($env:OS -ne "Windows_NT") {
  throw "This installer only supports Windows."
}

Write-Info "Starting Windows Codex bootstrap..."
Ensure-Winget
Ensure-GitForWindows
Ensure-WslCommand
$wslDistro = Ensure-WslUbuntu
$wslScriptPath = Get-WslScriptPath
Invoke-WslBootstrap -WslDistro $wslDistro -WslScriptPath $wslScriptPath

Write-Host ""
Write-Info "Installation complete."
Write-Host "Next steps:"
Write-Host "  1. Open Ubuntu or your preferred WSL shell."
Write-Host "  2. Run: codex"
Write-Host "  3. Sign in with ChatGPT or configure API authentication."
