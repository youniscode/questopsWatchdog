<#
.SYNOPSIS
    Exports a QuestOps Watchdog JSON scan report as a local HTML dashboard.
.DESCRIPTION
    Generates a self-contained static HTML dashboard from a JSON health report
    and optional history files. Inline CSS only, no JavaScript, no external
    dependencies, no server, no database. Safe for local viewing.

    Exit codes:
      0 - dashboard created successfully
      2 - latest report missing
      3 - latest report malformed
      4 - dashboard write failed
      5 - history read warning (non-fatal, dashboard still created)
.PARAMETER ReportPath
    Path to the latest JSON health report (default: reports\latest-health-report.json).
.PARAMETER HistoryDir
    Directory containing historical JSON reports (default: reports\history).
.PARAMETER OutputPath
    Path for the generated dashboard HTML file (default: reports\questops-dashboard.html).
.PARAMETER Title
    Page title for the dashboard (default: QuestOps Watchdog Dashboard).
.PARAMETER MaxHistory
    Maximum number of historical reports to include in the history section (default: 20).
.PARAMETER Open
    Switch to open the generated dashboard in the default browser.
.EXAMPLE
    .\export_questops_dashboard.ps1
    .\export_questops_dashboard.ps1 -ReportPath reports\custom-report.json -OutputPath reports\dashboard.html
    .\export_questops_dashboard.ps1 -Open
    .\export_questops_dashboard.ps1 -MaxHistory 50
.OUTPUTS
    [PSCustomObject] with fields: success, exit_code, dashboard_path
#>

[CmdletBinding()]
param(
    [string]$ReportPath = "",
    [string]$HistoryDir = "",
    [string]$OutputPath = "",
    [string]$Title = "QuestOps Watchdog Dashboard",
    [int]$MaxHistory = 20,
    [switch]$Open
)

$ScriptDir = Split-Path -Parent -Path $PSCommandPath

# Default paths
if (-not $ReportPath) {
    $ReportPath = Join-Path -Path $ScriptDir -ChildPath "..\reports\latest-health-report.json"
}
if (-not $HistoryDir) {
    $HistoryDir = Join-Path -Path $ScriptDir -ChildPath "..\reports\history"
}
if (-not $OutputPath) {
    $OutputPath = Join-Path -Path $ScriptDir -ChildPath "..\reports\questops-dashboard.html"
}

# ---------------------------------------------------------------------------
# Helper: HTML-encode a string
# ---------------------------------------------------------------------------
function ConvertTo-QuestHtmlEncoded {
    param([string]$Value)
    if (-not $Value) { return "" }
    $encoded = $Value
    $encoded = $encoded -replace '&', '&amp;'
    $encoded = $encoded -replace '<', '&lt;'
    $encoded = $encoded -replace '>', '&gt;'
    $encoded = $encoded -replace '"', '&quot;'
    $encoded = $encoded -replace "'", '&#39;'
    return $encoded
}

# ---------------------------------------------------------------------------
# Helper: generate PASS/FAIL badge HTML
# ---------------------------------------------------------------------------
function Get-QuestStatusBadge {
    param([bool]$Value)
    if ($Value) {
        return '<span class="badge badge-pass">PASS</span>'
    }
    return '<span class="badge badge-fail">FAIL</span>'
}

# ---------------------------------------------------------------------------
# Helper: get failed category list for a server
# ---------------------------------------------------------------------------
function Get-QuestFailedCategoryList {
    param([object]$Server)
    $cats = @()

    if ($Server.PSObject.Properties.Name -contains "folder_exists" -and -not $Server.folder_exists) { $cats += "folder" }
    if ($Server.PSObject.Properties.Name -contains "disk_ok" -and -not $Server.disk_ok) { $cats += "disk" }
    if ($Server.PSObject.Properties.Name -contains "process_running" -and -not $Server.process_running) { $cats += "process" }
    if ($Server.PSObject.Properties.Name -contains "network_ok" -and -not $Server.network_ok) { $cats += "network" }
    if ($Server.PSObject.Properties.Name -contains "logs_ok" -and -not $Server.logs_ok) { $cats += "logs" }
    if ($Server.PSObject.Properties.Name -contains "resources_ok" -and -not $Server.resources_ok) { $cats += "resources" }

    return $cats
}

