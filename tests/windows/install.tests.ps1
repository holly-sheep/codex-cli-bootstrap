Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../../scripts/windows/install.ps1"

function Assert-Equal {
  param(
    $Actual,
    $Expected,
    [string]$Message
  )

  if ($Actual -ne $Expected) {
    throw "$Message`nExpected: $Expected`nActual: $Actual"
  }
}

function Assert-NotNull {
  param(
    $Value,
    [string]$Message
  )

  if ($null -eq $Value) {
    throw $Message
  }
}

$sample = @(
  "  NAME                   STATE           VERSION",
  "* Ubuntu-22.04           Running         2",
  "  docker-desktop         Running         2",
  "  Ubuntu                 Stopped         1"
)

$distros = Parse-WslListVerboseOutput -Lines $sample
Assert-Equal -Actual $distros.Count -Expected 3 -Message "Parser should return all distro rows."
Assert-Equal -Actual $distros[0].Name -Expected "Ubuntu-22.04" -Message "Parser should trim distro names."
Assert-Equal -Actual $distros[0].Version -Expected 2 -Message "Parser should read WSL version."
Assert-Equal -Actual $distros[0].IsDefault -Expected $true -Message "Parser should detect the default distro marker."

$selectedDefaultUbuntu = Select-UbuntuDistro -Distros $distros
Assert-NotNull -Value $selectedDefaultUbuntu -Message "Ubuntu selection should succeed when Ubuntu distros exist."
Assert-Equal -Actual $selectedDefaultUbuntu.Name -Expected "Ubuntu-22.04" -Message "Selection should prefer the default Ubuntu distro."

$fallbackDistros = @(
  [pscustomobject]@{ Name = "Debian"; State = "Running"; Version = 2; IsDefault = $true },
  [pscustomobject]@{ Name = "Ubuntu"; State = "Stopped"; Version = 2; IsDefault = $false },
  [pscustomobject]@{ Name = "Ubuntu-24.04"; State = "Stopped"; Version = 2; IsDefault = $false }
)

$selectedExactUbuntu = Select-UbuntuDistro -Distros $fallbackDistros
Assert-Equal -Actual $selectedExactUbuntu.Name -Expected "Ubuntu" -Message "Selection should prefer the exact Ubuntu distro when no default Ubuntu exists."

$noUbuntu = @(
  [pscustomobject]@{ Name = "Debian"; State = "Running"; Version = 2; IsDefault = $true }
)

$selectedMissingUbuntu = Select-UbuntuDistro -Distros $noUbuntu
Assert-Equal -Actual $selectedMissingUbuntu -Expected $null -Message "Selection should return null when no Ubuntu distro exists."

$previousAllowPackageInstalls = $env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS
try {
  $env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = $null
  $blocked = $false
  try {
    Assert-PackageInstallsAllowed
  } catch {
    $blocked = ($_.Exception.Message -like "*Package installation and update steps are currently disabled*")
  }

  Assert-Equal -Actual $blocked -Expected $true -Message "Package installs should be blocked by default."

  $env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = "1"
  Assert-PackageInstallsAllowed
} finally {
  $env:CODEX_BOOTSTRAP_ALLOW_PACKAGE_INSTALLS = $previousAllowPackageInstalls
}

Write-Host "Windows installer unit tests passed."
