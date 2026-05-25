<#
.SYNOPSIS
  QuestOps Watchdog - Discord webhook alert.
.DESCRIPTION
  Reads a health report and sends a Discord alert if any checks failed.
  Requires the QUESTOPS_DISCORD_WEBHOOK_URL environment variable.

  The alert message includes scan timestamp, overall status, per-server
  failure details (folder, disk, process, network, logs, resources),
  and the report path. Messages longer than ~1800 characters are truncated.

  Exit codes:
    0 - alert sent, or no alert needed (report passed and -Force not used)
    2 - QUESTOPS_DISCORD_WEBHOOK_URL environment variable not set
    3 - report file missing or malformed
    4 - Discord webhook send failed
#>

[CmdletBinding()]
param (
  [string]$ReportPath = "",
  [switch]$Force
)

$ScriptDir = Split-Path -Parent -Path $PSCommandPath
if (-not $ReportPath) {
  $ReportPath = Join-Path -Path $ScriptDir -ChildPath "..\reports\latest-health-report.json"
}

# Resolve report path to absolute
$resolvedReport = Resolve-Path -LiteralPath $ReportPath -ErrorAction SilentlyContinue
if (-not $resolvedReport) {
  $err = [PSCustomObject]@{
    exit_code  = 3
    fault      = "MISSING_REPORT"
    message    = "Report file not found: $ReportPath"
    suggestion = "Run questops_scan.ps1 first, then check the path"
  }
  $err
  exit 3
}
$ReportPath = $resolvedReport.Path

# Read report
$report = $null
try {
  $raw = Get-Content -Path $ReportPath -Raw -ErrorAction Stop
  $report = $raw | ConvertFrom-Json -ErrorAction Stop
} catch {
  $err = [PSCustomObject]@{
    exit_code  = 3
    fault      = "MALFORMED_REPORT"
    message    = "Report file is missing or contains invalid JSON: $ReportPath"
    detail     = $_.Exception.Message
    suggestion = "Re-run questops_scan.ps1 to regenerate the report"
  }
  $err
  exit 3
}

# Decide whether to send
if ($report.overall_pass -and (-not $Force)) {
  Write-Verbose "All checks passed. Use -Force to send a test alert."
  [PSCustomObject]@{
    exit_code = 0
    status    = "NO_ALERT_NEEDED"
    message   = "All checks passed. No alert sent."
  }
  exit 0
}

# Check webhook environment variable (only required when actually sending)
$webhookUrl = [Environment]::GetEnvironmentVariable("QUESTOPS_DISCORD_WEBHOOK_URL", "Process")
if (-not $webhookUrl) {
  $err = [PSCustomObject]@{
    exit_code  = 2
    fault      = "MISSING_WEBHOOK_URL"
    message    = "Environment variable QUESTOPS_DISCORD_WEBHOOK_URL is not set"
    suggestion = "Set it for the current session: `$env:QUESTOPS_DISCORD_WEBHOOK_URL = 'https://discord.com/api/webhooks/...'"
  }
  $err
  exit 2
}

# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------

function Get-QuestFailedCategories {
  param($ServerResult)
  $failed = @()
  $props = $ServerResult.PSObject.Properties.Name

  if ($props -contains "folder_exists" -and -not $ServerResult.folder_exists) { $failed += "folder" }
  if ($props -contains "disk_ok" -and -not $ServerResult.disk_ok) { $failed += "disk" }
  if ($props -contains "process_running" -and -not $ServerResult.process_running) { $failed += "process" }

  if ($props -contains "network_ok" -and -not $ServerResult.network_ok) {
    $detail = ""
    if ($props -contains "network_checks") {
      $failedNet = @($ServerResult.network_checks | Where-Object { $_ -and -not $_.passed })
      if ($failedNet.Count -gt 0) {
        $parts = @()
        foreach ($fn in $failedNet) { $parts += "$($fn.host):$($fn.port)" }
        $detail = " (" + ($parts -join ", ") + ")"
      }
    }
    $failed += "network$detail"
  }

  if ($props -contains "logs_ok" -and -not $ServerResult.logs_ok) {
    $detail = ""
    if ($props -contains "log_checks") {
      $failedLog = @($ServerResult.log_checks | Where-Object { $_ -and -not $_.passed })
      if ($failedLog.Count -gt 0) {
        $names = @()
        foreach ($fl in $failedLog) {
          if ($fl.name) { $names += $fl.name } else { $names += $fl.path }
        }
        $detail = " (" + ($names -join ", ") + ")"
      }
    }
    $failed += "logs$detail"
  }

  if ($props -contains "resources_ok" -and -not $ServerResult.resources_ok) {
    $detail = ""
    if ($props -contains "resource_checks") {
      $failedRes = @($ServerResult.resource_checks | Where-Object { $_ -and -not $_.passed })
      if ($failedRes.Count -gt 0) {
        $parts = @()
        foreach ($fr in $failedRes) {
          $s = $fr.process
          if ($fr.PSObject.Properties.Name -contains "memory_ok" -and -not $fr.memory_ok) { $s += " mem" }
          if ($fr.PSObject.Properties.Name -contains "cpu_ok" -and -not $fr.cpu_ok) { $s += " cpu" }
          $parts += $s
        }
        $detail = " (" + ($parts -join ", ") + ")"
      }
    }
    $failed += "resources$detail"
  }

  return $failed
}

