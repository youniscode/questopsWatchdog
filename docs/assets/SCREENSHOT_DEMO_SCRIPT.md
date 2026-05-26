# QuestOps Watchdog — Screenshot Demo Script

Step-by-step script for capturing all planned screenshots. Each section lists the PowerShell commands to run, what to expect, and what to capture.

## Setup

```powershell
# Ensure demo config exists
Get-Content config\servers.example.json

# Run a baseline scan to verify setup
.\questops_scan.ps1 -ConfigPath config\servers.example.json
```

## Shot 1: Healthy scan

```powershell
.\questops_scan.ps1 -ConfigPath config\servers.example.json
```

**Expect**: Both demo servers PASS all checks. Summary shows 100% pass rate.

**Capture**: Full console window from command execution through summary. Include the PowerShell prompt line and the final "All checks passed" or equivalent message.

## Shot 2: TCP port failure

```powershell
# Use a config where one server has an unreachable port
.\questops_scan.ps1 -ConfigPath config\servers.example.json
```

**Expect**: One server shows FAIL for `tcp_checks`. Port connection error displayed.

**Capture**: The per-server section showing the TCP check row with FAIL badge and error detail.

**Alternative**: Use `-WebhookUrl` and a test webhook to also capture the Discord alert for the same failure.

## Shot 3: Stale log detection

```powershell
# Use a config where one server points to an old log file
.\questops_scan.ps1 -ConfigPath config\servers.example.json
```

**Expect**: One server shows FAIL for `log_checks`. Log staleness duration shown.

**Capture**: The per-server section showing the log check row with FAIL badge and "last modified" detail.

## Shot 4: High CPU / memory

```powershell
# Use a config with low thresholds or a process exceeding limits
.\questops_scan.ps1 -ConfigPath config\servers.example.json
```

**Expect**: One server shows FAIL for `resource_checks`. CPU% or memory MB above threshold.

**Capture**: The per-server section showing the resource check row with FAIL badge and the measured value.

## Shot 5: Mixed scan

```powershell
# Use a config where one server passes and one fails
.\questops_scan.ps1 -ConfigPath config\servers.example.json
```

**Expect**: One server all PASS, one server has one or more FAILs.

**Capture**: The full summary with the per-server breakdown showing the contrast.

## Shot 6: Discord alert

```powershell
.\questops_scan.ps1 -ConfigPath config\servers.example.json -WebhookUrl "https://discord.com/api/webhooks/demo/demo"
```

**Expect**: Embed message in the Discord channel showing the failing server(s).

**Capture**: The Discord embed with server name, failed checks list, and timestamp. Blur the channel name and any other channels visible in the sidebar.

## Shot 7: HTML report

```powershell
.\questops_scan.ps1 -ConfigPath config\servers.example.json
.\export_questops_html_report.ps1 -JsonReportPath reports\latest-health-report.json
```

**Expect**: `reports\latest-health-report.html` created.

**Capture**: Open in browser. Capture the summary card section (header area with green/red cards). Then scroll to show one server detail section.

## Shot 8: JSON report

Open `reports\latest-health-report.json` in a code editor with syntax highlighting.

**Capture**: Editor window showing the JSON structure with one server section visible. Include the file name/tab in the capture.

## Shot 9: Config file

Open `config\servers.example.json` in a code editor with syntax highlighting.

**Capture**: Editor window showing the JSON config with multiple server entries. Include the file name/tab.

## Shot 10: Help output

```powershell
.\questops_scan.ps1 -help
```

**Expect**: Parameter list with descriptions.

**Capture**: Full console output including the command line and all help text.

## Shot 11: Force alert

```powershell
# Force an alert even if all checks pass
.\questops_scan.ps1 -ConfigPath config\servers.example.json -ForceAlert -WebhookUrl "https://discord.com/api/webhooks/demo/demo"
```

**Expect**: Discord embed showing forced alert.

**Capture**: The Discord embed showing "Forced test alert" with the all-pass summary.

## Shot 12: Before / after

- **Before**: Run with a failing config, capture the output.
- **After**: Fix the issue, run again, capture the output.

**Capture**: Both console windows side by side. (Composite image — stitched together.)

## Post-capture

1. Apply redactions per [SCREENSHOT_REDACTION_GUIDE.md](SCREENSHOT_REDACTION_GUIDE.md)
2. Name files per [naming convention](README.md)
3. Review per [SCREENSHOT_REVIEW_CHECKLIST.md](SCREENSHOT_REVIEW_CHECKLIST.md)
