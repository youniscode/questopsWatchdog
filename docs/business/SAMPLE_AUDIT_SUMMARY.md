# QuestOps Watchdog — Sample Audit Summary

A fictional audit summary for demonstration purposes. This shows the type of output a client would receive from a paid audit.

---

## Client: ExampleGameHosting
**Audit date:** 2026-05-20
**Auditor:** [Your Name]
**Tier:** Standard Audit

## Servers reviewed

| Server | Status | Issues found |
|--------|--------|-------------|
| PZ Survival (US East) | PASS | 2 low |
| PZ Survival (EU West) | PASS WITH WARNINGS | 1 medium, 1 low |
| Minecraft Creative | FAIL | 1 critical, 1 high |
| Minecraft Survival | PASS | 0 |

## Critical issues

### Minecraft Creative — Webhook URL in config note field
- **Risk:** The Discord webhook URL was found in the `notes` field of `servers.local.json`. If this file is committed or shared, the webhook is exposed.
- **Recommendation:** Remove the URL from the config. Use `$env:QUESTOPS_DISCORD_WEBHOOK_URL` exclusively.

## High issues

### Minecraft Creative — Resource threshold too low
- **Risk:** `max_memory_mb` is set to 2048 MB, but the server routinely uses 3500+ MB. Every scan reports a false-positive resource failure.
- **Recommendation:** Increase threshold to 4096 MB or 0 (informational only).

## Medium issues

### PZ Survival (EU West) — Log check path typo
- **Risk:** The log check path points to `C:\PZServer\Loggs\console.txt` (double `g`). The check silently reports `logs_ok=false`.
- **Recommendation:** Correct the path to `C:\PZServer\Logs\console.txt`.

## Low issues

### PZ Survival (US East) — Disk threshold too conservative
- **Risk:** 5 GB threshold on a 2 TB drive. Will never trigger in practice.
- **Recommendation:** Lower to 20 GB for earlier warning.

### PZ Survival (US East) — No network checks configured
- **Risk:** Server process may be running but not accepting connections.
- **Recommendation:** Add `network_checks` for the game port.

### PZ Survival (EU West) — No scheduled task
- **Risk:** Scans are only run manually. A 3-day outage could go unnoticed.
- **Recommendation:** Install the scheduled task with `install_questops_task.ps1`.

## Recommendations summary

| Priority | Count |
|----------|-------|
| Critical | 1 |
| High | 1 |
| Medium | 1 |
| Low | 3 |

## Files reviewed

- `reports/latest-health-report.json`
- `reports/latest-health-report.html`
- `config/servers.local.json`
- `logs/questops-run.log`

## Security checklist

| Check | Result |
|-------|--------|
| No hardcoded webhook URLs in config | FAIL (notes field) |
| Webhook URL set via env var only | PASS |
| `.env` files present | N/A |
| Local config properly gitignored | PASS |
| Reports directory gitignored | PASS |

## Closing notes

The client's setup is generally healthy. The critical webhook exposure in Minecraft Creative's config should be addressed immediately. The other issues are straightforward config adjustments. Total estimated fix time: 15 minutes.
