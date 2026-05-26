# QuestOps Watchdog — Sample Client: Before and After

A fictional transformation showing how QuestOps Watchdog helps a game server owner move from random crashes to clear, actionable reports.

---

## Before

**Server owner:** Alex
**Setup:** Self-hosted Project Zomboid + Minecraft servers on a Windows machine
**Situation:** Random crashes, no evidence, community complaints

### Alex's problems

- Servers crash or become unreachable at random times
- No way to tell if the server process is still running without RDP'ing in
- No way to check if the game port is actually accepting connections
- Log files grow unbounded — no idea if the server is still writing to them
- No performance baselines — memory or CPU could be spiking without anyone knowing
- When players complain, Alex has no data to show whether the server was up or down
- No automated alerting — crashes go unnoticed until players message on Discord

### Alex's workflow before

```
1. Player reports server is down in Discord
2. Alex opens Remote Desktop
3. Checks Task Manager for java.exe / ProjectZomboid64.exe
4. Checks if port is listening (netstat -an)
5. Scrolls through log files looking for errors
6. Restarts the server manually
7. Tells players "it's back up" — no root cause known
```

### Typical downtime per incident

30–90 minutes (from first player report to server restart). Sometimes hours if it happens overnight.

---

## After

**Tool applied:** QuestOps Watchdog with scheduled 15-minute scans and Discord alerts

### What Alex now knows

- **Every 15 minutes** the tool checks folder existence, disk space, process health, network ports, log freshness, and resource usage
- **Immediate Discord alert** the moment any check fails — no need to wait for player reports
- **Historical record** of all scans with timestamps — can see exactly when failures started
- **HTML reports** printable for review or sharing with a paid auditor
- **Audit results bundle** — one zip with everything needed for a professional audit

### Alex's workflow now

```
1. Discord ping arrives: "Demo Minecraft Server (network logs resources)"
2. Opens reports/latest-health-report.json — sees:
   - Port 25565 unreachable (connection timeout)
   - latest.log not updated in 16 hours
   - java.exe using 5.1 GB (over 4 GB threshold)
3. Identifies root cause: server process is running but hung
4. Restarts the Minecraft server service
5. Next scan (15 min later): all checks pass
6. Historical logs prove the exact time of failure
```

### Before vs After comparison

| Aspect | Before | After |
|--------|--------|-------|
| Detect downtime | Player reports (30-90 min lag) | Discord alert (<15 min) |
| Evidence of failure | None | JSON + HTML timestamps |
| Root cause analysis | Manual guesswork | Check-level failure details |
| Automated checks | None | Every 15 minutes (or custom) |
| Performance baselines | None | Memory/CPU tracked per scan |
| Client export | N/A | Clean zip with all docs |
| Paid audit readiness | N/A | One-command results bundle |

### Key metrics

| Metric | Before | After |
|--------|--------|-------|
| Avg detection time | ~45 min | <15 min |
| Avg resolution time | ~60 min | ~20 min |
| Data for RCA | None | Full |
| Player complaints per week | 3–5 | 0–1 |
| Confidence in server health | Low | High |

---

## Notes

- All names, scenarios, and metrics are **fictional** for illustration.
- Results vary based on server setup, config, and actual issues.
- QuestOps Watchdog detects problems but does not fix them automatically — it provides actionable data.

## Related demo docs

- [Sample health report JSON](SAMPLE_HEALTH_REPORT_JSON.md) — see the fictional report format
- [Sample HTML report preview](SAMPLE_HTML_REPORT_PREVIEW.md) — see the visual report
- [Sample Discord alert](SAMPLE_DISCORD_ALERT.md) — see what alerts look like
