# QuestOps Watchdog — Release Notes v0.4.8

## Product

**QuestOps Watchdog** — A Windows-first local audit and monitoring tool for survival game server owners.

**Version:** 0.4.8

---

## What this release includes

- Folder existence, disk space, and process running checks
- TCP port reachability checks (optional per server)
- Log file freshness checks (optional per server)
- Process CPU and memory usage checks (optional per server)
- Discord webhook alerting on failure
- Windows Task Scheduler integration for recurring scans
- Config validation script
- JSON health scan report
- HTML audit report export (standalone, no external dependencies)
- Client-ready audit package (tool zip, safety-scanned)
- Audit results bundle (outputs zip, safety-scanned)
- Version metadata, changelog, and release notes

## Main scripts included

| Script | Purpose |
|--------|---------|
| `scripts/questops_scan.ps1` | Run a health scan and write a JSON report |
| `scripts/questops_run.ps1` | Orchestrate scan + optional Discord alert |
| `scripts/validate_questops_config.ps1` | Validate config file structure |
| `scripts/export_questops_html_report.ps1` | Export JSON report as standalone HTML |
| `scripts/export_questops_audit_results.ps1` | Package scan outputs for client review |
| `scripts/questops_discord_alert.ps1` | Send Discord alert from a report |
| `scripts/install_questops_task.ps1` | Install recurring scan via Task Scheduler |
| `scripts/uninstall_questops_task.ps1` | Remove scheduled task |

## How to validate config

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1
```

## How to run a scan

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1
```

For a scan with optional Discord alert:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1
```

## How to export HTML report

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1
```

## How to export audit results bundle

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1
```

## Known limitations

- Windows only (PowerShell 5.1)
- Task runs as current user (S4U logon, no password stored)
- Single drive assumption for disk checks
- Process name matching is exact (renamed processes may be missed)
- Discord alerting only (no email/SMS)
- Not a Windows service — runs in a console window

## Security notes

- This tool runs locally only. It does not phone home or collect telemetry.
- No credentials, tokens, or secrets are stored in the repository.
- Discord webhook URL must come from an environment variable (`$env:QUESTOPS_DISCORD_WEBHOOK_URL`), never from a file.
- The preflight safety scan in the export scripts detects hardcoded webhook URLs, passwords, tokens, and secrets before packaging.
- Generated reports and logs are gitignored.

## Files that should never be shared

- Your Discord webhook URL
- `.env` files or environment variable exports
- `config/servers.local.json` (your real server config with paths)
- `reports/*.json` and `reports/*.html` unless specifically requested in an audit
- `logs/*.log` unless specifically requested in an audit
- Any file containing passwords, tokens, or API keys
