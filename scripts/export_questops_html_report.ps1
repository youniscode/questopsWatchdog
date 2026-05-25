<#
.SYNOPSIS
    Exports a QuestOps Watchdog JSON scan report as a standalone HTML file.
.DESCRIPTION
    Reads a JSON scan report and generates a self-contained HTML file
    with inline CSS. No external dependencies, no JavaScript, no CDN.
    Safe for client delivery and print-to-PDF.
.PARAMETER ReportPath
    Path to the JSON scan report (default: reports\latest-health-report.json).
.PARAMETER OutputPath
    Path for the generated HTML file (default: reports\latest-health-report.html).
.PARAMETER Title
    Page title for the HTML report (default: QuestOps Watchdog Audit Report).
.PARAMETER Open
    Switch to open the generated HTML in the default browser.
.EXAMPLE
    .\export_questops_html_report.ps1
    .\export_questops_html_report.ps1 -ReportPath reports\custom-report.json -OutputPath reports\audit.html
    .\export_questops_html_report.ps1 -Open
.OUTPUTS
    [PSCustomObject] with fields: success, exit_code, html_path
#>

[CmdletBinding()]
param(
    [string]$ReportPath = "",
    [string]$OutputPath = "",
    [string]$Title = "QuestOps Watchdog Audit Report",
    [switch]$Open
)

$ScriptDir = Split-Path -Parent -Path $PSCommandPath

# Default paths
if (-not $ReportPath) {
    $ReportPath = Join-Path -Path $ScriptDir -ChildPath "..\reports\latest-health-report.json"
}

if (-not $OutputPath) {
    $OutputPath = Join-Path -Path $ScriptDir -ChildPath "..\reports\latest-health-report.html"
}

# ---------------------------------------------------------------------------
# Helper: HTML-encode a string (replace &, <, >, ", ')
# ---------------------------------------------------------------------------
function ConvertTo-HtmlEncoded {
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
# Helper: format a nullable value for display
# ---------------------------------------------------------------------------
function Format-HtmlValue {
    param(
        [string]$Label,
        $Value,
        [switch]$IsBool
    )
    if ($null -eq $Value -and $Value -isnot [bool]) { return "<td class=""value-null"">N/A</td>" }
    if ($IsBool) {
        if ($Value) {
            return "<td class=""value-true""><span class=""badge badge-pass"">PASS</span></td>"
        } else {
            return "<td class=""value-false""><span class=""badge badge-fail"">FAIL</span></td>"
        }
    }
    $display = ConvertTo-HtmlEncoded -Value "$Value"
    return "<td>$display</td>"
}

# ---------------------------------------------------------------------------
# Helper: boolean badge HTML
# ---------------------------------------------------------------------------
function Get-BadgeHtml {
    param([bool]$Value)
    if ($Value) {
        return '<span class="badge badge-pass">PASS</span>'
    }
    return '<span class="badge badge-fail">FAIL</span>'
}

# ---------------------------------------------------------------------------
# Read report
# ---------------------------------------------------------------------------
Write-Verbose "Reading report from: $ReportPath"

if (-not (Test-Path -LiteralPath $ReportPath -PathType Leaf)) {
    Write-Warning "Report file not found: $ReportPath"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 2; html_path = $OutputPath })
    exit 2
}

$report = $null
try {
    $raw = Get-Content -LiteralPath $ReportPath -Raw -ErrorAction Stop
    $report = $raw | ConvertFrom-Json -ErrorAction Stop
} catch {
    Write-Warning "Report file contains invalid JSON: $ReportPath"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; html_path = $OutputPath })
    exit 3
}

# ---------------------------------------------------------------------------
# Generate HTML
# ---------------------------------------------------------------------------
$generatedStamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss UTC")
$scanStamp = if ($report.scan_timestamp_utc) { $report.scan_timestamp_utc } else { "N/A" }

$overallPass = if ($report.overall_pass) { $true } else { $false }
$overallBadge = Get-BadgeHtml -Value $overallPass

$totalServers = if ($report.total_servers -is [int]) { $report.total_servers } else { 0 }
$passedChecks = if ($report.passed_checks -is [int]) { $report.passed_checks } else { 0 }
$failedChecks = if ($report.failed_checks -is [int]) { $report.failed_checks } else { 0 }

