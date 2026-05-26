# QuestOps Watchdog — Client Handoff Checklist

Use this checklist when preparing and sending the audit package to a client.

---

## Before sending the package

- [ ] Run the export script with `-Force` to create the zip:
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_package.ps1 -Force
  ```
- [ ] Verify the exit code is **0** (package created successfully)
- [ ] Confirm the zip path shown in the output
- [ ] Open the zip and verify included files (46 files expected):
  ```powershell
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $zip = Get-ChildItem dist -Filter *.zip | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  [System.IO.Compression.ZipFile]::OpenRead($zip.FullName).Entries | Select-Object FullName
  ```
- [ ] Confirm version, release notes, and business docs are present:
  ```powershell
  [System.IO.Compression.ZipFile]::OpenRead($zip.FullName).Entries | Where-Object {
      $_.FullName -match '^VERSION$|^CHANGELOG\.md$|docs/RELEASE_NOTES_v0\.4\.9\.md|docs/business/|docs/demo/|docs/assets/|docs/website/'
  } | Select-Object FullName
  ```
  Expected: 24 results: VERSION, CHANGELOG.md, release notes, 6 packaged business docs, 5 demo docs, 6 assets docs (README + 5 screenshot docs), and 4 website docs.
- [ ] Confirm no sensitive files are included:
  ```powershell
  [System.IO.Compression.ZipFile]::OpenRead($zip.FullName).Entries | Where-Object {
      $_.FullName -match '\.env|servers\.local\.json|reports/.+\.json|logs/.+\.log|\.git/' -or
      ($_.FullName -match '^state/.+' -and $_.FullName -ne 'state/.gitkeep')
  } | Select-Object FullName
  ```
  Expected: no results.
- [ ] Remove any old packages from `dist\` if they are not needed

---

## Client setup steps

Provide these instructions to the client:

1. **Extract the zip** to any folder on the Windows machine
2. **Open PowerShell** as the user who will run the scans
3. **Navigate** to the extracted folder:
   ```powershell
   cd C:\Path\To\Extracted\Folder
   ```
4. **Validate the demo config**:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1
   ```
5. **Create a local config** by copying `config\servers.game.example.json` to `config\servers.local.json`
6. **Edit** `config\servers.local.json` with the actual server paths
7. **Validate the local config**:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath config\servers.local.json
   ```

---

## Client config checklist

Before running the first scan, the client should verify:

- [ ] Server folder paths exist on the machine
- [ ] Server processes (e.g. `ProjectZomboid64.exe`, `java.exe`) match the process names in the config
- [ ] `disk_threshold_gb` is set to a realistic value
- [ ] `network_checks` host/port values match actual server IPs and ports
- [ ] `log_checks` `path` values point to real log files, `max_age_minutes` is reasonable
- [ ] `resource_checks` `max_memory_mb` and `max_cpu_percent` match expected usage

---

## Run commands

Guide the client through:

```powershell
# 1. Validate config
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath config\servers.local.json

# 2. Run a scan
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -ConfigPath config\servers.local.json

# 3. Check the report
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.overall_pass
$report.results | Format-Table server_name, passed

# 4. (Optional) Scan + alert
$env:QUESTOPS_DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1

# 5. (Optional) Export HTML report
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1

# 6. (Optional) Install scheduled scans
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install_questops_task.ps1 -Force
```

---

## What output to collect

Request the following files from the client for the audit:

| File | Purpose |
|------|---------|
| Audit results bundle zip | All outputs in one file (created by `export_questops_audit_results.ps1`) |
| `reports\latest-health-report.json` | The scan result (included in bundle) |
| `reports\latest-health-report.html` | The HTML audit report (included in bundle) |
| `config\servers.local.json` | Their server configuration (optional, include via `-IncludeConfig`) |
| `logs\questops-run.log` | Run log (optional, include via `-IncludeLog`) |

Also ask for any console warnings or errors they observed.

### How the client creates the audit results bundle

```powershell
# Basic bundle (report + HTML + manifest)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1

# Bundle with config and log
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1 -IncludeConfig -IncludeLog
```

The bundle is written to `dist\questops-watchdog-audit-results-YYYYMMDD-HHMMSS.zip`. It includes a safety-scanned manifest.

---

## Security reminders

- **Never commit** webhook URLs, `.env` files, or credentials to any repository
- **Never include** `config\servers.local.json`, `reports\*.json`, or `logs\*.log` in the audit package zip
- The export script automatically excludes: `.git`, `.env`, local configs, reports, logs, state, temp files, and build artifacts
- If using Discord alerts, keep the webhook URL in `$env:QUESTOPS_DISCORD_WEBHOOK_URL` only
- Always validate config with `validate_questops_config.ps1` before running the scan for the first time

---

## Troubleshooting basics

| Symptom | Likely cause | Fix |
|---------|------------|-----|
| `exit code 2` on scan | Config file not found | Check the path; use `-ConfigPath` |
| `exit code 3` on scan | Config has invalid JSON | Run `validate_questops_config.ps1` |
| `folder_exists: false` | Server folder path is wrong | Edit the `folder` field in config |
| `process_running: false` | Server process not running | Start the server or check the `process` name |
| `disk_ok: false` | Disk is full or threshold too high | Free space or lower `disk_threshold_gb` |
| `network_ok: false` | Port unreachable | Check firewall, server bind address, and port config |
| `logs_ok: false` | Log file missing or stale | Check `path` and `max_age_minutes` in config |
| `resources_ok: false` | Process over memory/CPU limit | Check `max_memory_mb` / `max_cpu_percent` thresholds |
| Alert not sending | Webhook URL not set | Set `$env:QUESTOPS_DISCORD_WEBHOOK_URL` |
| Package export fails with exit 3 | Secrets detected in included files | Remove hardcoded secrets and re-run |
