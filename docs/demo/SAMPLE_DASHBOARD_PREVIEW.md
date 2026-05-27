# QuestOps Watchdog — Sample Dashboard Preview

The HTML dashboard is a self-contained, static HTML page generated from a JSON scan report and optional history files. It uses inline CSS only — no JavaScript, no external dependencies, no CDN.

Below is a fictional example showing what the dashboard looks like with sample data. All server names, paths, IPs, and data are fictional.

## Overall layout

```
┌─────────────────────────────────────────────────────────────────────┐
│  QuestOps Watchdog Dashboard                                       │
│  Generated: 2026-05-27 10:00:00 UTC                                 │
│  Latest scan: 2026-05-27 09:45:00 UTC                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Overall Status  [PASS]                                             │
│                                                                      │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │  Total   │ │ Passed  │ │ Failed  │ │ Failed  │ │History  │       │
│  │ Servers  │ │         │ │         │ │ Servers │ │ Loaded  │       │
│  │    2     │ │    1    │ │    1    │ │    1    │ │    5    │       │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘       │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  [ All Servers (2) ]  [ Passing (1) ]  [ Failing (1) ]     │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                      │
│  (Showing All Servers view)                                         │
│                                                                      │
│  All Servers                                                        │
│  ┌───────────────┬───────┬──────┬───────┬───────┬──────┬──────────┐ │
│  │ Server        │Folder │Disk  │Process│Netwk  │Logs  │Resources │ │
│  ├───────────────┼───────┼──────┼───────┼───────┼──────┼──────────┤ │
│  │ Project Z     │PASS   │PASS  │PASS   │PASS   │PASS  │PASS      │ │
│  │ [PASS]        │       │      │       │       │      │          │ │
│  ├───────────────┼───────┼──────┼───────┼───────┼──────┼──────────┤ │
│  │ Minecraft Svr │PASS   │PASS  │FAIL   │FAIL   │PASS  │FAIL      │ │
│  │ [FAIL]        │       │      │       │       │      │          │ │
│  └───────────────┴───────┴──────┴───────┴───────┴──────┴──────────┘ │
│                                                                      │
│  Failed Server Details                                              │
│  ┌─ Minecraft Svr [FAIL] ──────────────────────────────────────────┐ │
│  │ Failed categories: process, network, resources                   │ │
│  │                                                                  │ │
│  │ • Process: Not running — java.exe                                │ │
│  │ • Network: MC Game Port (127.0.0.1:25565) — timeout             │ │
│  │ • Resources: MC resources (java.exe) — Mem: 5120/4096 MB        │ │
│  └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  History Summary                                                    │
│  ┌──────────────────────┬───────┬────────┬────────────┬───────────┐ │
│  │ Timestamp            │Status │Servers │ Failed     │ Failed    │ │
│  │                      │       │        │ Checks     │ Servers   │ │
│  ├──────────────────────┼───────┼────────┼────────────┼───────────┤ │
│  │ 2026-05-27 09:30 UTC │ PASS  │   2    │    0       │    0      │ │
│  │ 2026-05-27 09:15 UTC │ FAIL  │   2    │    3       │    1      │ │
│  │ 2026-05-27 09:00 UTC │ PASS  │   2    │    0       │    0      │ │
│  │ 2026-05-26 23:00 UTC │ FAIL  │   2    │    1       │    1      │ │
│  │ 2026-05-26 22:00 UTC │ PASS  │   2    │    0       │    0      │ │
│  └──────────────────────┴───────┴────────┴────────────┴───────────┘ │
│                                                                      │
│  Trend Summary                                                      │
│  ┌────────────────────────────────────────────┐                     │
│  │         Trend Summary                      │                     │
│  │  Metric                  │ Value           │                     │
│  │  PASS reports            │ 3               │                     │
│  │  FAIL reports            │ 2               │                     │
│  │  Most recent failure     │ 2026-05-27      │                     │
│  │                          │ 09:15:00 UTC    │                     │
│  └────────────────────────────────────────────┘                     │
│                                                                      │
│  References                                                         │
│  Latest JSON report: reports\latest-health-report.json              │
│  Latest HTML report: reports\latest-health-report.html              │
│  Audit results bundle: Created via export_questops_audit_results.ps1│
└─────────────────────────────────────────────────────────────────────┘
```

## Summary cards

Five polished cards at the top show:
- **Total Servers** — number of servers configured
- **Passed** — number of servers where all checks passed
- **Failed** — number of servers where one or more checks failed
- **Failed Servers** — distinct count of failing servers
- **History Loaded** — number of historical reports loaded for the history/trend sections

Cards use soft shadows, rounded corners, and color-coded values for quick scanning.

## Status filter tabs

Below the summary cards, three CSS-only radio tab filters let you switch between views without JavaScript:

| Tab | Shows |
|-----|-------|
| **All Servers (N)** | All servers, all failed details |
| **Passing (N)** | Passing servers only, empty state if none |
| **Failing (N)** | Failing servers only, failed details, empty state if none |

Each tab label shows the server count. Clicking a tab instantly switches the displayed view using CSS `:checked` and sibling selectors. All three views exist in the HTML; only one is visible at a time.

## Server table (per filter view)

Seven-column table showing each server's check statuses:
- Server name with PASS/FAIL badge
- Folder (folder existence check)
- Disk (free space check)
- Process (process running check)
- Network (TCP port reachability)
- Logs (log file freshness)
- Resources (process CPU/memory)

Failed rows have a red left border and light red background. Passing rows have a green left border.

## Empty states

When a filter has no matching servers, a clear message is shown:
- **All servers passing** — shown when no servers have failed checks (Failing tab)
- **No passing servers** — shown when all servers have one or more failed checks (Passing tab)

## Failed server details

Each failing server has its own section (shown under All and Failing views) with:
- Which categories failed (folder, disk, process, network, logs, resources)
- Explanation per category:
  - Folder not found with the path
  - Disk free space below threshold
  - Process not running
  - Network host:port unreachable with error details
  - Log file missing or stale with age details
  - Resource memory/CPU exceed thresholds

## History summary

Table with the most recent N historical reports showing:
- Timestamp (UTC)
- PASS/FAIL status badge
- Server count
- Failed checks count
- Failed server count

History rows are colour-coded: green for PASS, red for FAIL.

## Trend summary

Text-based trend section showing:
- Count of PASS reports in history
- Count of FAIL reports in history
- Timestamp of the most recent failure

No charts in v0.5.x — charts may come in a future version.

## Print-friendly layout

When printed or saved as PDF:
- Filter tabs are hidden
- All server views show together (no toggling needed)
- Page breaks are avoided inside cards, tables, and sections
- Warning boxes are hidden
- High-contrast black/white text for readability
- Tables and cards have visible borders for monochrome printing

## Notes

- All server names, paths, IPs, and data shown in this preview are **fictional**
- The dashboard is excluded from the client tool package — it is output-only, not distribution
- Generate your own dashboard by running `export_questops_dashboard.ps1`