function Format-QuestFailedServerLine {
  param($ServerResult)
  $failed = Get-QuestFailedCategories -ServerResult $ServerResult
  $line = "- $($ServerResult.server_name):"
  if ($failed.Count -gt 0) {
    $line += " " + ($failed -join ", ")
  }
  return $line
}

function Limit-QuestDiscordMessage {
  param([string]$Message, [int]$MaxLen = 1800)
  if ($Message.Length -le $MaxLen) { return $Message }

  $truncSuffix = "...truncated. See JSON report for full details."
  $reportIdx = $Message.LastIndexOf("`nReport:")
  $reportLine = ""
  if ($reportIdx -ge 0) { $reportLine = $Message.Substring($reportIdx) }

  $headerEnd = $Message.LastIndexOf("`nFailed servers:")
  if ($headerEnd -lt 0) {
    return $Message.Substring(0, [Math]::Min($MaxLen, $Message.Length)) + "`n$truncSuffix"
  }

  $header = $Message.Substring(0, $headerEnd)

  $serverSectionStart = $headerEnd
  $serverSectionEnd = $Message.Length
  if ($reportIdx -ge 0) { $serverSectionEnd = $reportIdx }
  $serverLines = $Message.Substring($serverSectionStart, $serverSectionEnd - $serverSectionStart)

  $available = $MaxLen - $header.Length - $reportLine.Length - $truncSuffix.Length - 10
  if ($available -lt 20) {
    return $header + "`n$truncSuffix`n$reportLine"
  }

  $lines = $serverLines -split "`n"
  $kept = @()
  $lenSoFar = 0
  foreach ($line in $lines) {
    $candidateLen = $lenSoFar + $line.Length + 1
    if ($candidateLen -gt $available) { break }
    $kept += $line
    $lenSoFar = $candidateLen
  }

  return $header + "`n" + ($kept -join "`n") + "`n$truncSuffix`n$reportLine"
}

function Format-QuestDiscordAlertMessage {
  param($Report, [string]$ReportPath, [bool]$ForceAlert)

  $isForced = $ForceAlert -and $Report.overall_pass
  $lines = @()

  if ($isForced) {
    $lines += ":rocket: QuestOps Watchdog Alert (FORCED TEST)"
    $lines += "All checks passed but -Force was used to send this test alert."
  } elseif (-not $Report.overall_pass) {
    $lines += ":rocket: QuestOps Watchdog Alert"
    $lines += "**One or more server checks failed.**"
  } else {
    $lines += ":rocket: QuestOps Watchdog Alert"
    $lines += "**All checks passed**"
  }

  $lines += ""
  $lines += "Scan: $($Report.scan_timestamp_utc)"
  if ($Report.overall_pass) { $lines += "Status: :white_check_mark: PASS" }
  else { $lines += "Status: :x: FAIL" }
  $lines += "Servers: $($Report.total_servers) total, $($Report.passed_checks) passed, $($Report.failed_checks) failed"

  $failedServers = @($Report.results | Where-Object { -not $_.passed })
  if ($failedServers.Count -gt 0) {
    $lines += ""
    $lines += "Failed servers:"
    foreach ($svr in $failedServers) {
      $lines += Format-QuestFailedServerLine -ServerResult $svr
    }
  }

  $lines += ""
  $lines += "Report: $ReportPath"

  return $lines -join "`n"
}

# ---------------------------------------------------------------------------
# Build and send
# ---------------------------------------------------------------------------

$rawMessage = Format-QuestDiscordAlertMessage -Report $report -ReportPath $ReportPath -ForceAlert $Force.IsPresent
$safeMessage = Limit-QuestDiscordMessage -Message $rawMessage -MaxLen 1800

$body = @{
  content = $safeMessage
} | ConvertTo-Json

try {
  Write-Verbose "Sending Discord alert..."
  $response = Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $body -ContentType "application/json" -ErrorAction Stop
  Write-Verbose "Alert sent successfully."
  [PSCustomObject]@{
    exit_code = 0
    status    = "ALERT_SENT"
    message   = "Discord alert sent."
  }
  exit 0
} catch {
  $err = [PSCustomObject]@{
    exit_code  = 4
    fault      = "WEBHOOK_SEND_FAILED"
    message    = "Failed to send Discord alert"
    detail     = $_.Exception.Message
    suggestion = "Check that the webhook URL is valid and Discord is reachable"
  }
  $err
  exit 4
}
