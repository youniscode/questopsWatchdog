# QuestOps Watchdog — Screenshot Capture Checklist

This checklist defines the screenshots needed to visually document QuestOps Watchdog features. Each entry describes the scenario, what to show, key visual elements, and redaction requirements.

## Screenshot types

### 1. Successful scan — all servers passing

| Field | Value |
|-------|-------|
| Scenario | `.\questops_scan.ps1` with two healthy servers |
| Show | Console output: PASS for both servers in all categories |
| Key elements | Green PASS badges, clean summary, "all systems healthy" |
| Redaction | Server names → fictional (Demo Project Zomboid, Demo Minecraft) |
| Dependencies | Demo config with healthy servers |

### 2. Failing TCP port check

| Field | Value |
|-------|-------|
| Scenario | One server has an unreachable port |
| Show | Console output: FAIL for `tcp_checks`, red FAIL badge, port number |
| Key elements | Red FAIL, port number (e.g. 16261), TCP timeout message |
| Redaction | IP address → `192.0.2.10`, port kept visible |
| Dependencies | Demo config with wrong port or offline target |

### 3. Stale log detection

| Field | Value |
|-------|-------|
| Scenario | Server log hasn't been updated in >30 minutes |
| Show | Console output: FAIL for `log_checks`, "last modified" timestamp, age |
| Key elements | Warning icon or red FAIL, stale timestamp, log age in minutes |
| Redaction | Log path → `C:\GameServers\Demo\logs\*.log`, timestamps kept |
| Dependencies | Demo config with old log file |

### 4. High CPU / memory alert

| Field | Value |
|-------|-------|
| Scenario | Server process exceeding thresholds (CPU >80%, memory >2GB) |
| Show | Console output: FAIL for `resource_checks`, CPU%, memory MB |
| Key elements | Percentage > threshold, memory in MB, process name |
| Redaction | Process name kept, server name → fictional |
| Dependencies | Demo config with low thresholds |

### 5. Mixed PASS / FAIL scan

| Field | Value |
|-------|-------|
| Scenario | Multiple servers, some passing some failing |
| Show | Console output: mixed summary, per-server details |
| Key elements | Both PASS and FAIL badges per server, summary with X of Y checks OK |
| Redaction | All server names → fictional |
| Dependencies | Mixed-health demo config |

### 6. Discord alert in action

| Field | Value |
|-------|-------|
| Scenario | Webhook configured, failing scan triggers alert |
| Show | Discord channel with embedded alert message |
| Key elements | Embed with server name, failed checks, timestamp, color coding |
| Redaction | Webhook URL → `https://discord.com/api/webhooks/demo/demo`, server names → fictional |
| Dependencies | Test Discord server or screenshot from demo webhook |

### 7. HTML audit report in browser

| Field | Value |
|-------|-------|
| Scenario | Open `latest-health-report.html` in a browser |
| Show | Browser window with HTML report: summary cards, server tables |
| Key elements | Green/red cards, PASS/FAIL badges, timestamps, server names |
| Redaction | All server names → fictional |
| Dependencies | Generated HTML report from a scan |

### 8. Config file preview

| Field | Value |
|-------|-------|
| Scenario | `servers.example.json` opened in a text editor |
| Show | Editor window with JSON: server names, IPs, ports, thresholds |
| Key elements | Valid JSON structure, server entries, comment annotations |
| Redaction | IPs → `127.0.0.1` or `192.0.2.x`, webhook → `https://discord.com/api/webhooks/demo/demo` |
| Dependencies | `config/servers.example.json` |

### 9. Command-line help

| Field | Value |
|-------|-------|
| Scenario | `.\questops_scan.ps1 -help` |
| Show | Console output: parameter list, usage examples |
| Key elements | `-ConfigPath`, `-WebhookUrl`, `-ForceAlert`, `-KeepReports` parameters |
| Redaction | None needed |
| Dependencies | Script accessible |

### 10. Before / after comparison

| Field | Value |
|-------|-------|
| Scenario | Side-by-side: unhealthy server (before) vs fixed server (after) |
| Show | Two console outputs side by side |
| Key elements | Left side has FAILs, right side has PASSes |
| Redaction | Server names → fictional (same fictional server in both) |
| Dependencies | Two screenshots taken at different times |

## Capture workflow

1. Set up demo config with fictional server entries in `config/servers.example.json`
2. Run the scan command for the target scenario
3. Capture the full console window (use Windows + Shift + S or equivalent)
4. For HTML report: open the file in a browser, capture the viewport
5. For Discord alert: send test alert to a test Discord channel, capture the message
6. Apply redactions (see [SCREENSHOT_REDACTION_GUIDE.md](SCREENSHOT_REDACTION_GUIDE.md))
7. Name files per [naming convention](README.md)
8. Review per [SCREENSHOT_REVIEW_CHECKLIST.md](SCREENSHOT_REVIEW_CHECKLIST.md)
