# QuestOps Watchdog — Sample Discord Alert

A plain-text example of what a Discord alert looks like when a scan detects failures. No webhook URLs, no channel IDs.

```
QuestOps Watchdog — Health Alert
Scan: 2026-05-25 14:30:00 UTC
Status: FAILED — 1/2 servers failed

Failed servers:
  Demo Minecraft Server (folder disk process network logs resources)
    - network (MC Game Port — 127.0.0.1:25565)
    - logs (MC latest log)
    - resources (MC process resources — mem cpu)

Full report: reports/latest-health-report.json
```

## Alert structure

| Line | Description |
|------|-------------|
| Header | `QuestOps Watchdog — Health Alert` |
| Timestamp | UTC time of the scan |
| Status | `PASSED` or `FAILED` with count summary |
| Failed servers list | Per-server: name + failed categories in parentheses |
| Detail lines | Indented: specific check name, host:port, threshold details |
| Report path | Path to the full JSON report |

## Example scenarios

### All passing (no alert sent)

If all servers pass, no alert is sent. The script exits 0 silently.

### Single failure

```
QuestOps Watchdog — Health Alert
Scan: 2026-05-25 14:30:00 UTC
Status: FAILED — 1/2 servers failed

Failed servers:
  Demo Minecraft Server (network)
    - network (MC Game Port — 127.0.0.1:25565)

Full report: reports/latest-health-report.json
```

### Multiple failures

```
QuestOps Watchdog — Health Alert
Scan: 2026-05-25 14:30:00 UTC
Status: FAILED — 2/2 servers failed

Failed servers:
  Demo Project Zomboid Server (disk)
    - disk (free: 0.3 GB, threshold: 10 GB)
  Demo Minecraft Server (process network logs)
    - process (java.exe not running)
    - network (MC Game Port — 127.0.0.1:25565)
    - logs (MC latest log)

Full report: reports/latest-health-report.json
```

### Forced test alert

When using `-Force`, a forced test alert is clearly marked:

```
( FORCED TEST — QUESTORS WATCHDOG TEST ALERT )

QuestOps Watchdog — Health Alert
Scan: 2026-05-25 14:30:00 UTC
Status: FORCED TEST — no failures detected in report

Full report: reports/latest-health-report.json
```

## Truncation

If the alert message exceeds Discord's 2000 character limit, it is truncated:

```
QuestOps Watchdog — Health Alert
Scan: 2026-05-25 14:30:00 UTC
Status: FAILED — 5/5 servers failed

Failed servers:
  ... (truncated — 1872 characters — see JSON report for full details)

Full report: reports/latest-health-report.json
```

## Notes

- All server names, paths, IPs, and data shown are **fictional**.
- No webhook URLs, Discord channel IDs, or real credentials are shown.
- The alert is sent as plain text (no embeds, no rich formatting).
