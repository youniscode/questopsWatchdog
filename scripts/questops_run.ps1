<#
.SYNOPSIS
  QuestOps Watchdog - run scan then optionally send Discord alert.
.DESCRIPTION
  Orchestrates questops_scan.ps1 followed by questops_discord_alert.ps1.
  Supports -NoAlert to skip the alert step, and -ForceAlert to force a
  test notification even if all checks passed.

  Report history: after each scan, a timestamped copy is saved to
  reports\history\questops-health-YYYYMMDD-HHMMSS.json. The most recent
  N copies are retained (default 20, configurable via -KeepReports).

  Logging: run activity is appended to logs\questops-run.log.

  Exit codes:
    0 - scan passed and alert step succeeded or was skipped
    1 - scan completed but one or more checks failed
    2 - scan config missing
    3 - scan config malformed or report malformed
    4 - report path invalid or Discord send failed
#>

[CmdletBinding()]
param (
  [string]$ConfigPath = "",
  [string]$ReportPath = "",
  [switch]$NoAlert,
  [switch]$ForceAlert,
  [string]$LogPath = "",
  [int]$KeepReports = 20,
  [int]$KeepLogs = 10,
  [switch]$NoRetention
)

$ScriptDir = Split-Path -Parent -Path $PSCommandPath
$ProjectRoot = Split-Path -Parent -Path $ScriptDir

# Helper functions

function Write-QuestLog {
  param([string]$Message)
  $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
  $line = "[$timestamp] $Message"
  Write-Host $line
  if ($script:QuestLogFilePath) {
    Add-Content -Path $script:QuestLogFilePath -Value $line -ErrorAction SilentlyContinue
  }
}

function Copy-QuestTimestampedReport {
  param([string]$ReportPath, [string]$HistoryDir)
  if (-not (Test-Path -LiteralPath $ReportPath -PathType Leaf)) { return }
  $stamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
  $dest = Join-Path -Path $HistoryDir -ChildPath "questops-health-$stamp.json"
  if (-not (Test-Path -LiteralPath $HistoryDir)) {
    New-Item -ItemType Directory -Path $HistoryDir -Force | Out-Null
  }
  Copy-Item -LiteralPath $ReportPath -Destination $dest -Force
  Write-QuestLog "Report copy written: $dest"
}

function Invoke-QuestReportRetention {
  param([int]$Keep)
  $historyDir = Join-Path -Path $ProjectRoot -ChildPath "reports\history"
  if (-not (Test-Path -LiteralPath $historyDir)) { return }
  $files = @(Get-ChildItem -LiteralPath $historyDir -Filter "questops-health-*.json" | Sort-Object Name -Descending)
  if ($files.Count -le $Keep) {
    Write-QuestLog "Retention: $($files.Count) historical reports (max $Keep) -- no cleanup needed"
    return
  }
  $toDelete = $files | Select-Object -Skip $Keep
  $deleted = 0
  foreach ($f in $toDelete) {
    Remove-Item -LiteralPath $f.FullName -Force -ErrorAction SilentlyContinue
    $deleted++
  }
  Write-QuestLog "Retention: deleted $deleted historical reports, kept $Keep"
}

# Default paths

if (-not $ConfigPath) {
  $ConfigPath = Join-Path -Path $ScriptDir -ChildPath "..\config\servers.example.json"
}
if (-not $ReportPath) {
  $ReportPath = Join-Path -Path $ScriptDir -ChildPath "..\reports\latest-health-report.json"
}
if (-not $LogPath) {
  $LogPath = Join-Path -Path $ProjectRoot -ChildPath "logs\questops-run.log"
}

# Ensure logs folder exists
$logDir = Split-Path -Parent -Path $LogPath
if (-not (Test-Path -LiteralPath $logDir)) {
  New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

$script:QuestLogFilePath = $LogPath

# Ensure reports\history folder exists
$historyDir = Join-Path -Path $ProjectRoot -ChildPath "reports\history"
if (-not (Test-Path -LiteralPath $historyDir)) {
  New-Item -ItemType Directory -Path $historyDir -Force | Out-Null
}

Write-QuestLog "Run started"
Write-QuestLog "ConfigPath: $ConfigPath"
Write-QuestLog "ReportPath: $ReportPath"
Write-QuestLog "LogPath: $LogPath"
Write-QuestLog "KeepReports: $KeepReports"
Write-QuestLog "Note: -KeepLogs ($KeepLogs) is reserved -- log rotation not yet implemented"
if ($NoRetention) { Write-QuestLog "Retention: disabled (-NoRetention)" }

# Step 1: Run health scan
Write-QuestLog "Scan started"

$scanScript = Join-Path -Path $ScriptDir -ChildPath "questops_scan.ps1"
& $scanScript -ConfigPath $ConfigPath -ReportPath $ReportPath
$scanExit = $LASTEXITCODE

Write-QuestLog "Scan exit code: $scanExit"

Copy-QuestTimestampedReport -ReportPath $ReportPath -HistoryDir $historyDir

if ($scanExit -ge 2) {
  Write-QuestLog "Scan failed with code $scanExit -- skipping alert"
  if (-not $NoRetention) {
    Invoke-QuestReportRetention -Keep $KeepReports
  } else {
    Write-QuestLog "Retention skipped (-NoRetention)"
  }
  Write-QuestLog "Run finished (exit code: $scanExit)"
  exit $scanExit
}

# Step 2: Run Discord alert
if ($NoAlert) {
  Write-QuestLog "Alert skipped (-NoAlert specified)"
  if (-not $NoRetention) {
    Invoke-QuestReportRetention -Keep $KeepReports
  } else {
    Write-QuestLog "Retention skipped (-NoRetention)"
  }
  Write-QuestLog "Run finished (exit code: $scanExit)"
  exit $scanExit
}

Write-QuestLog "Alert starting"

$alertScript = Join-Path -Path $ScriptDir -ChildPath "questops_discord_alert.ps1"
$alertParams = @{ ReportPath = $ReportPath }
if ($ForceAlert) { $alertParams.Force = $true }
& $alertScript @alertParams
$alertExit = $LASTEXITCODE

if ($alertExit -eq 0) {
  Write-QuestLog "Alert sent"
} else {
  Write-QuestLog "Alert failed (exit code: $alertExit)"
}

# Step 3: Report retention cleanup
if (-not $NoRetention) {
  Invoke-QuestReportRetention -Keep $KeepReports
} else {
  Write-QuestLog "Retention skipped (-NoRetention)"
}

if ($alertExit -ne 0) {
  Write-QuestLog "Run finished (exit code: 4)"
  exit 4
}

Write-QuestLog "Run finished (exit code: $scanExit)"
exit $scanExit