# ---------------------------------------------------------------------------
# Helper: build server table rows HTML
# ---------------------------------------------------------------------------
function Format-QuestDashboardServerRows {
    param([object[]]$Results, [string]$Filter = "all")
    $rows = ""

    $filtered = @($Results)
    if ($Filter -eq "passing") { $filtered = @($Results | Where-Object { $_.passed }) }
    if ($Filter -eq "failing") { $filtered = @($Results | Where-Object { -not $_.passed }) }
    if ($filtered.Count -eq 0) { return "" }

    foreach ($svr in $filtered) {
        $svrPassed = if ($svr.passed) { $true } else { $false }
        $name = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $svr.server_name)
        $folder = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $svr.folder)
        $proc = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $svr.process)
        $diskFree = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $svr.disk_free_human)
        $statusBadge = Get-QuestStatusBadge -Value $svrPassed
        $folderBadge = Get-QuestStatusBadge -Value ($svr.folder_exists -eq $true)
        $diskBadge = Get-QuestStatusBadge -Value ($svr.disk_ok -eq $true)
        $procBadge = Get-QuestStatusBadge -Value ($svr.process_running -eq $true)
        $netOk = ($svr.network_ok -eq $true)
        $logsOk = ($svr.logs_ok -eq $true)
        $resOk = ($svr.resources_ok -eq $true)
        $netBadge = Get-QuestStatusBadge -Value $netOk
        $logsBadge = Get-QuestStatusBadge -Value $logsOk
        $resBadge = Get-QuestStatusBadge -Value $resOk
        $rowClass = if ($svrPassed) { "server-pass" } else { "server-fail" }

        $rows += @"
        <tr class="$rowClass">
            <td class="cell-server">$name $statusBadge</td>
            <td>$folderBadge</td>
            <td>$diskBadge</td>
            <td>$procBadge</td>
            <td>$netBadge</td>
            <td>$logsBadge</td>
            <td>$resBadge</td>
        </tr>
"@
    }

    return $rows
}

# ---------------------------------------------------------------------------
# Helper: generate empty-state HTML for a filter view
# ---------------------------------------------------------------------------
function Get-QuestEmptyState {
    param([string]$Filter)
    if ($Filter -eq "passing") {
        return '<div class="empty-state"><strong>No passing servers</strong><br>All servers have one or more failed checks.</div>'
    }
    if ($Filter -eq "failing") {
        return '<div class="empty-state"><strong>All servers passing</strong><br>No servers have failed checks.</div>'
    }
    return ""
}

