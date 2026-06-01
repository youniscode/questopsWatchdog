# QuestOps Watchdog

Know your game servers are healthy — before your players tell you.

A lightweight, zero-dependency health monitor for Windows game servers (Project Zomboid, Minecraft, etc.). Checks folder existence, disk space, running processes, network ports, log freshness, and CPU/memory usage — then alerts you on Discord when something fails.

Free, open-source, no cloud, no telemetry.

→ [Security policy](SECURITY.md) · [Contributing guidelines](CONTRIBUTING.md) · [Commercial audit](docs/business/PAID_AUDIT_OFFER.md)

---

## Current status

**Current tagged release:** v0.5.0
**Latest repository milestone:** v0.5.10 — Post-release verification and screenshot capture planning

The `VERSION` file is now 0.5.0. Repository milestones v0.5.0–v0.5.9 were work-in-progress development history that led to the official v0.5.0 release. Milestone v0.5.10 covers post-release verification and screenshot capture planning.

## Try it in 5 minutes

```powershell
git clone https://github.com/youniscode/questopsWatchdog.git
cd questopsWatchdog
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1
```

No install, no dependencies. Works on any Windows machine with PowerShell 5.1. The default config uses `C:\Windows` / `powershell.exe` with a 1 GB threshold and always passes — a safe way to confirm everything works.

### What you just did

1. **Validated** the config structure (JSON syntax, required fields, types)
2. **Scanned** your local machine — checked that `C:\Windows` exists, `powershell.exe` is running, and disk space is above 1 GB
3. **Exported** a self-contained HTML report to `reports\latest-health-report.html`
4. **Optionally** generated a local dashboard to `reports\questops-dashboard.html`

The JSON report at `reports\latest-health-report.json` contains the full data. To inspect it:

```powershell
(Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json) | Format-List
```

## Use it with real servers

1. Copy `config\servers.game.example.json` to `config\servers.local.json`
2. Edit the paths/thresholds to match your actual servers
3. Validate your local config:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath config\servers.local.json
   ```
4. Run a scan with your real config:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -ConfigPath config\servers.local.json
   ```

