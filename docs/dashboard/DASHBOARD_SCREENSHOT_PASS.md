# QuestOps Watchdog — Dashboard Screenshot Pass

## Screenshot goals

- Document the dashboard visual layout and all filter views
- Demonstrate error-state handling (missing, malformed, partial report)
- Show trend summary and history sections
- Verify package contents exclude generated dashboard files
- All screenshots use only fictional/safe demo data

## Safe demo data requirements

- Server names: `Demo Project Zomboid`, `Demo Minecraft`
- IPs: `127.0.0.1` or `192.0.2.x` only
- Paths: `C:\GameServers\Demo\...` only
- No real webhook URLs, usernames, client data, or environment variables
- All metrics are fictional and within reasonable ranges

## Screenshot list

### 1. Dashboard overview — All Servers tab

| Field | Value |
|-------|-------|
| Scenario | Normal passing report with mixed pass/fail servers |
| Key elements | Summary cards, All Servers table with PASS/FAIL badges, failed server details |
| Command | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1` |

### 2. All Servers tab

| Field | Value |
|-------|-------|
| Scenario | Default view after dashboard generation |
| Key elements | Full server table with per-check badges, failed detail section |
| Command | Same as overview — switch to this tab if not default |

### 3. Passing tab

| Field | Value |
|-------|-------|
| Scenario | Filtered to show only passing servers |
| Key elements | Only servers where all checks passed, empty state if none |
| Command | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1` |

### 4. Failing tab

| Field | Value |
|-------|-------|
| Scenario | Filtered to show only failing servers |
| Key elements | Only failing servers, failed detail section, empty state if none passing |
| Command | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1` |

### 5. Trend summary

| Field | Value |
|-------|-------|
| Scenario | Bottom of the dashboard showing trend section |
| Key elements | Pass/Fail Summary, Streak & Timeline, Repeated Failure Insights, timeline pills |
| Command | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1` |

### 6. Error page — missing report

| Field | Value |
|-------|-------|
| Scenario | Dashboard generated without a JSON report file |
| Key elements | Error badge, "Report Not Found" title, suggested fixes list, security reminder |
| Command | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -ReportPath reports\missing-report.json` |

### 7. Error page — malformed report

| Field | Value |
|-------|-------|
| Scenario | Dashboard generated with invalid JSON as the report |
| Key elements | Error badge, "Malformed Report" title, suggested fixes, security reminder |
| Command | `Set-Content "$env:TEMP\bad-report.json" -Value "not json" -Force; powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -ReportPath "$env:TEMP\bad-report.json"` |

### 8. Warning box — partial report

| Field | Value |
|-------|-------|
| Scenario | Dashboard generated with missing optional fields |
| Key elements | Yellow warning box with inferred field messages, dashboard still renders |
| Command | Create a partial report by removing `total_servers`, `passed_checks`, `failed_checks` from a real report, then generate |

### 9. Print preview

| Field | Value |
|-------|-------|
| Scenario | Browser Print → Save as PDF |
| Key elements | Filter tabs hidden, all views shown, clean monochrome layout, page-break avoidance |
| Command | Generate normally, then use browser print dialog |

### 10. Package zip verification

| Field | Value |
|-------|-------|
| Scenario | Verify generated dashboard files are excluded from the client package |
| Key elements | Package contents list, no `questops-dashboard.html` or error page files |
| Command | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_package.ps1 -Force` then inspect zip |

## File naming convention

```
screenshot-dashboard-{descriptive-name}-v0.5.4.png
```

Examples:
- `screenshot-dashboard-overview-v0.5.4.png`
- `screenshot-dashboard-missing-report-v0.5.4.png`
- `screenshot-dashboard-malformed-report-v0.5.4.png`
- `screenshot-dashboard-warning-box-v0.5.4.png`
- `screenshot-dashboard-trend-summary-v0.5.4.png`

## Redaction checklist

Before saving each screenshot:

- [ ] No real webhook URLs visible
- [ ] No real IP addresses (use `127.0.0.1` or `192.0.2.x`)
- [ ] No real server or client names
- [ ] No real Windows usernames in the PowerShell prompt or output
- [ ] No real file paths with user-specific components
- [ ] PowerShell prompt does not reveal real machine or user name
- [ ] All server/path/IP data matches the safe demo convention
- [ ] Refer to `docs/assets/SCREENSHOT_REDACTION_GUIDE.md` for full rules

## Where screenshots should live

```
docs\assets\screenshots\
```

Do not create actual screenshot files until the capture pass is executed. This doc is the plan — the screenshots are created separately.