# ---------------------------------------------------------------------------
# Helper: build failed server details HTML from a results array
# ---------------------------------------------------------------------------
function Format-QuestDashboardFailedDetails {
    param([object[]]$Results)
    $html = ""

    foreach ($svr in $Results) {
        $svrPassed = if ($svr.passed) { $true } else { $false }
        if ($svrPassed) { continue }

        $name = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $svr.server_name)
        $failedCats = Get-QuestFailedCategoryList -Server $svr
        $catList = ConvertTo-QuestHtmlEncoded -Value ($failedCats -join ", ")

        $html += @"
    <div class="fail-section">
        <h3 class="fail-server-name">$name <span class="badge badge-fail">FAIL</span></h3>
        <p><strong>Failed categories:</strong> $catList</p>
        <ul class="fail-details">
"@

        if ($svr.PSObject.Properties.Name -contains "folder_exists" -and -not $svr.folder_exists) {
            $folderPath = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $svr.folder)
            $html += "<li><strong>Folder:</strong> Not found \u2014 $folderPath</li>`n"
        }

        if ($svr.PSObject.Properties.Name -contains "disk_ok" -and -not $svr.disk_ok) {
            $free = Get-QuestSafeString -Value $svr.disk_free_human
            $threshold = Get-QuestSafeString -Value $svr.disk_threshold
            $html += "<li><strong>Disk:</strong> Free space $free is below threshold of $threshold GB</li>`n"
        }

        if ($svr.PSObject.Properties.Name -contains "process_running" -and -not $svr.process_running) {
            $procName = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $svr.process)
            $html += "<li><strong>Process:</strong> Not running \u2014 $procName</li>`n"
        }

        if ($svr.PSObject.Properties.Name -contains "network_ok" -and -not $svr.network_ok -and $svr.network_checks) {
            foreach ($nc in $svr.network_checks) {
                if ($nc.passed) { continue }
                $ncName = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $nc.name)
                $ncHost = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $nc.host)
                $ncPort = Get-QuestSafeString -Value $nc.port
                $ncError = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $nc.error)
                $html += "<li><strong>Network:</strong> $ncName ($ncHost`:$ncPort) \u2014 $ncError</li>`n"
            }
        }

        if ($svr.PSObject.Properties.Name -contains "logs_ok" -and -not $svr.logs_ok -and $svr.log_checks) {
            foreach ($lc in $svr.log_checks) {
                if ($lc.passed) { continue }
                $lcName = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $lc.name)
                $lcPath = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $lc.path)
                $lcAge = Get-QuestSafeString -Value $lc.age_minutes
                $lcMaxAge = Get-QuestSafeString -Value $lc.max_age_minutes
                $html += "<li><strong>Logs:</strong> $lcName \u2014 $lcPath \u2014 Age $lcAge min (max $lcMaxAge min)</li>`n"
            }
        }

        if ($svr.PSObject.Properties.Name -contains "resources_ok" -and -not $svr.resources_ok -and $svr.resource_checks) {
            foreach ($rc in $svr.resource_checks) {
                if ($rc.passed) { continue }
                $rcName = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $rc.name)
                $rcProc = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $rc.process)
                $mem = Get-QuestSafeString -Value $rc.total_memory_mb
                $maxMem = Get-QuestSafeString -Value $rc.max_memory_mb
                $cpu = Get-QuestSafeString -Value $rc.total_cpu_percent
                $maxCpu = Get-QuestSafeString -Value $rc.max_cpu_percent
                $html += "<li><strong>Resources:</strong> $rcName ($rcProc) \u2014 Mem: $mem / $maxMem MB, CPU: $cpu / $maxCpu%</li>`n"
            }
        }

        $html += "        </ul>`n    </div>`n"
    }

    return $html
}

# ---------------------------------------------------------------------------
# Helper: read a dashboard report JSON file
# ---------------------------------------------------------------------------
function Read-QuestDashboardReport {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $null
    }
    try {
        $raw = Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
        $report = $raw | ConvertFrom-Json -ErrorAction Stop
        return $report
    } catch {
        return $null
    }
}

# ---------------------------------------------------------------------------
# Helper: read history reports, skip bad ones
# ---------------------------------------------------------------------------
function Read-QuestDashboardHistory {
    param([string]$Dir, [int]$Max)
    $historyReports = @()
    $warnings = @()

    if (-not (Test-Path -LiteralPath $Dir -PathType Container)) {
        return @($historyReports, $warnings)
    }

    $files = @(Get-ChildItem -LiteralPath $Dir -Filter "questops-health-*.json" | Sort-Object Name -Descending | Select-Object -First $Max)

    foreach ($f in $files) {
        try {
            $raw = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction Stop
            $report = $raw | ConvertFrom-Json -ErrorAction Stop
            $historyReports += $report
        } catch {
            $warnings += "Skipped malformed history file: $($f.Name) - $($_.Exception.Message)"
        }
    }

    return @($historyReports, $warnings)
}

# ---------------------------------------------------------------------------
# Helper: write the dashboard HTML file
# ---------------------------------------------------------------------------
function Write-QuestDashboardHtml {
    param([string]$Path, [string]$Html)
    $parentDir = Split-Path -Parent -Path $Path
    if (-not (Test-Path -LiteralPath $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }
    try {
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($Path, $Html, $utf8NoBom)
        return $true
    } catch {
        return $false
    }
}

# ---------------------------------------------------------------------------
# Helper: redact Discord webhook URL patterns from a string
# ---------------------------------------------------------------------------
function Get-QuestSafeString {
    param([object]$Value, [string]$Default = "N/A")
    if ($null -eq $Value) { return $Default }
    if ($Value -is [bool]) { return $Value.ToString() }
    $str = "$Value"
    # Redact Discord webhook URLs
    $str = $str -replace 'discord\.com/api/webhooks/[a-zA-Z0-9_/-]+', 'discord.com/api/webhooks/[REDACTED]'
    return $str
}

# ---------------------------------------------------------------------------
# Read latest report
# ---------------------------------------------------------------------------
Write-Verbose "Reading report from: $ReportPath"

if (-not (Test-Path -LiteralPath $ReportPath -PathType Leaf)) {
    Write-Warning "Latest report not found: $ReportPath"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 2; dashboard_path = $OutputPath })
    exit 2
}

