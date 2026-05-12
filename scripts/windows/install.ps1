Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Info {
  param([string]$Message)
  Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-WarnMessage {
  param([string]$Message)
  Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Test-Command {
  param([string]$Name)
  return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Add-PathEntry {
  param(
    [string]$PathEntry,
    [ValidateSet("Process", "User")]
    [string]$Scope = "Process"
  )

  if ([string]::IsNullOrWhiteSpace($PathEntry)) {
    return
  }

  $target = [System.EnvironmentVariableTarget]::$Scope
  $currentPath = [Environment]::GetEnvironmentVariable("Path", $target)
  $entries = @()

  if (-not [string]::IsNullOrWhiteSpace($currentPath)) {
    $entries = $currentPath -split ";"
  }

  if ($entries -contains $PathEntry) {
    return
  }

  $updatedPath = if ([string]::IsNullOrWhiteSpace($currentPath)) {
    $PathEntry
  } else {
    "$currentPath;$PathEntry"
  }

  [Environment]::SetEnvironmentVariable("Path", $updatedPath, $target)
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

function Ensure-Git {
  $gitPath = "C:\Program Files\Git\cmd"
  if (Test-Path $gitPath) {
    Add-PathEntry -PathEntry $gitPath -Scope Process
    Add-PathEntry -PathEntry $gitPath -Scope User
  }

  if (Test-Command "git") {
    Write-Info "Git already installed: $(& git --version)"
    return
  }

  Write-Info "Installing Git for Windows..."
  Install-WingetPackage -PackageId "Git.Git"

  if (Test-Path $gitPath) {
    Add-PathEntry -PathEntry $gitPath -Scope Process
    Add-PathEntry -PathEntry $gitPath -Scope User
  }

  if (-not (Test-Command "git")) {
    throw "Git installation finished, but git is still not available on PATH."
  }

  Write-Info "Git installed: $(& git --version)"
}

function Ensure-Node {
  $needsInstall = $true
  $nodePath = "C:\Program Files\nodejs"

  if (Test-Path $nodePath) {
    Add-PathEntry -PathEntry $nodePath -Scope Process
    Add-PathEntry -PathEntry $nodePath -Scope User
  }

  if (Test-Command "node") {
    $nodeVersionText = (& node --version).Trim()
    $nodeVersion = [Version]($nodeVersionText.TrimStart("v"))

    if ($nodeVersion.Major -ge 16) {
      $needsInstall = $false
      Write-Info "Node.js already installed: $nodeVersionText"
    } else {
      Write-WarnMessage "Node.js version $nodeVersionText is too old. Upgrading to LTS."
    }
  }

  if ($needsInstall) {
    Write-Info "Installing Node.js LTS..."
    Install-WingetPackage -PackageId "OpenJS.NodeJS.LTS"
  }

  if (Test-Path $nodePath) {
    Add-PathEntry -PathEntry $nodePath -Scope Process
    Add-PathEntry -PathEntry $nodePath -Scope User
  }

  if (-not (Test-Command "node")) {
    throw "Node.js installation finished, but node is still not available on PATH."
  }

  Write-Info "Node.js ready: $(& node --version)"
  Write-Info "npm ready: $(& npm --version)"
}

function Ensure-NpmPrefix {
  $npmPrefix = Join-Path $env:LOCALAPPDATA "npm"

  if (-not (Test-Path $npmPrefix)) {
    New-Item -ItemType Directory -Path $npmPrefix | Out-Null
  }

  & npm config set prefix $npmPrefix | Out-Null
  Add-PathEntry -PathEntry $npmPrefix -Scope Process
  Add-PathEntry -PathEntry $npmPrefix -Scope User

  Write-Info "npm global prefix set to $npmPrefix"
  return $npmPrefix
}

function Ensure-Codex {
  param([string]$NpmPrefix)

  if (Test-Command "codex") {
    Write-Info "Codex CLI already installed: $(& codex --version)"
    return
  }

  $codexShim = Join-Path $NpmPrefix "codex.cmd"
  if (Test-Path $codexShim) {
    Write-Info "Codex CLI already installed: $(& $codexShim --version)"
    return
  }

  Write-Info "Installing Codex CLI..."
  & npm install -g @openai/codex

  if (Test-Command "codex") {
    Write-Info "Codex CLI installed: $(& codex --version)"
    return
  }

  if (-not (Test-Path $codexShim)) {
    throw "Codex installation finished, but codex.cmd was not found."
  }

  Write-Info "Codex CLI installed: $(& $codexShim --version)"
  Write-WarnMessage "Open a new PowerShell window if the 'codex' command is not found immediately."
}

if ($env:OS -ne "Windows_NT") {
  throw "This installer only supports Windows."
}

Write-Info "Starting Windows Codex CLI bootstrap..."
Ensure-Winget
Ensure-Git
Ensure-Node
$npmPrefix = Ensure-NpmPrefix
Ensure-Codex -NpmPrefix $npmPrefix

Write-Host ""
Write-Info "Installation complete."
Write-Host "Next steps:"
Write-Host "  1. Open a new terminal if 'codex' is not found immediately."
Write-Host "  2. Run: codex"
Write-Host "  3. Sign in with ChatGPT or configure API authentication."