Three config files exist in the repository — see [Config file roles](#config-file-roles) for details. Your `servers.local.json` is gitignored and never committed.

## What it checks

| Check | Method |
|-------|--------|
| Folder exists | `Test-Path -PathType Container` |
| Free disk space | `Get-PSDrive`, compared against config threshold |
| Process running | `Get-Process` by name |
| TCP port reachability | .NET `TcpClient.BeginConnect` / `EndConnect` with timeout (optional per server) |
| Log file freshness | `Get-Item LastWriteTime` compared against `max_age_minutes` (optional per server) |
| Process CPU & memory | `TotalProcessorTime` sampled over `sample_ms`, `WorkingSet64` summed across matching processes (optional per server) |

## Outputs

| Output | Description |
|--------|-------------|
| `reports/latest-health-report.json` | Machine-readable scan result — overall pass/fail, per-server check details |
| `reports/latest-health-report.html` | Self-contained HTML report (inline CSS, no JS) — safe for print-to-PDF and client delivery |
| Discord alert | Plain-text message sent via webhook when any check fails — includes per-server failed category breakdown |

To inspect the JSON report from PowerShell:

```powershell
(Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json) | Format-List
```

## Demo examples

See what QuestOps Watchdog produces without running it yourself. All examples use fictional servers and data.

- [Sample health report JSON](docs/demo/SAMPLE_HEALTH_REPORT_JSON.md) — passing and failing server report
- [Sample HTML report preview](docs/demo/SAMPLE_HTML_REPORT_PREVIEW.md) — what the HTML audit report looks like
- [Sample Discord alert](docs/demo/SAMPLE_DISCORD_ALERT.md) — example alert messages
- [Sample audit results manifest](docs/demo/SAMPLE_AUDIT_RESULTS_MANIFEST.md) — results bundle metadata
- [Sample client before/after](docs/demo/SAMPLE_CLIENT_BEFORE_AFTER.md) — fictional transformation story

### Screenshots

Real screenshots are planned but not yet captured. The following planning documents and placeholders define what each screenshot should show and how to redact safe data:

- [Capture checklist](docs/assets/SCREENSHOT_CAPTURE_CHECKLIST.md) — 10 screenshot types and capture workflow
- [Redaction guide](docs/assets/SCREENSHOT_REDACTION_GUIDE.md) — what to redact and how (webhooks, IPs, paths, names)
- [Shot list](docs/assets/SCREENSHOT_SHOT_LIST.md) — 12 planned screenshots with priorities
- [Demo script](docs/assets/SCREENSHOT_DEMO_SCRIPT.md) — step-by-step PowerShell commands for each capture
- [Review checklist](docs/assets/SCREENSHOT_REVIEW_CHECKLIST.md) — pre-publication review checklist
- [README hero placeholder](docs/assets/placeholders/README_HERO_SCREENSHOT_PLACEHOLDER.md) — intended hero image for README
- [v0.5.0 screenshot capture plan](docs/assets/SCREENSHOT_CAPTURE_PLAN_v0.5.0.md) — focused capture plan for the official v0.5.0 release (9 recommended shots, safety rules, naming convention, redaction workflow)
- [v0.5.0 screenshot capture results](docs/assets/SCREENSHOT_CAPTURE_RESULTS_v0.5.0.md) — fill-in results template for tracking v0.5.0 screenshot capture/review status

All screenshot placeholders are in `docs/assets/placeholders/`. See [docs/assets/README.md](docs/assets/README.md) for the naming convention and redaction rules.

## Commercial audit offer

Need a deeper analysis of your server setup? I offer paid manual audits that include config review, security checks, and actionable recommendations.

| Tier | Price | Best for |
|------|-------|----------|
| Quick Scan | €49 | Single server, config + report review |
| Standard Audit | €149 | 1–3 servers, full review + recommendations |
| Comprehensive Audit | €299 | 4–10 servers, full review + recommendations + call |
| Enterprise Audit | €499+ | 10+ servers, priority turnaround |

→ [View audit packages](docs/business/PAID_AUDIT_OFFER.md) · [Landing page copy](docs/business/LANDING_PAGE_COPY.md)

## Safety / security notes

- This tool runs **locally only**. It does not phone home, collect telemetry, or send data anywhere.
- No credentials, tokens, or secrets are stored anywhere in the repository.
- Secrets must come from environment variables (e.g. `$env:QUESTOPS_DISCORD_WEBHOOK_URL`) only. Never commit webhook URLs.
- The scan script reads a JSON file and writes a JSON file. It does not execute arbitrary code from config.
- The default `config/servers.example.json` is a safe local demo and will always pass. For real server monitoring, copy `config/servers.game.example.json` to `config/servers.local.json` and edit the paths.
- Always review your config file before running — validate it first with `scripts\validate_questops_config.ps1`.

## Who it is for

- Self-hosted **Project Zomboid** server operators
- Self-hosted **Minecraft** server operators
- Anyone running multiple game servers on Windows who wants a lightweight, no-dependency health check

## Requirements

- **Windows** (7/8/10/11, Server 2012+)
- **PowerShell 5.1** (comes with Windows; no install needed)
- No modules, no npm, no Python, no databases

## Config validation

Run the config validator to check your config file structure before scanning:

```powershell
# Validate the default safe demo config
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1

# Validate the game server template
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath config\servers.game.example.json
```

The validator checks JSON syntax, required fields, types, and ranges — but not runtime availability (folder/process/port existence).

### Config file roles

There are three config files in the repository:

| File | Role | Default path? | Notes |
|------|------|---------------|-------|
| `config/servers.example.json` | Safe local demo | **Yes** — default in all scripts | Uses `C:\Windows` / `powershell.exe` / 1 GB threshold. Always passes on any Windows machine. |
| `config/servers.game.example.json` | Game server template | No — must pass via `-ConfigPath` | Real-looking config with **fake placeholder paths**. Copy to `servers.local.json` and edit. |
| `config/servers.local.json` | Your real config | No — must pass via `-ConfigPath` | Gitignored by `config/*.local.json`. Never committed. |

Exit codes: **0** = valid, **2** = file not found, **3** = invalid JSON or structure.

## Client-ready audit package

Create a clean zip package safe to share with clients. Secrets, local configs, reports, logs, and development files are excluded.

```powershell
# Create the package
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_package.ps1 -Force
```

The package is written to `dist\questops-watchdog-audit-package-YYYYMMDD-HHMMSS.zip`.

### What is included (56 files)

- **Version & changelog:** VERSION, CHANGELOG.md
- **Documentation:** README.md, docs/QUICK_START.md, docs/PROJECTMAP.md, docs/ROADMAP.md, docs/AGENT_RULES.md, docs/TASKS.md, docs/CLIENT_AUDIT_GUIDE.md, docs/CLIENT_HANDOFF_CHECKLIST.md, docs/RELEASE_NOTES_v0.5.0.md
- **Business docs:** docs/business/PAID_AUDIT_OFFER.md, docs/business/LANDING_PAGE_COPY.md, docs/business/OUTREACH_MESSAGES.md, docs/business/SAMPLE_CLIENT_PROPOSAL.md, docs/business/SAMPLE_AUDIT_SUMMARY.md, docs/business/PRICING_NOTES.md
- **Demo docs:** docs/demo/SAMPLE_HEALTH_REPORT_JSON.md, docs/demo/SAMPLE_HTML_REPORT_PREVIEW.md, docs/demo/SAMPLE_DISCORD_ALERT.md, docs/demo/SAMPLE_AUDIT_RESULTS_MANIFEST.md, docs/demo/SAMPLE_CLIENT_BEFORE_AFTER.md, docs/assets/README.md
- **Screenshot docs:** docs/assets/SCREENSHOT_CAPTURE_CHECKLIST.md, docs/assets/SCREENSHOT_REDACTION_GUIDE.md, docs/assets/SCREENSHOT_SHOT_LIST.md, docs/assets/SCREENSHOT_DEMO_SCRIPT.md, docs/assets/SCREENSHOT_REVIEW_CHECKLIST.md
- **Screenshot placeholders:** docs/assets/placeholders/README_HERO_SCREENSHOT_PLACEHOLDER.md, docs/assets/placeholders/HTML_REPORT_SCREENSHOT_PLACEHOLDER.md, docs/assets/placeholders/DISCORD_ALERT_SCREENSHOT_PLACEHOLDER.md, docs/assets/placeholders/POWERSHELL_SCAN_SCREENSHOT_PLACEHOLDER.md, docs/assets/placeholders/PACKAGE_ZIP_SCREENSHOT_PLACEHOLDER.md, docs/assets/placeholders/LANDING_PAGE_SCREENSHOT_PLACEHOLDER.md
- **Website docs:** docs/website/LANDING_PAGE_DRAFT.md, docs/website/HOMEPAGE_WIREFRAME.md, docs/website/WEBSITE_COPY_SNIPPETS.md, docs/website/SEO_NOTES.md
- **Scripts:** questops_scan.ps1, questops_run.ps1, questops_discord_alert.ps1, validate_questops_config.ps1, install_questops_task.ps1, uninstall_questops_task.ps1, export_questops_audit_package.ps1, export_questops_html_report.ps1, export_questops_audit_results.ps1, export_questops_dashboard.ps1
- **Configs:** servers.example.json, servers.game.example.json
- **Placeholders:** reports/.gitkeep, reports/history/.gitkeep, logs/.gitkeep, state/.gitkeep

### What is excluded

- `.git/`, `.env`, `.env.*`
- `config/*.local.json`, `config/*private*.json`, `config/*secret*.json`
- `reports/*.json`, `reports/history/*.json`
- `logs/*.log`, `state/*`
- `tmp/`, `temp/`, `*.tmp`, `*.bak`
- `dist/` (old packages), `*.zip`
- Any file containing a hardcoded Discord webhook URL

A preflight safety scan runs before the zip is created. If a Discord webhook URL is detected in any included file, the export fails with exit code 3.

### Export exit codes

| Code | Meaning |
|------|---------|
| 0 | Package created successfully |
| 1 | Package creation failed (or file exists without -Force) |
| 2 | Required source file missing |
| 3 | Safety scan failed — secrets detected in included files |

## HTML audit report export

After running a scan, you can export the JSON report as a standalone HTML file suitable for client delivery or print-to-PDF.

```powershell
# Export HTML report (default: reports\latest-health-report.html)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1

# Custom input/output paths
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1 -ReportPath reports\custom-report.json -OutputPath reports\audit.html

# Open in browser after generation
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1 -Open
```

The HTML report is a self-contained file with inline CSS only — no JavaScript, no external dependencies, no CDN. It is safe to share with clients and can be printed to PDF from any browser.

### Exit codes

| Code | Meaning |
|------|---------|
| 0 | HTML report created successfully |
| 2 | JSON report file not found |
| 3 | JSON report is malformed |
| 4 | HTML report write failed |

### Notes

- Generated `.html` reports are gitignored (`reports/*`) and are **not** included in the client audit package.
- The generated HTML does **not** contain any environment variables, webhook URLs, or secrets — only the scan result data.
- Custom `-OutputPath` values outside `reports/` are not protected by `.gitignore`.

## Audit results bundle

After the client runs a scan and generates the HTML report, create a **results bundle** — a zip containing the JSON report, HTML report, and optionally the config and run log — to send back for a paid/manual audit.

This is different from the **client-ready audit package** (which packages the *tool* to send *to* a client). The audit results bundle packages the *outputs* to send *back*.

```powershell
# Create an audit results bundle (default paths)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1

# Overwrite existing package
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1 -Force
```

The bundle is written to `dist\questops-watchdog-audit-results-YYYYMMDD-HHMMSS.zip`.

By default it includes:
- `reports/latest-health-report.json`
- `reports/latest-health-report.html`
- `audit-results-manifest.json` (generated at export time)

If the HTML file does not exist, the script automatically generates it using `export_questops_html_report.ps1`.

### Optional config and log

Include the client's config and run log (both safety-scanned before packaging):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1 -IncludeConfig -IncludeLog -Force
```

If the config or log file is missing, a warning is recorded in the manifest but the bundle is still created (with whatever files are available).

### Safety scan

Before creating the zip, all included files are scanned for:
- Discord webhook URLs (`discord.com/api/webhooks`)
- Discord webhook env var references (`QUESTOPS_DISCORD_WEBHOOK_URL=`)
- Strings resembling `"password"`, `"token"`, `"secret"`

If any are detected, the export fails with exit code 3 and lists the offending file paths and risk categories. The secret values are never printed.

### Exit codes

| Code | Meaning |
|------|---------|
| 0 | Audit results package created |
| 1 | Package creation failed (or file exists without `-Force`) |
| 2 | Required report or HTML missing |
| 3 | Safety scan failed or HTML generation failed |
| 4 | Invalid output path |

## Release build

QuestOps Watchdog includes a repeatable release build script that runs all validation steps, exports the tool package and audit results bundle, generates SHA256 checksums, and writes a release manifest — all without committing or tagging.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build_questops_client_release.ps1 -AllowDirty -Force
```

The output is written to `dist\questops-watchdog-v<VERSION>\` containing:
- The latest client tool package zip and its `.sha256` checksum
- The latest audit results bundle zip and its `.sha256` checksum
- `release-manifest.json` with version, timestamps, git info, checksums, and warnings

The build script reads the version from `VERSION` in the project root. Git commit and tagging remain manual — see `docs/RELEASE_CHECKLIST.md` for the exact commands.

## Website / landing page draft

Public-facing marketing materials and website copy for QuestOps Watchdog. Documentation only — no framework, no hosted site.

- [Landing page draft](docs/website/LANDING_PAGE_DRAFT.md) — complete hero-to-FAQ copy
- [Homepage wireframe](docs/website/HOMEPAGE_WIREFRAME.md) — ASCII layout guide
- [Copy snippets](docs/website/WEBSITE_COPY_SNIPPETS.md) — headlines, CTAs, social posts, FAQ variants
- [SEO notes](docs/website/SEO_NOTES.md) — keywords, audience, positioning, technical notes

## Public release preparation

Internal release preparation docs for publishing QuestOps Watchdog publicly on GitHub. These are operator-facing — not required for running scans.

- [GitHub release draft v0.4.9](docs/release/GITHUB_RELEASE_DRAFT_v0.4.9.md) — ready-to-paste release page for the current tagged version
- [Public launch checklist](docs/release/PUBLIC_LAUNCH_CHECKLIST.md) — everything to verify before and during the first week
- [Public announcement copy](docs/release/PUBLIC_ANNOUNCEMENT_COPY.md) — message templates for Discord, forums, Reddit, and LinkedIn
- [Release asset checklist](docs/release/RELEASE_ASSET_CHECKLIST.md) — files to attach, files to exclude, checksum verification
- [First week feedback tracker](docs/release/FIRST_WEEK_FEEDBACK_TRACKER.md) — markdown table for logging feedback
- [Public repo review checklist](docs/release/PUBLIC_REPO_REVIEW_CHECKLIST.md) — final pre-publication review of the entire repository

## Launch / beta audit workflow

Internal workflow docs for approaching first beta users, running safe audits, and collecting feedback. These are operator-facing — not required for running scans.

- [Outreach launch checklist](docs/launch/OUTREACH_LAUNCH_CHECKLIST.md) — what must be ready before outreach, posting rules, daily limits, success criteria
- [First beta audit workflow](docs/launch/FIRST_BETA_AUDIT_WORKFLOW.md) — end-to-end process from qualifying a server owner to delivering audit results
- [Beta audit intake form](docs/launch/BETA_AUDIT_INTAKE_FORM.md) — copy/paste form for gathering server details before an audit
- [Audit delivery template](docs/launch/BETA_AUDIT_DELIVERY_TEMPLATE.md) — structured message for delivering audit findings
- [Outreach tracker template](docs/launch/OUTREACH_TRACKER_TEMPLATE.md) — markdown table for tracking outreach manually
- [Beta feedback form](docs/launch/BETA_FEEDBACK_FORM.md) — copy/paste form for collecting feedback after an audit
- [Launch message pack](docs/launch/LAUNCH_MESSAGE_PACK.md) — refined message templates for Discord, forums, and follow-ups

### Build script exit codes

| Code | Meaning |
|------|---------|
| 0 | Release build completed |
| 1 | Release build failed |
| 2 | Required file or script missing |
| 3 | Validation or safety check failed |
| 4 | Dirty git working tree and `-AllowDirty` not used |

## How to run a normal scan

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1
```

The report is written to `reports/latest-health-report.json`. Warnings appear in the console. The final exit code is 0 (all pass) or 1 (any failure).

To suppress warnings and capture only the report object:

```powershell
$report = & "scripts\questops_scan.ps1"
$report.overall_pass
$report.results | Format-Table server_name, passed
```

To see verbose progress:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -Verbose
```

## How to test missing config handling

```powershell
& "scripts\questops_scan.ps1" -ConfigPath "C:\nonexistent.json"
```

Expected: exit code **2**. A structured error object is emitted.

## How to test malformed config handling

```powershell
Set-Content "$env:TEMP\bad.json" -Value "this is not json" -Force
& "scripts\questops_scan.ps1" -ConfigPath "$env:TEMP\bad.json"
```

Expected: exit code **3**. Error object includes JSON parse error detail.

## How to use custom report paths

Specify a folder (writes `latest-health-report.json` inside):
```powershell
& "scripts\questops_scan.ps1" -ReportPath "C:\MyReports"
```

Or a specific `.json` file:
```powershell
& "scripts\questops_scan.ps1" -ReportPath "$env:TEMP\my-custom-report.json"
```

The parent folder is created automatically if it does not exist.

## Network reachability checks (v0.4)

You can optionally configure TCP port reachability checks per server. If a configured port is unreachable, the server is marked as failed.

### Example config with network_checks

```json
{
  "name": "My Project Zomboid Server",
  "folder": "C:\\PZServer",
  "process": "ProjectZomboid64.exe",
  "disk_threshold_gb": 10,
  "network_checks": [
    {
      "name": "PZ Game Port",
      "host": "127.0.0.1",
      "port": 16261,
      "timeout_ms": 2000
    }
  ],
  "notes": "Example with TCP port check"
}
```

### Behavior

| Scenario | network_checks | network_ok | Server passed |
|----------|---------------|------------|---------------|
| No `network_checks` key | `[]` (empty array) | `true` | unaffected |
| Empty `network_checks` array | `[]` | `true` | unaffected |
| All TCP ports reachable | populated | `true` | depends on other checks |
| Any TCP port unreachable | populated | `false` | `passed = false` |

### Validation

```powershell
# Run scan with game server template
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -ConfigPath config\servers.game.example.json

# Inspect network fields
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.results | Select-Object server_name, network_ok, passed
$report.results | ForEach-Object { $_.network_checks }
```

**Note:** the game server template uses fake placeholder paths — results depend on whether you have matching folders/processes/ports. For a guaranteed pass, use the default `servers.example.json` (safe local demo).

## Log staleness checks (v0.4.1)

You can optionally configure log file freshness checks per server. If a configured log file is missing or has not been updated within the allowed age, the server is marked as failed.

### Example config with log_checks

```json
{
  "name": "My Project Zomboid Server",
  "folder": "C:\\PZServer",
  "process": "ProjectZomboid64.exe",
  "disk_threshold_gb": 10,
  "log_checks": [
    {
      "name": "PZ console log",
      "path": "C:\\PZServer\\Logs\\console.txt",
      "max_age_minutes": 30
    }
  ],
  "notes": "Example with log freshness check"
}
```

### Behavior

| Scenario | log_checks | logs_ok | Server passed |
|----------|-----------|---------|---------------|
| No `log_checks` key | `[]` (empty array) | `true` | unaffected |
| Empty `log_checks` array | `[]` | `true` | unaffected |
| All log files exist and are fresh | populated | `true` | depends on other checks |
| Any log file missing or stale | populated | `false` | `passed = false` |

### Validation

```powershell
# Run scan with game server template
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -ConfigPath config\servers.game.example.json

# Inspect log fields
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.results | Select-Object server_name, logs_ok, network_ok, passed
$report.results | ForEach-Object { $_.log_checks }
```

**Note:** the game server template uses fake placeholder paths — results depend on whether you have matching log files. For a guaranteed pass, use the default `servers.example.json` (safe local demo).

## Process CPU and memory checks (v0.4.2)

You can optionally configure process resource checks per server. If a configured process exceeds the memory or CPU threshold, the server is marked as failed.

CPU is measured by sampling `TotalProcessorTime` over `sample_ms` milliseconds. The delta is divided by the sampling duration and logical CPU count to produce a percentage. Measurement may vary between runs.

### Example config with resource_checks

```json
{
  "name": "My Project Zomboid Server",
  "folder": "C:\\PZServer",
  "process": "ProjectZomboid64.exe",
  "disk_threshold_gb": 10,
  "resource_checks": [
    {
      "name": "PZ process resources",
      "process": "ProjectZomboid64.exe",
      "max_memory_mb": 8192,
      "max_cpu_percent": 95,
      "sample_ms": 1000
    }
  ],
  "notes": "Example with process resource checks"
}
```

### Rules

| Situation | memory_ok | cpu_ok | passed |
|-----------|-----------|--------|--------|
| Process not running | `false` | `false` | `false` |
| `max_memory_mb` missing or ≤ 0 | `true` (informational) | — | depends on CPU |
| `max_cpu_percent` missing or ≤ 0 | — | `true` (informational) | depends on memory |
| Within thresholds | `true` | `true` | `true` |
| Exceeds threshold | `false` / `false` | `false` / `false` | `false` |

### Behavior

| Scenario | resource_checks | resources_ok | Server passed |
|----------|----------------|-------------|---------------|
| No `resource_checks` key | `[]` (empty array) | `true` | unaffected |
| Empty `resource_checks` array | `[]` | `true` | unaffected |
| All processes within limits | populated | `true` | depends on other checks |
| Any process missing or over limit | populated | `false` | `passed = false` |

### Validation

```powershell
# Run scan with game server template
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -ConfigPath config\servers.game.example.json

# Inspect resource fields
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.results | Select-Object server_name, resources_ok, logs_ok, network_ok, passed
$report.results | ForEach-Object { $_.resource_checks }
$report.results | ForEach-Object { $_.resource_checks | Format-List * }
```

**Note:** the game server template uses fake placeholder paths — resource checks require the actual process to be running. For a guaranteed pass, use the default `servers.example.json` (safe local demo).

## How to run scan + alert in one command

The `questops_run.ps1` wrapper runs the health scan and then sends a Discord alert if any checks failed — all in one step.

### Normal scan + alert
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1
```

### Scan only (skip alert)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert
```

### Scan + force alert
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -ForceAlert
```

### Custom paths
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -ConfigPath config\my-servers.json -ReportPath reports\my-report.json
```

Exit codes match the standalone scripts: 0 = pass, 1 = checks failed, 2–4 = config/report/alert errors.

### Logs and report history

Each run of `questops_run.ps1` writes:

| Output | Location | Description |
|--------|----------|-------------|
| Latest report | `reports\latest-health-report.json` | Overwritten each run (same as before) |
| Timestamped copy | `reports\history\questops-health-YYYYMMDD-HHMMSS.json` | Snapshot saved after every scan |
| Run log | `logs\questops-run.log` | Appended with timestamps, run events, and results |

The run log tracks: run start, scan start/exit, alert skipped/sent/failed, report copy, retention cleanup, and run finish. Webhook URLs and secrets are never logged.

#### Retention

- Only the newest **20** timestamped reports are kept by default.
- Use `-KeepReports <N>` to change the limit (e.g. `-KeepReports 50`).
- Use `-NoRetention` to skip cleanup entirely.
- `reports\latest-health-report.json` is never deleted by retention.
- The `-KeepLogs` parameter is reserved for future log rotation (not yet implemented).

Examples:
```powershell
# Keep only 3 historical reports
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert -KeepReports 3

# Skip alert and skip retention cleanup
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert -NoRetention
```

Generated reports and logs are gitignored. The `reports/`, `reports/history/`, and `logs/` directories will contain only `.gitkeep` placeholders in the repository.

## How to set up Discord alerting

### Alert message contents

When a scan fails, the Discord alert now includes:
- Scan timestamp and overall status
- Total/passed/failed server counts
- Per-server breakdown of failed categories:
  - `folder`, `disk`, `process` — basic checks
  - `network (host:port)` — failed TCP port reachability checks
  - `logs (check name)` — missing or stale log files
  - `resources (process mem cpu)` — process resource threshold breaches
- Report file path for full details

If a message exceeds Discord's 2000 character limit, it is safely truncated with a note pointing to the JSON report. Alerts are sent as plain text.

### 1. Set the webhook URL (current session only)

```powershell
$env:QUESTOPS_DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/your_webhook_id/your_webhook_token"
```

**Never commit this URL.** It exists only in the current PowerShell session. To persist it, use a gitignored script or Windows environment variables (not a file in the repo).

### 2. Run a scan, then send an alert

```powershell
# Step 1: run the scan
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1

# Step 2: send alert only if checks failed
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_discord_alert.ps1
```

### 3. Send a forced test alert

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_discord_alert.ps1 -Force
```

This sends an alert regardless of whether the report passed or failed. The message will be clearly marked as `(FORCED TEST)`.

### 4. Use a custom report path

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_discord_alert.ps1 -ReportPath "C:\path\to\report.json"
```

## Scheduled execution

The Task Scheduler installer creates a recurring task that runs `questops_run.ps1` automatically.

### Install (scan only, every 15 minutes)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install_questops_task.ps1 -NoAlert -Force
```

This runs the scan only (no Discord alert). For alerting, set the `QUESTOPS_DISCORD_WEBHOOK_URL` environment variable for the current Windows user before installing.

### Dry run (preview without creating)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install_questops_task.ps1 -WhatIf
```

### Custom interval

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install_questops_task.ps1 -IntervalMinutes 30 -Force
```

### Inspect the task

```powershell
Get-ScheduledTask -TaskName "QuestOps Watchdog"
```

### Run the task manually

```powershell
Start-ScheduledTask -TaskName "QuestOps Watchdog"
```

### Check the last result

```powershell
Get-ScheduledTaskInfo -TaskName "QuestOps Watchdog"
```

### Uninstall

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uninstall_questops_task.ps1 -Force
```

### Important notes

- The task runs under **your current user account** without storing a password (S4U logon).
- If you use Discord alerting, the `QUESTOPS_DISCORD_WEBHOOK_URL` environment variable must be set **persistently** for that user (via System Environment Variables or a startup script). A session-only `$env:VAR` will not persist across scheduled task runs.
- Install with `-NoAlert` to avoid the webhook dependency entirely.

## Current limitations

1. **Windows only** — PowerShell 5.1 scripts cannot run on Linux or macOS.
2. **Task runs as current user** — the scheduled task uses S4U logon without stored passwords. Env vars like `QUESTOPS_DISCORD_WEBHOOK_URL` must be set at system or user level, not session-only.
3. **Single drive assumption** — disk check reads `PSDrive.Root`; mapped drives may not work.
4. **Process name matching** — uses exact process name; renamed/wrapped processes may be missed.
5. **Not a service** — runs in a console window.
6. **Discord only** — no email, SMS, or other alert channels yet.

## Roadmap

| Version | Focus |
|---------|-------|
| v0.1 | Local health scan **(shipped)** |
| v0.2 | Discord webhook alerting **(shipped)** |
| v0.2.1 | Integrated scan + alert workflow **(shipped)** |
| v0.3 | Scheduled execution (Task Scheduler) **(shipped)** |
| v0.4 | Network reachability checks **(shipped)** |
| v0.4.1 | Log staleness checks **(shipped)** |
| v0.4.2 | Process CPU and memory usage **(shipped)** |
| v0.4.3 | Alert message improvements **(shipped)** |
| v0.4.4 | Config validation and safer examples **(shipped)** |
| v0.4.5 | First client-ready audit package **(shipped)** |
| v0.4.6 | HTML audit report export **(shipped)** |
| v0.4.7 | HTML report package integration polish **(shipped)** |
| v0.4.8 | Release hygiene and first tagged client build **(shipped)** |
| v0.4.9 | Paid audit offer kit and landing copy **(shipped)** |
| v0.4.10 | Public GitHub polish and issue templates **(shipped)** |
| v0.4.11 | Sample screenshots and demo assets **(shipped)** |
| v0.4.12 | Website landing page draft **(shipped)** |
| v0.4.13 | Real screenshot capture checklist **(shipped)** |
| v0.4.14 | Screenshot placeholder references and README layout polish **(shipped)** |
| v0.4.15 | Outreach launch checklist and first beta audit workflow **(shipped)** |
| v0.4.16 | First public release page preparation **(shipped)** |
| v0.4.17 | Beta audit reporting template polish **(shipped)** |
| v0.4.18 | Public README quick-start polish |
| v0.4.20 | Dashboard planning brief |
| v0.5.0 | Local HTML Dashboard Release **(shipped)** |
| v0.5.1 | Dashboard visual polish and status filters **(shipped)** |
| v0.5.2 | Dashboard history trend polish **(shipped)** |
| v0.5.3 | Dashboard error state polish **(shipped)** |
| v0.5.4 | Dashboard release readiness and screenshot pass **(shipped)** |
| v0.5.5 | Dashboard release candidate package review **(shipped)** |
| v0.5.6 | Dashboard release notes preparation **(shipped)** |
| v0.5.7 | Dashboard release build dry run **(shipped)** |
| v0.5.8 | Dashboard release decision and version planning **(shipped)** |
| v0.5.9 | Dashboard final release preparation **(shipped)** |
| Official v0.5.0 | Dashboard release execution **(shipped)** |

Full details in `docs/ROADMAP.md`.

## Local dashboard

The local dashboard is a static HTML page that provides a visual overview of your latest health scan results and history.

```powershell
# Generate the dashboard (requires a scan first)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1

# Generate and open in browser
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -Open
```

Default output: `reports\questops-dashboard.html`

The dashboard shows:
- Overall PASS/FAIL status with summary cards (total servers, passed, failed, failed servers, history loaded)
- Status filter tabs (All Servers / Passing / Failing) — CSS-only, no JavaScript
- Server status table (folder, disk, process, network, logs, resources) under the active filter
- Failed server detail section with per-category explanations
- History summary (last N report timestamps with status)
- Trend summary (pass/fail counts, pass/fail rates, failures by category, current/longest streak, timeline pills, repeated failure insights)
- Print-friendly layout with full content, hidden controls, and page-break avoidance

The dashboard includes safe error pages: if the JSON report is missing or malformed, a self-contained error page is written instead of crashing. Missing optional fields produce a yellow warning box with sensible defaults — the dashboard still renders. All error states are handled without raw JSON, stack traces, or sensitive data.

- [Dashboard guide](docs/DASHBOARD_GUIDE.md) — full documentation
- [Sample dashboard preview](docs/demo/SAMPLE_DASHBOARD_PREVIEW.md) — fictional layout example
- [Dashboard planning brief](docs/dashboard/V0_5_DASHBOARD_PLANNING_BRIEF.md) — design rationale
- [Release readiness checklist](docs/dashboard/DASHBOARD_RELEASE_READINESS_CHECKLIST.md) — QA checklist for dashboard release
- [Screenshot pass plan](docs/dashboard/DASHBOARD_SCREENSHOT_PASS.md) — dashboard screenshot capture plan
- [Final validation commands](docs/dashboard/DASHBOARD_FINAL_VALIDATION_COMMANDS.md) — one-page dashboard validation
- [Dashboard release candidate review](docs/release/DASHBOARD_RELEASE_CANDIDATE_REVIEW.md) — internal/operator release review (not required for normal usage)
- [Dashboard release notes draft](docs/release/DASHBOARD_RELEASE_NOTES_DRAFT_v0.5.md) — draft release notes for a future dashboard release (not required for normal usage)
- [Dashboard release build dry run](docs/release/DASHBOARD_RELEASE_BUILD_DRY_RUN.md) — internal/operator release-build dry-run guide (not required for normal usage)
- [Dashboard release decision plan](docs/release/DASHBOARD_RELEASE_DECISION_PLAN.md) — internal/operator release decision and version planning (not required for normal usage)
- [Dashboard final release preparation](docs/release/DASHBOARD_FINAL_RELEASE_PREP.md) — internal/operator final release prep checklist (not required for normal usage)

## Repository hygiene

The project root `.gitignore` protects sensitive and generated content from accidental commits:

| What is ignored | Why |
|----------------|-----|
| `.env`, `*.secret.json`, `*secrets*.json` | API tokens, webhook URLs, passwords |
| `config/*.local.json`, `config/*private*.json` | Machine-specific overrides |
| `reports/*` (except `.gitkeep`) | Generated scan output — ephemeral (includes `reports/history/*`) |
| `logs/*` (except `.gitkeep`) | Runtime logs |
| `state/*` (except `.gitkeep`) | Future runtime state |
| `*.tmp`, `*.bak`, `tmp/`, `temp/` | Temporary / editor junk |
| `dist/`, `out/`, `release/` | Build artifacts (exported packages go here) |
| `.DS_Store`, `Thumbs.db`, `.vscode/`, `.idea/` | OS / editor metadata |

**Secrets must never be committed.** Use environment variables (e.g. `$env:QUESTOPS_DISCORD_WEBHOOK_URL`) or gitignored local config files only.

---

## Agent maintenance notice

This project is maintained with AI coding agents.

**Agents must read the README and PROJECTMAP before making edits.**
**Agents must update documentation after each edit so the repository remains understandable and safe to modify.**
**Agent rules** are defined in `docs/AGENT_RULES.md` and `docs/PROJECTMAP.md`.