$report = $null
try {
    $raw = Get-Content -LiteralPath $ReportPath -Raw -ErrorAction Stop
    $report = $raw | ConvertFrom-Json -ErrorAction Stop
} catch {
    Write-Warning "Report file contains invalid JSON: $ReportPath"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; dashboard_path = $OutputPath })
    exit 3
}

# ---------------------------------------------------------------------------
# Read history reports
# ---------------------------------------------------------------------------
Write-Verbose "Reading history from: $HistoryDir"
$historyResult = Read-QuestDashboardHistory -Dir $HistoryDir -Max $MaxHistory
$historyReports = $historyResult[0]
$historyWarnings = $historyResult[1]

if ($historyWarnings.Count -gt 0) {
    foreach ($w in $historyWarnings) {
        Write-Warning $w
    }
    # Non-fatal; dashboard still created
}

# ---------------------------------------------------------------------------
# Build dashboard data
# ---------------------------------------------------------------------------
$generatedStamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss UTC")
$scanStamp = if ($report.scan_timestamp_utc) { $report.scan_timestamp_utc } else { "N/A" }

$overallPass = if ($report.overall_pass) { $true } else { $false }
$totalServers = if ($report.total_servers -is [int]) { $report.total_servers } else { 0 }
$passedChecks = if ($report.passed_checks -is [int]) { $report.passed_checks } else { 0 }
$failedChecks = if ($report.failed_checks -is [int]) { $report.failed_checks } else { 0 }

$failedServerCount = 0
$results = @()
if ($report.results) {
    foreach ($svr in $report.results) {
        $svrPassed = if ($svr.passed) { $true } else { $false }
        if (-not $svrPassed) { $failedServerCount++ }
        $results += $svr
    }
}
$historyCount = $historyReports.Count

# --- Build data for filter sections ---
$totalCount = $results.Count
$passingServers = @($results | Where-Object { $_.passed })
$failingServers = @($results | Where-Object { -not $_.passed })
$passingCount = $passingServers.Count
$failingCount = $failingServers.Count

# --- Server table rows for each filter ---
$allServerRows = Format-QuestDashboardServerRows -Results $results
$passingServerRows = Format-QuestDashboardServerRows -Results $results -Filter "passing"
$failingServerRows = Format-QuestDashboardServerRows -Results $results -Filter "failing"

# --- Empty states ---
$passingEmpty = if ($passingCount -eq 0) { Get-QuestEmptyState -Filter "passing" } else { "" }
$failingEmpty = if ($failingCount -eq 0) { Get-QuestEmptyState -Filter "failing" } else { "" }

# --- Failed server details (for all and failing views) ---
$failedDetailsAll = Format-QuestDashboardFailedDetails -Results $results
$failedDetailsFailing = Format-QuestDashboardFailedDetails -Results $failingServers

# --- History summary section ---
$historyRows = ""
$passCount = 0
$failCount = 0
$mostRecentFailTimestamp = $null

$allReports = @()
$allReports += $historyReports

foreach ($hr in $allReports) {
    $hrPassed = if ($hr.overall_pass) { $true } else { $false }
    if ($hrPassed) { $passCount++ } else { $failCount++ }

    $ts = Get-QuestSafeString -Value $hr.scan_timestamp_utc
    if (-not $hrPassed) {
        if (-not $mostRecentFailTimestamp -or $ts -gt $mostRecentFailTimestamp) {
            $mostRecentFailTimestamp = $ts
        }
    }
}

$latestPassed = if ($report.overall_pass) { $true } else { $false }
if ($historyReports.Count -eq 0) {
    if ($latestPassed) { $passCount = 1 } else { $failCount = 1 }
}

