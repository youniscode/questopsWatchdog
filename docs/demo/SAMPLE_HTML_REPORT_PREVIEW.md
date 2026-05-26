# QuestOps Watchdog — Sample HTML Report Preview

The HTML report is a self-contained, printable document generated from a JSON scan report. It uses inline CSS only — no JavaScript, no external dependencies, no CDN.

## What it looks like

```
┌─────────────────────────────────────────────────────────┐
│  QuestOps Watchdog — Health Audit Report                │
│  Generated: 2026-05-25 14:30:00 UTC                     │
│  Config: config/servers.local.json                      │
├─────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Servers      │  │  Passed      │  │  Failed      │  │
│  │  2            │  │  1           │  │  1           │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
├─────────────────────────────────────────────────────────┤
│  PASS  Demo Project Zomboid Server                      │
│  ┌──────┬──────────┬──────────┬──────────┬──────────┐  │
│  │Folder│ Disk     │ Process  │ Network  │ Logs     │  │
│  │  ✓   │  ✓       │  ✓       │  ✓       │  ✓       │  │
│  └──────┴──────────┴──────────┴──────────┴──────────┘  │
│  Resources: ✓ (mem 2450/8192 MB, cpu 12.4/95%)          │
├─────────────────────────────────────────────────────────┤
│  FAIL  Demo Minecraft Server                             │
│  ┌──────┬──────────┬──────────┬──────────┬──────────┐  │
│  │Folder│ Disk     │ Process  │ Network  │ Logs     │  │
│  │  ✓   │  ✓       │  ✓       │  ✗       │  ✗       │  │
│  └──────┴──────────┴──────────┴──────────┴──────────┘  │
│  Resources: ✗ (mem 5120/4096 MB, cpu 15.2/90%)          │
│                                                          │
│  Failed checks:                                          │
│  • Network — MC Game Port (127.0.0.1:25565):             │
│    Connection timeout after 3000ms                       │
│  • Logs — MC latest log:                                 │
│    Log is 980 minutes old, exceeds max of 15             │
│  • Resources — MC process resources:                     │
│    Memory 5120.8 MB exceeds max_memory_mb 4096           │
└─────────────────────────────────────────────────────────┘
```

## Summary cards

Three cards at the top show:
- **Total servers** scanned
- **Passed** count (green background)
- **Failed** count (red background)

## PASS / FAIL badges

Each server section has a coloured badge:
- **PASS** — green background, all checks passed
- **FAIL** — red background, one or more checks failed

## Per-server sections

Each server shows:
- A status row with PASS/FAIL badge and server name
- A table of basic checks (folder, disk, process) with ✓/✗ indicators
- Optional check sections (network, logs, resources) only if configured for that server
- Detail lines for any failed optional checks with the error message

## Optional check tables

If a server has `network_checks`, `log_checks`, or `resource_checks`, a detail table is shown:

| Check | Status | Detail |
|-------|--------|--------|
| MC Game Port | ✗ | 127.0.0.1:25565 — Connection timeout after 3000ms |
| MC latest log | ✗ | 980 min stale (max 15 min) |
| MC process resources | ✗ | Memory 5120/4096 MB exceeded |

## Print-to-PDF use case

The HTML report is designed to be printed to PDF from any browser:
- No JavaScript, no interactive elements
- Inline CSS means no external stylesheets to load
- Works offline
- Safe to share with clients

## Screenshot placeholder

> An actual screenshot of the HTML report will be added to `docs/assets/` in a future update. For now, run the HTML exporter yourself:
> ```powershell
> powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1 -Open
> ```

## Notes

- All server names, paths, IPs, and data shown in this preview are **fictional**.
- The HTML report is excluded from the client tool package — it is output-only, not distribution.