# Count failed servers
$failedServerCount = 0
$serverRows = ""
if ($report.results) {
    foreach ($svr in $report.results) {
        $svrPassed = if ($svr.passed) { $true } else { $false }
        if (-not $svrPassed) { $failedServerCount++ }

        $serverName = ConvertTo-HtmlEncoded -Value "$($svr.server_name)"
        $folderPath = ConvertTo-HtmlEncoded -Value "$($svr.folder)"
        $procName = ConvertTo-HtmlEncoded -Value "$($svr.process)"
        $procPid = if ($svr.process_pid) { "$($svr.process_pid)" } else { "N/A" }

        $serverBadge = Get-BadgeHtml -Value $svrPassed
        $folderBadge = Get-BadgeHtml -Value ($svr.folder_exists -eq $true)
        $diskBadge = Get-BadgeHtml -Value ($svr.disk_ok -eq $true)
        $procBadge = Get-BadgeHtml -Value ($svr.process_running -eq $true)
        $netBadge = Get-BadgeHtml -Value ($svr.network_ok -eq $true)
        $logsBadge = Get-BadgeHtml -Value ($svr.logs_ok -eq $true)
        $resBadge = Get-BadgeHtml -Value ($svr.resources_ok -eq $true)

        $diskFree = if ($svr.disk_free_human) { ConvertTo-HtmlEncoded -Value "$($svr.disk_free_human)" } else { "N/A" }
        $diskThreshold = if ($svr.disk_threshold -is [int] -or $svr.disk_threshold -is [double]) { "$($svr.disk_threshold) GB" } else { "N/A" }

        $rowClass = if ($svrPassed) { "server-pass" } else { "server-fail" }

        $serverRows += @"
<div class="server-section $rowClass">
    <h2 class="server-name">$serverName $serverBadge</h2>
    <table class="detail-table">
        <tr><th>Check</th><th>Status</th><th>Detail</th></tr>
        <tr>
            <td>Folder</td>
            <td>$folderBadge</td>
            <td>$folderPath</td>
        </tr>
        <tr>
            <td>Disk Space</td>
            <td>$diskBadge</td>
            <td>Free: $diskFree (Threshold: $diskThreshold)</td>
        </tr>
        <tr>
            <td>Process</td>
            <td>$procBadge</td>
            <td>$procName (PID: $procPid)</td>
        </tr>
        <tr>
            <td>Network</td>
            <td>$netBadge</td>
            <td></td>
        </tr>
        <tr>
            <td>Logs</td>
            <td>$logsBadge</td>
            <td></td>
        </tr>
        <tr>
            <td>Resources</td>
            <td>$resBadge</td>
            <td></td>
        </tr>
    </table>

"@

        # Network checks detail
        if ($svr.network_checks -and @($svr.network_checks).Count -gt 0) {
            $serverRows += @"
    <h3>Network Check Details</h3>
    <table class="detail-table sub-table">
        <tr><th>Name</th><th>Host</th><th>Port</th><th>Reachable</th><th>Passed</th><th>Error</th></tr>
"@
            foreach ($nc in $svr.network_checks) {
                $ncName = ConvertTo-HtmlEncoded -Value "$($nc.name)"
                $ncHost = ConvertTo-HtmlEncoded -Value "$($nc.host)"
                $ncPort = if ($nc.port) { "$($nc.port)" } else { "N/A" }
                $ncReachable = if ($nc.reachable) { '<span class="badge badge-pass">Yes</span>' } else { '<span class="badge badge-fail">No</span>' }
                $ncPassed = if ($nc.passed) { '<span class="badge badge-pass">PASS</span>' } else { '<span class="badge badge-fail">FAIL</span>' }
                $ncError = ConvertTo-HtmlEncoded -Value "$($nc.error)"
                $serverRows += "<tr><td>$ncName</td><td>$ncHost</td><td>$ncPort</td><td>$ncReachable</td><td>$ncPassed</td><td>$ncError</td></tr>`n"
            }
            $serverRows += "    </table>`n"
        }

        # Log checks detail
        if ($svr.log_checks -and @($svr.log_checks).Count -gt 0) {
            $serverRows += @"
    <h3>Log Check Details</h3>
    <table class="detail-table sub-table">
        <tr><th>Name</th><th>Path</th><th>Exists</th><th>Last Write</th><th>Age (min)</th><th>Max Age (min)</th><th>Fresh</th><th>Passed</th><th>Error</th></tr>
"@
            foreach ($lc in $svr.log_checks) {
                $lcName = ConvertTo-HtmlEncoded -Value "$($lc.name)"
                $lcPath = ConvertTo-HtmlEncoded -Value "$($lc.path)"
                $lcExists = if ($lc.exists) { '<span class="badge badge-pass">Yes</span>' } else { '<span class="badge badge-fail">No</span>' }
                $lcLastWrite = ConvertTo-HtmlEncoded -Value "$($lc.last_write_time)"
                $lcAge = if ($lc.age_minutes -is [int] -or $lc.age_minutes -is [double]) { "$($lc.age_minutes)" } else { "N/A" }
                $lcMaxAge = if ($lc.max_age_minutes -is [int]) { "$($lc.max_age_minutes)" } else { "N/A" }
                $lcFresh = if ($lc.fresh) { '<span class="badge badge-pass">Yes</span>' } else { '<span class="badge badge-fail">No</span>' }
                $lcPassed = if ($lc.passed) { '<span class="badge badge-pass">PASS</span>' } else { '<span class="badge badge-fail">FAIL</span>' }
                $lcError = ConvertTo-HtmlEncoded -Value "$($lc.error)"
                $serverRows += "<tr><td>$lcName</td><td>$lcPath</td><td>$lcExists</td><td>$lcLastWrite</td><td>$lcAge</td><td>$lcMaxAge</td><td>$lcFresh</td><td>$lcPassed</td><td>$lcError</td></tr>`n"
            }
            $serverRows += "    </table>`n"
        }

        # Resource checks detail
        if ($svr.resource_checks -and @($svr.resource_checks).Count -gt 0) {
            $serverRows += @"
    <h3>Resource Check Details</h3>
    <table class="detail-table sub-table">
        <tr><th>Name</th><th>Process</th><th>Count</th><th>PIDs</th><th>Mem (MB)</th><th>Max Mem (MB)</th><th>Mem OK</th><th>CPU %</th><th>Max CPU %</th><th>CPU OK</th><th>Passed</th><th>Error</th></tr>
"@
            foreach ($rc in $svr.resource_checks) {
                $rcName = ConvertTo-HtmlEncoded -Value "$($rc.name)"
                $rcProcess = ConvertTo-HtmlEncoded -Value "$($rc.process)"
                $rcCount = if ($rc.process_count -is [int]) { "$($rc.process_count)" } else { "N/A" }
                $rcPids = if ($rc.pids) { ($rc.pids | ForEach-Object { "$_" }) -join ", " } else { "N/A" }
                $rcTotalMem = if ($rc.total_memory_mb -is [int] -or $rc.total_memory_mb -is [double]) { "$($rc.total_memory_mb)" } else { "N/A" }
                $rcMaxMem = if ($rc.max_memory_mb -is [int] -or $rc.max_memory_mb -is [double]) { "$($rc.max_memory_mb)" } else { "N/A" }
                $rcMemOk = if ($rc.memory_ok -eq $true) { '<span class="badge badge-pass">PASS</span>' } else { '<span class="badge badge-fail">FAIL</span>' }
                $rcCpuPct = if ($rc.total_cpu_percent -is [int] -or $rc.total_cpu_percent -is [double]) { "$($rc.total_cpu_percent)" } else { "N/A" }
                $rcMaxCpu = if ($rc.max_cpu_percent -is [int] -or $rc.max_cpu_percent -is [double]) { "$($rc.max_cpu_percent)" } else { "N/A" }
                $rcCpuOk = if ($rc.cpu_ok -eq $true) { '<span class="badge badge-pass">PASS</span>' } else { '<span class="badge badge-fail">FAIL</span>' }
                $rcPassed = if ($rc.passed) { '<span class="badge badge-pass">PASS</span>' } else { '<span class="badge badge-fail">FAIL</span>' }
                $rcError = ConvertTo-HtmlEncoded -Value "$($rc.error)"
                $serverRows += "<tr><td>$rcName</td><td>$rcProcess</td><td>$rcCount</td><td>$rcPids</td><td>$rcTotalMem</td><td>$rcMaxMem</td><td>$rcMemOk</td><td>$rcCpuPct</td><td>$rcMaxCpu</td><td>$rcCpuOk</td><td>$rcPassed</td><td>$rcError</td></tr>`n"
            }
            $serverRows += "    </table>`n"
        }

        $serverRows += "</div>`n"
    }
}

