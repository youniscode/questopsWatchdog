# QuestOps Watchdog — Client Audit Guide

## What QuestOps Watchdog does

QuestOps Watchdog is a Windows-only, zero-dependency health-scan tool for game server operators. It checks that your servers are running, their folders exist, enough disk space is available, TCP ports are reachable, log files are up to date, and process resources (CPU/memory) are within limits — then writes a JSON report you can inspect or forward for a manual audit.

No installation required. No databases. No cloud services.

This release is **v0.4.8**. See `VERSION` for the exact version and `docs/RELEASE_NOTES_v0.4.8.md` for detailed release notes.

---

## How to validate your config

Before running any scan, validate that your config file is structurally correct:

```powershell
# Validate the default safe demo
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1

# Validate a specific config
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath config\servers.game.example.json
```

The validator checks JSON syntax, required fields, types, and value ranges. It does **not** check whether folders or processes actually exist — only that the config is well-formed.

Exit codes:
- **0** = config is valid
- **2** = config file not found
- **3** = config contains invalid JSON or structural errors

## How to copy the game template to your local config

1. Copy `config\servers.game.example.json` to `config\servers.local.json`
2. Edit the paths in `servers.local.json` to match your actual server installation
3. Validate the result:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath config\servers.local.json
   ```

The `servers.local.json` file is gitignored and will never be committed.

## How to run a scan

```powershell
# Run a basic scan (uses the safe demo config)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1

# Run with your local config
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -ConfigPath config\servers.local.json

# Run with verbose output
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -Verbose
```

The report is written to `reports\latest-health-report.json`. Warnings appear in the console.

## How to export an HTML report

After running a scan, you can generate a standalone HTML report suitable for client delivery or print-to-PDF:

```powershell
# Export HTML report (default: reports\latest-health-report.html)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1

# Export from a custom report path
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1 -ReportPath reports\history\questops-health-20260525-120000.json

# Open in browser after generation
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1 -Open
```

The HTML report is self-contained — inline CSS only, no JavaScript, no external dependencies. It can be printed to PDF from any browser.

Exit codes:
- **0** = HTML report created
- **2** = JSON report file not found
- **3** = JSON report is malformed
- **4** = HTML report write failed

## How to read the JSON report

The report file (`reports\latest-health-report.json`) contains:

```json
{
  "scan_timestamp_utc": "2026-05-25T12:00:00Z",
  "overall_pass": true,
  "total_servers": 2,
  "passed_checks": 2,
  "failed_checks": 0,
  "results": [
    {
      "server_name": "My Server",
      "folder_exists": true,
      "disk_ok": true,
      "process_running": true,
      "network_ok": true,
      "logs_ok": true,
      "resources_ok": true,
      "passed": true
    }
  ]
}
```

- `overall_pass` — `true` only if every server passed every check
- `failed_checks` — count of servers with at least one failure
- Each result entry shows per-check details:
  - `folder_exists` — whether the server folder was found
  - `disk_ok` — whether free space meets the threshold
  - `process_running` — whether the server process is running
  - `network_ok` — whether all configured TCP ports are reachable (if any)
  - `logs_ok` — whether all configured log files are fresh (if any)
  - `resources_ok` — whether process CPU/memory are within limits (if any)

To inspect the report from PowerShell:

```powershell
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.overall_pass
$report.results | Format-Table server_name, passed
```

## How to enable Discord alerts safely

1. Set the webhook URL as an environment variable (current session only):
   ```powershell
   $env:QUESTOPS_DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"
   ```

2. Run scan + alert in one command:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1
   ```

3. For a forced test alert:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_discord_alert.ps1 -Force
   ```

**Never commit the webhook URL to any file.** Keep it only in environment variables.

## How to install scheduled scans

```powershell
# Install a recurring scan every 15 minutes (no alerts)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install_questops_task.ps1 -NoAlert -Force

# Install with alerts (webhook must be set as a persistent env var)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install_questops_task.ps1 -Force

# Uninstall
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uninstall_questops_task.ps1 -Force
```

## Exit code reference

| Script | Code | Meaning |
|--------|------|---------|
| `questops_scan.ps1` | 0 | All checks passed |
| `questops_scan.ps1` | 1 | One or more checks failed |
| `questops_scan.ps1` | 2 | Config file not found |
| `questops_scan.ps1` | 3 | Config file contains invalid JSON |
| `questops_scan.ps1` | 4 | Report path invalid |
| `questops_run.ps1` | 0 | Scan passed and alert skipped/sent |
| `questops_run.ps1` | 1 | Scan completed with failures |
| `questops_run.ps1` | 2–4 | Config/report/alert error |
| `questops_discord_alert.ps1` | 0 | Alert sent or not needed |
| `questops_discord_alert.ps1` | 2 | Webhook URL not set |
| `questops_discord_alert.ps1` | 3 | Report missing or malformed |
| `questops_discord_alert.ps1` | 4 | Discord send failed |
| `validate_questops_config.ps1` | 0 | Config is valid |
| `validate_questops_config.ps1` | 2 | Config file not found |
| `validate_questops_config.ps1` | 3 | Invalid JSON or structure |

## How to create an audit results bundle

After running a scan and generating the HTML report, you can create a single zip containing all relevant outputs to send back for a paid/manual audit:

```powershell
# Create an audit results bundle (default: dist\questops-watchdog-audit-results-*.zip)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1

# Include config and run log (optional, safety-scanned)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1 -IncludeConfig -IncludeLog
```

The bundle contains:
- `reports/latest-health-report.json` — the scan result
- `reports/latest-health-report.html` — the HTML audit report
- `audit-results-manifest.json` — a manifest listing what was included and any warnings

If the HTML report is missing, it is automatically generated from the JSON report. All included files are safety-scanned for secrets before packaging.

Exit codes:
- **0** = bundle created
- **1** = creation failed
- **2** = report or HTML missing
- **3** = safety scan or HTML generation failed
- **4** = invalid output path

## What information to send back for a paid/manual audit

Include the following in your audit request:

1. **The audit results bundle** — the zip created by `export_questops_audit_results.ps1` (includes the JSON report, HTML report, and manifest)
2. **Your config file** — `config\servers.local.json` (redact any sensitive paths if needed) — or include it via `-IncludeConfig`
3. **The run log** — `logs\questops-run.log` (if scheduled scans were used) — or include it via `-IncludeLog`
4. **Any warnings or errors** you saw in the console during the scan
5. **Your Windows version** — run `[Environment]::OSVersion`

**Do NOT include** your Discord webhook URL, `.env` files, or any credentials.
