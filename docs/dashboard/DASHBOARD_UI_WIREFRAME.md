# QuestOps Watchdog — Dashboard UI Wireframe

ASCII wireframe of the proposed dashboard layout.

```
┌────────────────────────────────────────────────────────────────┐
│  QuestOps Watchdog — Server Health Dashboard                  │
│  Scan: 2026-05-25 14:30:00 UTC  ·  Generated: 2026-05-25 14:31 │
├────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │  Servers      │  │  Passed      │  │  Failed      │         │
│  │  3            │  │  2           │  │  1           │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
├────────────────────────────────────────────────────────────────┤
│  [ All ]  [ Passing only ]  [ Failed only ]                    │
├────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  PASS  Demo Project Zomboid Server                       │  │
│  │  ┌──────┬──────┬──────┬──────────┬──────────┬─────────┐  │  │
│  │  │Folder│ Disk │ Proc │ Network  │ Logs     │ Resrc   │  │  │
│  │  │  ✓   │  ✓   │  ✓   │  ✓       │  ✓       │  ✓      │  │  │
│  │  └──────┴──────┴──────┴──────────┴──────────┴─────────┘  │  │
│  │  Resources: mem 2450/8192 MB, cpu 12.4/95%                │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  PASS  Demo Minecraft Server                              │  │
│  │  ┌──────┬──────┬──────┬──────────┬──────────┬─────────┐  │  │
│  │  │Folder│ Disk │ Proc │ Network  │ Logs     │ Resrc   │  │  │
│  │  │  ✓   │  ✓   │  ✓   │  ✓       │  ✓       │  ✓      │  │  │
│  │  └──────┴──────┴──────┴──────────┴──────────┴─────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  FAIL  Demo Valheim Server                                │  │
│  │  ┌──────┬──────┬──────┬──────────┬──────────┬─────────┐  │  │
│  │  │Folder│ Disk │ Proc │ Network  │ Logs     │ Resrc   │  │  │
│  │  │  ✓   │  ✗   │  ✓   │  ✓       │  ✗       │  ✓      │  │  │
│  │  └──────┴──────┴──────┴──────────┴──────────┴─────────┘  │  │
│  │                                                           │  │
│  │  Failed checks:                                           │  │
│  │  • Disk — Free space 2.1 GB below threshold 10 GB         │  │
│  │  • Logs — Valheim console log:                            │  │
│  │    Log is 45 minutes old, exceeds max of 30               │  │
│  └──────────────────────────────────────────────────────────┘  │
├────────────────────────────────────────────────────────────────┤
│  Config: config/servers.local.json                             │
│  Report: reports/latest-health-report.json                     │
│  Security note: This dashboard shows local server data only.   │
│  Do not share or publish without review.                       │
└────────────────────────────────────────────────────────────────┘
```

## Layout sections

### Header
- Tool name: "QuestOps Watchdog — Server Health Dashboard"
- Scan timestamp and dashboard generation timestamp

### Summary cards
- Three cards: Servers (total count), Passed (green), Failed (red)
- Counts with labels

### Filters
- Three buttons/toggles: All, Passing only, Failed only
- Highlighted/active state for the current filter

### Server status cards
- One card per server
- Card has green border (pass) or red border (fail)
- Server name and PASS/FAIL badge at the top
- Basic check icons row (Folder, Disk, Process, Network, Logs, Resources)
- Resource detail line (memory, CPU) if present
- Failed checks section with bullet-pointed error messages (only shown if failed)

### Report metadata
- Config path used for the scan
- Report file path
- Generated timestamp

### Footer / security note
- Short security reminder about not sharing without review
- Version information
