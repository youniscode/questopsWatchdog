# QuestOps Watchdog — Local HTML Dashboard Guide

## What it is

The local HTML dashboard is a self-contained static HTML page that gives you a visual overview of your latest health scan results. It is generated from the same JSON report that `questops_scan.ps1` produces.

The dashboard includes:
- Overall PASS / FAIL status badge
- Summary cards (total servers, passed, failed, failed server count, history loaded)
- A server status table (folder, disk, process, network, logs, resources per server)
- Failed server detail section (explanations per failed category)
- History summary (last N report timestamps with pass/fail status)
- Trend summary (count of PASS/FAIL reports, most recent failure timestamp)
- Links to the latest JSON report and HTML report

## What it is not

- Not a web application — no server, no backend, no database
- Not a live-updating dashboard — it is a static snapshot
- Not a replacement for the JSON report or the HTML audit report
- No JavaScript — the dashboard is purely HTML + CSS
- No external dependencies, no CDN, no fonts

## How to generate it

### Prerequisites

You must have run a scan first:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert
```

Or directly:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1
```

### Generate the dashboard

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1
```

Default output: `reports\questops-dashboard.html`

### Open in browser after generation

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -Open
```

### Custom paths

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 `
    -ReportPath reports\custom-report.json `
    -OutputPath reports\my-dashboard.html
```

### Custom history limit

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -MaxHistory 50
```

### Custom title

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -Title "My Server Dashboard"
```

## What data it uses

The dashboard reads:

1. **`reports/latest-health-report.json`** (or a custom path via `-ReportPath`) — the most recent scan result. This is required.

2. **`reports/history/questops-health-*.json`** (or a custom dir via `-HistoryDir`) — timestamped copies from previous runs. If no history directory or files exist, the dashboard still works (history section shows empty). This is optional.

The `-MaxHistory` parameter limits how many historical reports are loaded (default 20).

## How history works

- `questops_run.ps1` saves a timestamped copy of each scan to `reports/history/questops-health-YYYYMMDD-HHMMSS.json`
- The dashboard loads the most recent N reports (default 20) from that directory
- If a history file has invalid JSON, it is skipped with a warning — the dashboard is still created
- The trend section shows the count of PASS and FAIL reports from loaded history
- If no history files exist, the trend is based on the latest report only

## Security / privacy notes

- The dashboard contains only data from the JSON report — nothing else
- No environment variables, webhook URLs, or secrets are included
- If a Discord webhook URL pattern is found in any rendered value, it is redacted as `[REDACTED]`
- All string values are HTML-encoded before rendering
- The dashboard is a local file — it does not phone home or send data anywhere
- Generated dashboard files in `reports/` are gitignored

## Exit codes

| Code | Meaning |
|------|---------|
| 0 | Dashboard created successfully |
| 2 | Latest report file not found |
| 3 | Latest report contains invalid JSON |
| 4 | Dashboard file write failed |
| 5 | Dashboard created with history read warnings (bad history files skipped) |

## Limitations

- No JavaScript — the dashboard is static. No sorting, filtering, or interactive features in v0.5.0
- No charts — the trend summary is text-based. Charts may come in a later version
- No live updates — regenerate the dashboard after each scan to see new data
- History depends on `questops_run.ps1` — standalone `questops_scan.ps1` does not create history copies
- No mobile-responsive design beyond basic table wrapping

## Troubleshooting

### "No latest report found"

Run a scan first:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1
```

### "Dashboard shows no history"

Make sure you ran `questops_run.ps1` (not just `questops_scan.ps1`) which saves timestamped copies. Or use `-HistoryDir` to point to a custom history directory.

### "History section has warnings"

Some history files may be malformed. They are skipped — the dashboard is still valid. Check the warning messages in the console or the yellow warning box at the top of the dashboard.

### "Failed server details are empty"

The server must have `passed = false` in the JSON report. Check that optional checks (network, logs, resources) are configured in your server config.
