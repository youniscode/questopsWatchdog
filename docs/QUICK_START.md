# QuestOps Watchdog — Quick Start

## Requirements

- Windows 7 or later
- PowerShell 5.1 (comes with Windows; no install needed)
- No administrator rights required — runs as your current user

## 1. Get the tool

Clone or download the repository:

```powershell
git clone https://github.com/your-org/questops-watchdog.git
cd questops-watchdog
```

Or download and extract the [latest audit package](./dist/) zip.

## 2. Validate your config

The default config (`config\servers.example.json`) uses safe demo values that pass on any Windows machine:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1
```

Expected output: `valid=true`, exit code 0.

## 3. Run a scan

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1
```

Expected: exit code 0, report shows `overall_pass=true`.

## 4. View the report

The JSON report is at `reports\latest-health-report.json`. For a human-readable HTML version:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1
```

Open `reports\latest-health-report.html` in any browser.

## 5. Set up scheduled scanning (optional)

```powershell
# Install a task that scans every 15 minutes (no alert)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install_questops_task.ps1 -NoAlert -Force
```

To uninstall later:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uninstall_questops_task.ps1 -Force
```

## Next steps

- Read [CLIENT_AUDIT_GUIDE.md](CLIENT_AUDIT_GUIDE.md) for detailed setup and usage
- Read [CLIENT_HANDOFF_CHECKLIST.md](CLIENT_HANDOFF_CHECKLIST.md) for pre-delivery checks
- Read the [README.md](../README.md) for the full documentation