# Summary card colors
$summaryRowClass = if ($overallPass) { "summary-pass" } else { "summary-fail" }

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>$(ConvertTo-HtmlEncoded -Value $Title)</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif; background: #f5f7fa; color: #1a1a2e; line-height: 1.6; padding: 20px; }
.container { max-width: 1000px; margin: 0 auto; }
h1 { font-size: 1.6em; margin-bottom: 4px; color: #1a1a2e; }
.header-meta { font-size: 0.85em; color: #666; margin-bottom: 20px; }
.header-meta p { margin: 2px 0; }
.overall-row { display: flex; align-items: center; gap: 12px; margin-bottom: 24px; }
.stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 12px; margin-bottom: 28px; }
.stat-card { background: #fff; border: 1px solid #e0e3e8; border-radius: 8px; padding: 16px; text-align: center; }
.stat-card .stat-value { font-size: 1.8em; font-weight: 700; line-height: 1.2; }
.stat-card .stat-label { font-size: 0.78em; color: #666; margin-top: 4px; text-transform: uppercase; letter-spacing: 0.5px; }
.stat-pass .stat-value { color: #1a7f37; }
.stat-fail .stat-value { color: #cf222e; }
.badge { display: inline-block; padding: 2px 10px; border-radius: 4px; font-size: 0.78em; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; vertical-align: middle; }
.badge-pass { background: #dafbe1; color: #1a7f37; border: 1px solid #a6e3b1; }
.badge-fail { background: #ffebe9; color: #cf222e; border: 1px solid #ffb8b0; }
.server-section { background: #fff; border: 1px solid #e0e3e8; border-radius: 8px; padding: 18px 20px; margin-bottom: 16px; }
.server-fail { border-left: 4px solid #cf222e; }
.server-pass { border-left: 4px solid #1a7f37; }
.server-name { font-size: 1.1em; margin-bottom: 12px; }
.server-name .badge { float: right; }
.detail-table { width: 100%; border-collapse: collapse; font-size: 0.88em; margin-bottom: 8px; }
.detail-table th { background: #f0f2f5; text-align: left; padding: 6px 10px; font-weight: 600; border-bottom: 2px solid #d0d4dc; }
.detail-table td { padding: 6px 10px; border-bottom: 1px solid #e8eaed; vertical-align: top; }
.detail-table tr:last-child td { border-bottom: none; }
.sub-table { margin-top: 8px; margin-bottom: 12px; }
.sub-table th { background: #f6f8fa; font-size: 0.88em; }
h3 { font-size: 0.95em; color: #444; margin-top: 12px; margin-bottom: 6px; }
.value-true { text-align: center; }
.value-false { text-align: center; }
.value-null { color: #999; font-style: italic; text-align: center; }
.summary-fail { border-left: 4px solid #cf222e; background: #fff; }
.summary-pass { border-left: 4px solid #1a7f37; background: #fff; }
@media print { body { background: #fff; padding: 10px; } .server-section { break-inside: avoid; } }
</style>
</head>
<body>
<div class="container">

<h1>$(ConvertTo-HtmlEncoded -Value $Title)</h1>
<div class="header-meta">
<p>Generated: $(ConvertTo-HtmlEncoded -Value $generatedStamp)</p>
<p>Scan Timestamp: $(ConvertTo-HtmlEncoded -Value $scanStamp)</p>
</div>

<div class="overall-row">
    <h2 style="font-size:1.2em;margin:0;">Overall Status</h2>
    <span style="font-size:1.2em;">$overallBadge</span>
</div>

<div class="stats-grid">
    <div class="stat-card $(if ($failedChecks -eq 0) { 'stat-pass' } else { 'stat-fail' })">
        <div class="stat-value">$(ConvertTo-HtmlEncoded -Value "$totalServers")</div>
        <div class="stat-label">Total Servers</div>
    </div>
    <div class="stat-card stat-pass">
        <div class="stat-value">$(ConvertTo-HtmlEncoded -Value "$passedChecks")</div>
        <div class="stat-label">Passed</div>
    </div>
    <div class="stat-card $(if ($failedChecks -eq 0) { 'stat-pass' } else { 'stat-fail' })">
        <div class="stat-value">$(ConvertTo-HtmlEncoded -Value "$failedChecks")</div>
        <div class="stat-label">Failed</div>
    </div>
    <div class="stat-card $(if ($failedServerCount -eq 0) { 'stat-pass' } else { 'stat-fail' })">
        <div class="stat-value">$(ConvertTo-HtmlEncoded -Value "$failedServerCount")</div>
        <div class="stat-label">Failed Servers</div>
    </div>
</div>

$serverRows

</div>
</body>
</html>
"@

# ---------------------------------------------------------------------------
# Write HTML file
# ---------------------------------------------------------------------------
$parentDir = Split-Path -Parent -Path $OutputPath
if (-not (Test-Path -LiteralPath $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
}

try {
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($OutputPath, $html, $utf8NoBom)
    Write-Host "HTML report written: $OutputPath"
} catch {
    Write-Warning "Failed to write HTML report: $_"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 4; html_path = $OutputPath })
    exit 4
}

if ($Open) {
    Start-Process -FilePath $OutputPath
}

Write-Output ([PSCustomObject]@{ success = $true; exit_code = 0; html_path = $OutputPath })
exit 0
