# QuestOps Watchdog — Local HTML Dashboard Guide

## What it is

The local HTML dashboard is a self-contained static HTML page that gives you a visual overview of your latest health scan results. It is generated from the same JSON report that `questops_scan.ps1` produces.

The dashboard includes:
- Overall PASS / FAIL status badge
- Summary cards (total servers, passed, failed, failed server count, history loaded)
- Visual polish with improved spacing, section hierarchy, and card styling
- Status filter tabs — **All Servers**, **Passing**, and **Failing** — CSS-only radio tabs, no JavaScript
- A server status table (folder, disk, process, network, logs, resources per server) shown under the active filter
- Empty-state messages when a filter has no servers
- Failed server detail section (explanations per failed category), filtered by active view
- History summary (last N report timestamps with pass/fail status)
- Trend summary (pass/fail counts, pass/fail rates, failures by category, current/longest streak, timeline pills, repeated failure insights)
- Links to the latest JSON report and HTML report
- Responsive layout with overflow-x table scroll and stacked cards on smaller screens
- Print-friendly layout with hidden filter controls, page-break avoidance, and monochrome-friendly contrast

## What it is not

- Not a web application — no server, no backend, no database
- Not a live-updating dashboard — it is a static snapshot
- Not a replacement for the JSON report or the HTML audit report
- No JavaScript — the dashboard is purely HTML + CSS (filters use CSS-only radio tabs)
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
- The trend section shows pass/fail counts, pass/fail rates, failures by category, current and longest streak, a timeline of coloured PASS/FAIL pills for the most recent 20 reports, and repeated failure insights (top 5 servers with failure count and percentage)
- Timeline calculations de-duplicate the latest report from history by `scan_timestamp_utc` to avoid double-counting
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

- No charts — the trend summary uses text, tables, and small coloured pills. Charts may come in a later version
- No live updates — regenerate the dashboard after each scan to see new data
- History depends on `questops_run.ps1` — standalone `questops_scan.ps1` does not create history copies
- Filters are CSS-only radio tabs — all three views exist in the HTML; only one is shown at a time. All data is loaded on page generation, not dynamically.

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