foreach ($hr in $historyReports) {
    $hrPassed = if ($hr.overall_pass) { $true } else { $false }
    $ts = ConvertTo-QuestHtmlEncoded -Value (Get-QuestSafeString -Value $hr.scan_timestamp_utc)
    $total = Get-QuestSafeString -Value $hr.total_servers
    $failed = Get-QuestSafeString -Value $hr.failed_checks
    $failedServers = 0
    if ($hr.results) {
        foreach ($svr in $hr.results) {
            if (-not $svr.passed) { $failedServers++ }
        }
    }
    $historyBadge = Get-QuestStatusBadge -Value $hrPassed
    $rowClass = if ($hrPassed) { "history-pass" } else { "history-fail" }

    $historyRows += @"
        <tr class="$rowClass">
            <td>$ts</td>
            <td>$historyBadge</td>
            <td>$total</td>
            <td>$failed</td>
            <td>$failedServers</td>
        </tr>
"@
}

# --- Trend summary ---
$trendHtml = @"
        <div class="trend-card">
            <h3>Trend Summary</h3>
            <table class="trend-table">
                <tr><th>Metric</th><th>Value</th></tr>
                <tr><td>PASS reports</td><td><span class="trend-pass">$passCount</span></td></tr>
                <tr><td>FAIL reports</td><td><span class="trend-fail">$failCount</span></td></tr>
                <tr><td>Most recent failure</td><td>$mostRecentFailTimestamp</td></tr>
            </table>
        </div>
"@

# --- Links / references ---
$latestJsonPath = Resolve-Path -LiteralPath $ReportPath -ErrorAction SilentlyContinue
$latestJsonDisplay = if ($latestJsonPath) { $latestJsonPath.Path } else { $ReportPath }

$latestHtmlPath = Join-Path -Path (Split-Path -Parent -Path (Join-Path -Path $ScriptDir -ChildPath "..\reports\latest-health-report.html")) -ChildPath "latest-health-report.html"
$latestHtmlDisplay = "N/A"
if (Test-Path -LiteralPath $latestHtmlPath) {
    $resolvedHtml = Resolve-Path -LiteralPath $latestHtmlPath -ErrorAction SilentlyContinue
    if ($resolvedHtml) { $latestHtmlDisplay = $resolvedHtml.Path }
}

# --- Build full HTML ---
$safeTitle = ConvertTo-QuestHtmlEncoded -Value $Title
$overallBadge = Get-QuestStatusBadge -Value $overallPass

