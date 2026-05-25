<#
.SYNOPSIS
  QuestOps Watchdog - install scheduled task.
.DESCRIPTION
  Creates or updates a Windows Scheduled Task that runs questops_run.ps1
  on a recurring interval. Uses the current user without storing credentials.

  Exit codes:
    0 - task registered or updated successfully
    1 - task operation failed
    2 - project root or questops_run.ps1 missing
    3 - task already exists and -Force not used
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
  [string]$TaskName = "QuestOps Watchdog",
  [string]$ProjectRoot = "",
  [int]$IntervalMinutes = 15,
  [switch]$NoAlert,
  [switch]$Force
)

# Resolve project root
$ScriptDir = Split-Path -Parent -Path $PSCommandPath
if (-not $ScriptDir) {
  Write-Error "Cannot determine script directory. PSCommandPath is empty."
  exit 2
}
if (-not $ProjectRoot) {
  $ProjectRoot = Split-Path -Parent -Path $ScriptDir
}
if (-not $ProjectRoot) {
  Write-Error "Cannot determine project root from script directory: $ScriptDir"
  exit 2
}
$resolvedRoot = Resolve-Path -LiteralPath $ProjectRoot -ErrorAction SilentlyContinue
if (-not $resolvedRoot) {
  Write-Error "Project root path does not resolve: $ProjectRoot"
  exit 2
}
$ProjectRoot = $resolvedRoot.Path

# Validate questops_run.ps1 exists
$runScript = Join-Path -Path $ProjectRoot -ChildPath "scripts\questops_run.ps1"
if (-not (Test-Path -LiteralPath $runScript -PathType Leaf)) {
  Write-Error "questops_run.ps1 not found at: $runScript"
  exit 2
}

# Build command line (needed before ShouldProcess for -WhatIf display)
$exec = "powershell.exe"
# Check if task already exists (skip check in -WhatIf mode)
$existing = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($existing -and (-not $Force) -and (-not $WhatIfPreference)) {
  Write-Error "Task '$TaskName' already exists. Use -Force to update it."
  exit 3
}

$argsList = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$runScript`"")
if ($NoAlert) {
  $argsList += "-NoAlert"
}
$arguments = $argsList -join " "

# Build task components
$action = New-ScheduledTaskAction -Execute $exec -Argument $arguments -WorkingDirectory $ProjectRoot

$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes $IntervalMinutes) -RepetitionDuration ([TimeSpan]::FromDays(365))

$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U -RunLevel Limited

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register task
$params = @{
  TaskName    = $TaskName
  Action      = $action
  Trigger     = $trigger
  Principal   = $principal
  Settings    = $settings
  Force       = $true
}

if ($PSCmdlet.ShouldProcess($TaskName, "Register scheduled task (interval: ${IntervalMinutes}min, alert: $(-not $NoAlert))")) {
  try {
    Register-ScheduledTask @params -ErrorAction Stop | Out-Null
    Write-Host "Task '$TaskName' registered successfully."
    Write-Host "  Interval: $IntervalMinutes minutes"
    Write-Host "  Command: $exec $arguments"
    Write-Host "  Working dir: $ProjectRoot"
    Write-Host "  Run: Start-ScheduledTask -TaskName '$TaskName'"
    exit 0
  } catch {
    Write-Error "Failed to register task: $_"
    exit 1
  }
}
