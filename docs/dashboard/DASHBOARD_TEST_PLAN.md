# QuestOps Watchdog — Dashboard Test Plan

## Manual validation scenarios

### 1. Safe passing report

- Run a scan with the default `config/servers.example.json` (safe local demo)
- Generate the dashboard
- Expected: green PASS, 1 server, all checks passed, filter buttons work

### 2. Fake failing report

- Create a report with one passing and one failing server (use `docs/demo/SAMPLE_HEALTH_REPORT_JSON.md` as reference)
- Generate the dashboard
- Expected: shows 2 servers, 1 pass, 1 fail. Failed server shows red badge and failed categories with error messages

### 3. Missing report

- Remove or rename `reports/latest-health-report.json`
- Generate the dashboard
- Expected: shows "No report found. Run a scan first." message

### 4. Malformed JSON

- Write `{ invalid json` to `reports/latest-health-report.json`
- Generate the dashboard
- Expected: shows "Report file is malformed. Run a fresh scan." message

### 5. Optional check fields missing

- Use a report generated from the default config (no network_checks, no log_checks, no resource_checks)
- Generate the dashboard
- Expected: no errors. Server card shows basic checks only. Optional check sections show "No network checks configured", "No log checks configured", "No resource checks configured"

### 6. Long server names

- Create a report with a server name of 100+ characters
- Generate the dashboard
- Expected: server name is truncated or wrapped. Layout is not broken.

### 7. Many servers

- Create a report with 10+ servers, mix of pass and fail
- Generate the dashboard
- Expected: all servers render. Page is scrollable. Filtering works. Summary counts are correct.

### 8. Print-to-PDF

- Generate the dashboard with a mixed pass/fail report
- Use browser Print → Save as PDF
- Expected: PDF is clean, readable, monochrome-friendly. Filter buttons are hidden. All servers are shown. Timestamps are present.

### 9. No secrets in output

- Generate the dashboard with any report
- Expected: no webhook URLs, no environment variables, no passwords, no tokens appear anywhere in the dashboard HTML
- Inspect the generated HTML for any of these patterns

### 10. Filter buttons

- Generate a dashboard with multiple servers (mix of pass and fail)
- Click "Failed only" — should show only failed servers
- Click "Passing only" — should show only passing servers
- Click "All" — should show all servers again

### 11. Browser compatibility

- Test in Chrome, Firefox, Edge
- Expected: consistent rendering across all three

### 12. Offline test

- Generate the dashboard
- Disconnect from the internet
- Open the dashboard in a browser
- Expected: works fully offline, no broken resources, no console errors

## Test data

Use `docs/demo/SAMPLE_HEALTH_REPORT_JSON.md` as test data. Copy the JSON content into `reports/latest-health-report.json` for testing.

For edge cases, create minimal reports by hand:

```json
{
  "scan_timestamp_utc": "2026-05-25T14:30:00Z",
  "overall_pass": true,
  "server_count": 1,
  "passed_count": 1,
  "failed_count": 0,
  "results": [
    {
      "server_name": "Test Server",
      "passed": true,
      "folder": "C:\\Test",
      "folder_exists": true,
      "disk_threshold_gb": 5,
      "disk_free_gb": 100.0,
      "disk_ok": true,
      "process": "test.exe",
      "process_running": true
    }
  ]
}
```