$historyWarningHtml = ""
if ($historyWarnings.Count -gt 0) {
    $historyWarningHtml = @"
    <div class="warning-section">
        <h3>History Warnings</h3>
        <ul>
"@
    foreach ($w in $historyWarnings) {
        $safeW = ConvertTo-QuestHtmlEncoded -Value $w
        $historyWarningHtml += "<li>$safeW</li>`n"
    }
    $historyWarningHtml += "        </ul>`n    </div>`n"
}

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>$safeTitle</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background: #f0f2f5; color: #1a1a2e; line-height: 1.6; padding: 24px; }
.container { max-width: 1200px; margin: 0 auto; }
h1 { font-size: 1.5em; margin-bottom: 2px; color: #111; font-weight: 700; }
h2 { font-size: 1.1em; margin: 24px 0 12px; color: #222; border-bottom: 2px solid #e0e3e8; padding-bottom: 6px; }
h3 { font-size: 1em; margin: 0 0 8px; color: #444; font-weight: 600; }
.header-meta { font-size: 0.82em; color: #777; margin-bottom: 24px; }
.header-meta p { margin: 1px 0; }
.overall-row { display: flex; align-items: center; gap: 12px; margin-bottom: 24px; }
.overall-row h2 { margin: 0; border: none; padding: 0; }
.stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 12px; margin-bottom: 28px; }
.stat-card { background: #fff; border: 1px solid #e0e3e8; border-radius: 10px; padding: 18px 14px; text-align: center; box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
.stat-card .stat-value { font-size: 1.8em; font-weight: 700; line-height: 1.2; }
.stat-card .stat-label { font-size: 0.75em; color: #777; margin-top: 6px; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 600; }
.stat-pass .stat-value { color: #1a7f37; }
.stat-fail .stat-value { color: #cf222e; }
.badge { display: inline-block; padding: 2px 10px; border-radius: 4px; font-size: 0.78em; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; vertical-align: middle; line-height: 1.4; }
.badge-pass { background: #dafbe1; color: #1a7f37; border: 1px solid #a6e3b1; }
.badge-fail { background: #ffebe9; color: #cf222e; border: 1px solid #ffb8b0; }
.filter-controls { margin-bottom: 16px; }
.filter-radio { position: absolute; opacity: 0; width: 0; height: 0; }
.filter-tabs { display: flex; gap: 4px; flex-wrap: wrap; }
.filter-tabs label { display: inline-block; padding: 8px 20px; font-size: 0.88em; font-weight: 600; border: 1px solid #d0d4dc; border-radius: 6px 6px 0 0; background: #f5f7fa; color: #555; cursor: pointer; user-select: none; }
.filter-tabs label:hover { background: #e8eaed; }
.filter-content { display: none; }
#filter-all:checked ~ .filter-tabs label[for="filter-all"],
#filter-passing:checked ~ .filter-tabs label[for="filter-passing"],
#filter-failing:checked ~ .filter-tabs label[for="filter-failing"] { background: #fff; color: #111; border-bottom-color: #fff; }
#filter-all:checked ~ .filter-sections .filter-section[data-filter="all"],
#filter-passing:checked ~ .filter-sections .filter-section[data-filter="passing"],
#filter-failing:checked ~ .filter-sections .filter-section[data-filter="failing"] { display: block; }
.table-wrapper { overflow-x: auto; margin-bottom: 20px; border-radius: 8px; border: 1px solid #e0e3e8; background: #fff; }
.server-table { width: 100%; border-collapse: collapse; font-size: 0.85em; border: none; }
.server-table th { background: #f0f2f5; text-align: left; padding: 10px 12px; font-weight: 600; border-bottom: 2px solid #d0d4dc; font-size: 0.8em; text-transform: uppercase; letter-spacing: 0.3px; color: #444; white-space: nowrap; }
.server-table td { padding: 10px 12px; border-bottom: 1px solid #e8eaed; vertical-align: middle; }
.server-table tr:last-child td { border-bottom: none; }
.server-table .cell-server { min-width: 180px; font-weight: 600; }
.server-table .cell-server .badge { float: right; margin-top: 1px; }
.server-pass td { background: #f6fdf8; }
.server-fail td { background: #fff5f5; }
.server-fail .cell-server { border-left: 3px solid #cf222e; }
.server-pass .cell-server { border-left: 3px solid #1a7f37; }
.server-table td .badge { font-size: 0.72em; }
.filter-section h2 .badge { font-size: 0.75em; vertical-align: middle; margin-left: 6px; }
.fail-section { background: #fff; border: 1px solid #e0e3e8; border-radius: 8px; padding: 14px 18px; margin-bottom: 12px; border-left: 3px solid #cf222e; box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
.fail-server-name { font-size: 1em; margin-bottom: 6px; color: #cf222e; }
.fail-server-name .badge { font-size: 0.7em; vertical-align: middle; margin-left: 6px; }
.fail-details { margin: 8px 0 0 18px; font-size: 0.88em; }
.fail-details li { margin-bottom: 4px; color: #333; }
.fail-details li strong { color: #111; }
.history-section { margin-bottom: 20px; }
.history-wrapper { overflow-x: auto; border-radius: 8px; border: 1px solid #e0e3e8; background: #fff; }
.history-table { width: 100%; border-collapse: collapse; font-size: 0.83em; border: none; }
.history-table th { background: #f0f2f5; text-align: left; padding: 8px 10px; font-weight: 600; border-bottom: 2px solid #d0d4dc; font-size: 0.78em; text-transform: uppercase; letter-spacing: 0.3px; color: #444; white-space: nowrap; }
.history-table td { padding: 8px 10px; border-bottom: 1px solid #e8eaed; }
.history-table tr:last-child td { border-bottom: none; }
.history-pass td { background: #f6fdf8; }
.history-fail td { background: #fff5f5; }
.history-table .badge { font-size: 0.68em; }
.trend-section { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px; margin-bottom: 20px; }
.trend-card { background: #fff; border: 1px solid #e0e3e8; border-radius: 8px; padding: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
.trend-card h3 { font-size: 0.92em; margin-bottom: 10px; color: #555; border: none; padding: 0; }
.trend-table { width: 100%; border-collapse: collapse; font-size: 0.85em; }
.trend-table th { text-align: left; padding: 5px 8px; font-weight: 600; border-bottom: 1px solid #e0e3e8; background: #fafbfc; }
.trend-table td { padding: 5px 8px; border-bottom: 1px solid #e8eaed; }
.trend-table tr:last-child td { border-bottom: none; }
.trend-pass { color: #1a7f37; font-weight: 700; }
.trend-fail { color: #cf222e; font-weight: 700; }
.references { font-size: 0.83em; color: #666; border-top: 1px solid #e0e3e8; padding-top: 16px; margin-top: 14px; }
.references p { margin: 3px 0; }
.references code { background: #f0f2f5; padding: 1px 5px; border-radius: 3px; font-size: 0.9em; }
.warning-section { background: #fff8e1; border: 1px solid #f0c000; border-radius: 8px; padding: 12px 16px; margin-bottom: 16px; }
.warning-section h3 { color: #8a6d00; margin-bottom: 6px; font-size: 0.95em; border: none; padding: 0; }
.warning-section ul { margin-left: 18px; font-size: 0.88em; }
.warning-section li { margin-bottom: 3px; color: #5a4a00; }
.empty-state { text-align: center; padding: 28px 16px; color: #777; font-size: 0.9em; background: #fafbfc; border: 1px dashed #d0d4dc; border-radius: 8px; margin-bottom: 20px; }
.empty-state strong { color: #555; }
@media print {
  body { background: #fff; padding: 10px; font-size: 11pt; }
  .filter-controls { display: none !important; }
  .filter-content { display: block !important; }
  .stats-grid { break-inside: avoid; page-break-inside: avoid; }
  .table-wrapper { break-inside: avoid; page-break-inside: avoid; border: 1px solid #ccc; }
  .fail-section { break-inside: avoid; page-break-inside: avoid; }
  .history-wrapper { break-inside: avoid; page-break-inside: avoid; }
  .trend-section { break-inside: avoid; page-break-inside: avoid; }
  .overall-row { break-inside: avoid; page-break-inside: avoid; }
  .warning-section { display: none !important; }
  .empty-state { border: 1px solid #ccc; }
}
@media (max-width: 768px) {
  body { padding: 12px; }
  .stats-grid { grid-template-columns: repeat(2, 1fr); gap: 8px; }
  .stat-card { padding: 12px 10px; }
  .stat-card .stat-value { font-size: 1.4em; }
  .server-table { font-size: 0.75em; }
  .server-table th, .server-table td { padding: 6px 6px; }
  .server-table .cell-server { min-width: 100px; }
  .filter-tabs label { padding: 6px 12px; font-size: 0.8em; }
}
</style>
</head>
<body>
<div class="container">

<h1>$safeTitle</h1>
<div class="header-meta">
<p>Generated: $(ConvertTo-QuestHtmlEncoded -Value $generatedStamp)</p>
<p>Latest scan: $(ConvertTo-QuestHtmlEncoded -Value $scanStamp)</p>
</div>

<div class="overall-row">
    <h2>Overall Status</h2>
    $overallBadge
</div>

<div class="stats-grid">
    <div class="stat-card $(if ($totalServers -gt 0) { 'stat-pass' } else { 'stat-fail' })">
        <div class="stat-value">$(ConvertTo-QuestHtmlEncoded -Value "$totalServers")</div>
        <div class="stat-label">Total Servers</div>
    </div>
    <div class="stat-card stat-pass">
        <div class="stat-value">$(ConvertTo-QuestHtmlEncoded -Value "$passedChecks")</div>
        <div class="stat-label">Passed</div>
    </div>
    <div class="stat-card $(if ($failedChecks -eq 0) { 'stat-pass' } else { 'stat-fail' })">
        <div class="stat-value">$(ConvertTo-QuestHtmlEncoded -Value "$failedChecks")</div>
        <div class="stat-label">Failed</div>
    </div>
    <div class="stat-card $(if ($failedServerCount -eq 0) { 'stat-pass' } else { 'stat-fail' })">
        <div class="stat-value">$(ConvertTo-QuestHtmlEncoded -Value "$failedServerCount")</div>
        <div class="stat-label">Failed Servers</div>
    </div>
    <div class="stat-card">
        <div class="stat-value">$(ConvertTo-QuestHtmlEncoded -Value "$historyCount")</div>
        <div class="stat-label">History Loaded</div>
    </div>
</div>

$historyWarningHtml

<div class="filter-controls">
<input type="radio" name="filter" id="filter-all" class="filter-radio" checked>
<input type="radio" name="filter" id="filter-passing" class="filter-radio">
<input type="radio" name="filter" id="filter-failing" class="filter-radio">

<div class="filter-tabs">
    <label for="filter-all">All Servers ($totalCount)</label>
    <label for="filter-passing">Passing ($passingCount)</label>
    <label for="filter-failing">Failing ($failingCount)</label>
</div>

<div class="filter-sections">

<div class="filter-section filter-content" data-filter="all">
    <h2>All Servers</h2>
    <div class="table-wrapper">
    <table class="server-table">
        <tr><th>Server</th><th>Folder</th><th>Disk</th><th>Process</th><th>Network</th><th>Logs</th><th>Resources</th></tr>
$allServerRows
    </table>
    </div>
    <h2>Failed Server Details</h2>
$failedDetailsAll
</div>

<div class="filter-section filter-content" data-filter="passing">
    <h2>Passing Servers <span class="badge badge-pass">PASS</span></h2>
$passingEmpty
    <div class="table-wrapper">
    <table class="server-table">
        <tr><th>Server</th><th>Folder</th><th>Disk</th><th>Process</th><th>Network</th><th>Logs</th><th>Resources</th></tr>
$passingServerRows
    </table>
    </div>
</div>

<div class="filter-section filter-content" data-filter="failing">
    <h2>Failing Servers <span class="badge badge-fail">FAIL</span></h2>
$failingEmpty
    <div class="table-wrapper">
    <table class="server-table">
        <tr><th>Server</th><th>Folder</th><th>Disk</th><th>Process</th><th>Network</th><th>Logs</th><th>Resources</th></tr>
$failingServerRows
    </table>
    </div>
    <h2>Failed Server Details</h2>
$failedDetailsFailing
</div>

</div>
</div>

<h2>History Summary</h2>
<div class="history-section">
<div class="history-wrapper">
<table class="history-table">
    <tr><th>Timestamp</th><th>Status</th><th>Servers</th><th>Failed Checks</th><th>Failed Servers</th></tr>
$historyRows
</table>
</div>
</div>

<h2>Trend Summary</h2>
<div class="trend-section">
$trendHtml
</div>

<div class="references">
    <p><strong>References</strong></p>
    <p>Latest JSON report: <code>$(ConvertTo-QuestHtmlEncoded -Value $latestJsonDisplay)</code></p>
    <p>Latest HTML report: <code>$(ConvertTo-QuestHtmlEncoded -Value $latestHtmlDisplay)</code></p>
    <p>Audit results bundle: Created via <code>export_questops_audit_results.ps1</code></p>
</div>

</div>
</body>
</html>
"@

# ---------------------------------------------------------------------------
# Write dashboard file
# ---------------------------------------------------------------------------
$writeOk = Write-QuestDashboardHtml -Path $OutputPath -Html $html

if (-not $writeOk) {
    Write-Warning "Failed to write dashboard: $OutputPath"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 4; dashboard_path = $OutputPath })
    exit 4
}

Write-Host "Dashboard written: $OutputPath"

if ($Open) {
    Start-Process -FilePath $OutputPath
}

$exitCode = if ($historyWarnings.Count -gt 0) { 5 } else { 0 }

Write-Output ([PSCustomObject]@{
    success        = $true
    exit_code      = $exitCode
    dashboard_path = $OutputPath
})
exit $exitCode



