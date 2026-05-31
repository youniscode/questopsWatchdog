# QuestOps Watchdog - Project Map

## Project name
QuestOps Watchdog

## Project purpose
A Windows-first local audit and monitoring tool for survival game server owners. It checks folder existence, free disk space, and running processes for configured game servers (Project Zomboid, Minecraft, etc.) and produces a JSON health report.

## Current architecture

```
PowerShell 5.1 script --reads--> config/servers.example.json

|-- Test-QuestFolder    (folder existence)
|-- Test-QuestDisk      (free space against threshold)
|-- Test-QuestProcess   (process running check)
|-- Test-QuestTcpPort           (TCP port reachability - optional per server)
|-- Test-QuestLogFreshness      (log file freshness - optional per server)
|-- Test-QuestProcessResources (process CPU & memory - optional per server)

|-- writes --> reports/latest-health-report.json  (BOM-less UTF-8)
|-- copies --> reports/history/questops-health-YYYYMMDD-HHMMSS.json
`-- appends --> logs/questops-run.log
```

- **PowerShell 5.1 only** - no modules, no PS Core, no cross-platform.
- **No database** - all state is local JSON files.
- **No cloud dependencies** - runs fully offline.
- **BOM-less UTF-8** - all JSON output uses .NET `UTF8Encoding($false)`.

## Folder map

```
questops-watchdog/
|-- .github/
|   |-- ISSUE_TEMPLATE/
|   |   |-- bug_report.md            # Bug report template
|   |   `-- feature_request.md       # Feature request template
|   `-- pull_request_template.md     # Pull request template
|-- .gitignore                # Git ignore rules (secrets, reports, logs, temp files)
|-- VERSION                   # Current version number
|-- CHANGELOG.md              # Version history
|-- SECURITY.md               # Security policy
|-- CONTRIBUTING.md           # Contribution guidelines
|-- LICENSE-NOTE.md           # License note
|-- docs/
|   |-- AGENT_RULES.md              # AI agent coding rules
|   |-- PROJECTMAP.md               # This file
|   |-- ROADMAP.md                  # Development milestones
|   |-- TASKS.md                    # Active task tracking
|   |-- QUICK_START.md              # 5-step quick-start guide
|   |-- CLIENT_AUDIT_GUIDE.md       # Client-facing audit instructions
|   |-- CLIENT_HANDOFF_CHECKLIST.md # Pre/post-delivery checklist
|   |-- RELEASE_NOTES_v0.4.8.md    # Client-facing release notes (v0.4.8)
|   |-- RELEASE_NOTES_v0.4.9.md    # Client-facing release notes (v0.4.9)
|   |-- RELEASE_CHECKLIST.md       # Internal pre-release validation checklist
|   |-- demo/
|   |   |-- SAMPLE_HEALTH_REPORT_JSON.md        # Fictional health report JSON example
|   |   |-- SAMPLE_HTML_REPORT_PREVIEW.md        # HTML report preview description
|   |   |-- SAMPLE_DISCORD_ALERT.md              # Fictional Discord alert examples
|   |   |-- SAMPLE_AUDIT_RESULTS_MANIFEST.md     # Fictional audit-results-manifest.json
|   |   `-- SAMPLE_CLIENT_BEFORE_AFTER.md        # Fictional client transformation story
|   |-- assets/
|   |   |-- README.md              # Screenshot/image asset guidance
|   |   |-- SCREENSHOT_CAPTURE_CHECKLIST.md  # Screenshot types and capture workflow
|   |   |-- SCREENSHOT_REDACTION_GUIDE.md    # Redaction rules
|   |   |-- SCREENSHOT_SHOT_LIST.md         # Planned screenshots
|   |   |-- SCREENSHOT_DEMO_SCRIPT.md       # Demo capture script
|   |   |-- SCREENSHOT_REVIEW_CHECKLIST.md  # Review checklist
|   |   `-- placeholders/
|   |       |-- README_HERO_SCREENSHOT_PLACEHOLDER.md    # README hero placeholder
|   |       |-- HTML_REPORT_SCREENSHOT_PLACEHOLDER.md    # HTML report placeholder
|   |       |-- DISCORD_ALERT_SCREENSHOT_PLACEHOLDER.md  # Discord alert placeholder
|   |       |-- POWERSHELL_SCAN_SCREENSHOT_PLACEHOLDER.md # PowerShell scan placeholder
|   |       |-- PACKAGE_ZIP_SCREENSHOT_PLACEHOLDER.md    # Package zip placeholder
|   |       `-- LANDING_PAGE_SCREENSHOT_PLACEHOLDER.md   # Landing page placeholder
|   |-- website/
|   |   |-- LANDING_PAGE_DRAFT.md         # Complete landing page copy draft
|   |   |-- HOMEPAGE_WIREFRAME.md         # ASCII homepage wireframe layout
|   |   |-- WEBSITE_COPY_SNIPPETS.md      # Reusable copy snippets
|   |   `-- SEO_NOTES.md                 # SEO guidance and keyword research
|   |-- qa/
|   |   |-- PUBLIC_REPO_REVIEW_CHECKLIST.md  # Pre-publication repo review (53 files, qa exclusion)
|   |   |-- RELEASE_CHECKLIST.md             # Release checklist for v0.4.19
|   |   `-- RELEASE_ASSET_CHECKLIST.md       # Release asset checklist for v0.4.19
|   |-- dashboard/
|   |   |-- V0_5_DASHBOARD_PLANNING_BRIEF.md        # Dashboard purpose, scope, risks, build order
|   |   |-- DASHBOARD_MVP_REQUIREMENTS.md            # MVP requirements checklist
|   |   |-- DASHBOARD_DATA_MODEL.md                  # Expected JSON report fields
|   |   |-- DASHBOARD_UI_WIREFRAME.md                # ASCII layout wireframe
|   |   |-- DASHBOARD_SECURITY_NOTES.md              # No secrets, local-only, no telemetry
|   |   |-- DASHBOARD_IMPLEMENTATION_OPTIONS.md      # Compares 4 approaches
|   |   |-- DASHBOARD_TEST_PLAN.md                   # 12 manual validation scenarios
|   |   |-- DASHBOARD_RELEASE_READINESS_CHECKLIST.md # Release QA checklist
|   |   |-- DASHBOARD_SCREENSHOT_PASS.md             # Screenshot capture plan
|   |   `-- DASHBOARD_FINAL_VALIDATION_COMMANDS.md   # One-page validation commands
|   |-- business/
|   |   |-- PAID_AUDIT_OFFER.md           # Pricing and scope for paid audits
|   |   |-- LANDING_PAGE_COPY.md           # Marketing copy reference
|   |   |-- OUTREACH_MESSAGES.md           # Message templates for outreach
|   |   |-- SAMPLE_CLIENT_PROPOSAL.md      # Customizable proposal template
|   |   |-- SAMPLE_AUDIT_SUMMARY.md        # Fictional audit summary sample
|   |   |-- GITHUB_README_POSITIONING.md   # GitHub positioning guidance
|   |   `-- PRICING_NOTES.md               # Pricing rationale and strategy
|-- config/
|   |-- servers.example.json       # Safe local demo config (default)
|   |-- servers.game.example.json  # Game server template with fake paths
|   `-- servers.local.json         # (gitignored) Your real config
|-- scripts/
|   |-- questops_run.ps1                # Orchestrated scan + alert entry point
|   |-- questops_scan.ps1               # Health-scan script
|   |-- questops_discord_alert.ps1      # Discord webhook alert sender
|   |-- validate_questops_config.ps1    # Config structure validator
|   |-- export_questops_audit_package.ps1 # Client-ready audit package exporter
|   |-- export_questops_audit_results.ps1 # Audit results bundle exporter
|   |-- export_questops_html_report.ps1  # HTML audit report exporter
|   |-- export_questops_dashboard.ps1    # Local HTML dashboard exporter
|   |-- build_questops_client_release.ps1 # Release build orchestrator
|   |-- install_questops_task.ps1       # Scheduled Task installer
|   `-- uninstall_questops_task.ps1     # Scheduled Task uninstaller
|-- reports/
|   |-- .gitkeep              # Placeholder (reports/ content is gitignored)
|   |-- latest-health-report.json  # Most recent scan result (overwritten each run)
|   |-- latest-health-report.html  # HTML audit report (generated by export_questops_html_report.ps1)
|   |-- questops-dashboard.html    # Local HTML dashboard (generated by export_questops_dashboard.ps1)
|   `-- history/                   # Timestamped report copies (retention-managed)
|       `-- .gitkeep               # Placeholder (history/ content is gitignored)
|-- logs/
|   |-- .gitkeep              # Placeholder (logs/ content is gitignored)
|   `-- questops-run.log      # Run activity log (appended each run)
|-- state/
|   `-- .gitkeep              # Placeholder (state/ content is gitignored)
|-- dist/                     # Generated packages (gitignored)
|   |-- questops-watchdog-audit-package-*.zip   # Tool-to-client package
|   |-- questops-watchdog-audit-results-*.zip   # Client-results bundle
|   `-- questops-watchdog-v*/                   # Versioned release folders (build output)
`-- README.md                 # Project overview (root level)
```

## Important files

| File | Purpose |
|------|---------|
| `.github/ISSUE_TEMPLATE/bug_report.md` | Bug report issue template. |
| `.github/ISSUE_TEMPLATE/feature_request.md` | Feature request issue template. |
| `.github/pull_request_template.md` | Pull request template with validation and security checklist. |
| `SECURITY.md` | Security policy - supported versions, reporting, secret handling. |
| `CONTRIBUTING.md` | Contribution guidelines - setup, coding rules, validation, PR process. |
| `LICENSE-NOTE.md` | License note - copyright, permitted use, no commercial resale without permission. |
| `.gitignore` | Git ignore rules - protects secrets, reports, logs, local configs, and temp files. |
| `scripts/questops_scan.ps1` | Main scan script. Reads config, runs checks, writes report. |
| `scripts/questops_run.ps1` | Orchestrator - runs scan then Discord alert in one command. Passes `-ConfigPath`, `-ReportPath`, `-NoAlert`, `-ForceAlert`. |
| `scripts/questops_discord_alert.ps1` | Discord webhook alert sender. Reads a report, sends notification if checks failed. |
| `scripts/install_questops_task.ps1` | Windows Scheduled Task installer. Registers recurring scan/alert. Parameters: `-TaskName`, `-ProjectRoot`, `-IntervalMinutes`, `-NoAlert`, `-Force`, `-WhatIf`. |
| `scripts/uninstall_questops_task.ps1` | Windows Scheduled Task uninstaller. Removes the task. Parameters: `-TaskName`, `-Force`. |
| `config/servers.example.json` | Safe local demo config - always passes on any Windows machine. Default config path. |
| `config/servers.game.example.json` | Game server template with real-looking but fake placeholder paths. Must be explicitly passed via `-ConfigPath`. |
| `config/servers.local.json` | (gitignored) Your real server config. Create by copying `servers.game.example.json`. |
| `scripts/validate_questops_config.ps1` | Config structure validator - checks JSON syntax, required fields, types, and ranges. Exit codes 0/2/3. |
| `scripts/export_questops_audit_package.ps1` | Creates a clean zip package of client-safe files. Runs a preflight safety scan. Exit codes 0/1/2/3. |
| `scripts/export_questops_audit_results.ps1` | Creates an audit results bundle zip of scan outputs (JSON report, HTML report, optional config/log) for client review. Runs safety scan. Exit codes 0/1/2/3/4. |
| `scripts/export_questops_html_report.ps1` | HTML audit report exporter. Reads a JSON scan report and generates a standalone HTML file with inline CSS. No JS, no external deps. Exit codes 0/2/3/4. |
| `scripts/export_questops_dashboard.ps1` | Local HTML dashboard exporter. Reads a JSON scan report and optional history, generates a self-contained static HTML dashboard with polished summary cards, CSS-only status filter tabs (All / Passing / Failing), server table with per-check badges, failed details, history summary, trend summary (pass/fail counts, pass/fail rates, failures by category, current/longest streak, timeline pills, repeated failure insights), responsive layout, and print-friendly styling. Inline CSS only. Exit codes 0/2/3/4/5. |
| `scripts/build_questops_client_release.ps1` | Release build orchestrator. Runs config validation, scan, exports, checksums, and writes release manifest. Parameters: `-Version`, `-OutputDir`, `-Force`, `-AllowDirty`. Exit codes 0/1/2/3/4. |
| `docs/CLIENT_AUDIT_GUIDE.md` | Client-facing guide - explains setup, scanning, alerts, scheduled tasks, exit codes, and what to send for an audit. |
| `docs/CLIENT_HANDOFF_CHECKLIST.md` | Pre/post-delivery checklist - export, verify, security reminders, troubleshooting. |
| `docs/RELEASE_NOTES_v0.4.8.md` | Client-facing release notes for v0.4.8. |
| `docs/RELEASE_NOTES_v0.4.9.md` | Client-facing release notes for v0.4.9. |
| `docs/RELEASE_CHECKLIST.md` | Internal pre-release validation checklist (not included in client tool package). |
| `docs/business/PAID_AUDIT_OFFER.md` | Paid audit pricing, scope, and what's included. |
| `docs/business/LANDING_PAGE_COPY.md` | Marketing copy reference for landing page or service announcement. |
| `docs/business/OUTREACH_MESSAGES.md` | Message templates for reaching out to server owners and communities. |
| `docs/business/SAMPLE_CLIENT_PROPOSAL.md` | Customizable proposal template for paid audits. |
| `docs/business/SAMPLE_AUDIT_SUMMARY.md` | Fictional audit summary showing the type of output a client receives. |
| `docs/business/GITHUB_README_POSITIONING.md` | Repository-facing guidance on positioning the project on GitHub (not in client package). |
| `docs/business/PRICING_NOTES.md` | Pricing rationale, discounting strategy, and scope expansion notes. |
| `docs/demo/SAMPLE_HEALTH_REPORT_JSON.md` | Fictional health report JSON showing one passing and one failing server. |
| `docs/demo/SAMPLE_HTML_REPORT_PREVIEW.md` | ASCII-style preview of the HTML audit report layout. |
| `docs/demo/SAMPLE_DISCORD_ALERT.md` | Fictional Discord alert examples for various failure scenarios. |
| `docs/demo/SAMPLE_AUDIT_RESULTS_MANIFEST.md` | Fictional audit-results-manifest.json examples. |
| `docs/demo/SAMPLE_CLIENT_BEFORE_AFTER.md` | Fictional before/after transformation story for a server owner. |
| `docs/assets/README.md` | Screenshot/image asset naming convention and rules. |
| `docs/assets/SCREENSHOT_CAPTURE_CHECKLIST.md` | 10 screenshot types with scenario descriptions, key visual elements, and capture workflow. |
| `docs/assets/SCREENSHOT_REDACTION_GUIDE.md` | Redaction rules for webhook URLs, IPs, paths, usernames, and Discord content in screenshots. |
| `docs/assets/SCREENSHOT_SHOT_LIST.md` | 12 planned screenshots table with IDs, descriptions, and priorities (P1-P3). |
| `docs/assets/SCREENSHOT_DEMO_SCRIPT.md` | Step-by-step PowerShell commands for capturing each planned screenshot. |
| `docs/assets/SCREENSHOT_REVIEW_CHECKLIST.md` | Pre-publication review checklist for content, redaction, technical, and legal review. |
| `docs/assets/placeholders/README_HERO_SCREENSHOT_PLACEHOLDER.md` | Placeholder for future README hero screenshot — intended image name, purpose, safe data requirements. |
| `docs/assets/placeholders/HTML_REPORT_SCREENSHOT_PLACEHOLDER.md` | Placeholder for future HTML report screenshot — crop area, alt text, fictional data rules. |
| `docs/assets/placeholders/DISCORD_ALERT_SCREENSHOT_PLACEHOLDER.md` | Placeholder for future Discord alert screenshot — fake Discord rules, redaction notes. |
| `docs/assets/placeholders/POWERSHELL_SCAN_SCREENSHOT_PLACEHOLDER.md` | Placeholder for future PowerShell scan screenshot — safe demo config, command, alt text. |
| `docs/assets/placeholders/PACKAGE_ZIP_SCREENSHOT_PLACEHOLDER.md` | Placeholder for future package zip screenshot — client-safe contents only, no generated reports. |
| `docs/assets/placeholders/LANDING_PAGE_SCREENSHOT_PLACEHOLDER.md` | Placeholder for future landing page mockup — based on LANDING_PAGE_DRAFT.md, no fake guarantees. |
| `docs/website/LANDING_PAGE_DRAFT.md` | Complete landing page copy draft with hero, problem, solution, pricing, FAQ. |
| `docs/website/HOMEPAGE_WIREFRAME.md` | ASCII wireframe of the homepage layout (nav, hero, features, pricing, FAQ, footer). |
| `docs/website/WEBSITE_COPY_SNIPPETS.md` | Reusable copy snippets — headlines, subheadlines, CTAs, social posts, repo descriptions, FAQ variants. |
| `docs/website/SEO_NOTES.md` | SEO guidance — keywords, target audience, ranking sections, phrases to avoid, honest positioning. |
| `VERSION` | Current version number string. |
| `CHANGELOG.md` | Version history with feature summaries per release. |
| `reports/latest-health-report.json` | Last scan output. Overwritten each run. |
| `reports/history/` | Timestamped report copies. Retained per `-KeepReports`. |
| `logs/questops-run.log` | Run activity log. Appended each run. |
| `docs/QUICK_START.md` | 5-step quick-start guide — clone, validate, scan, HTML export, scheduled task. |
| `docs/PROJECTMAP.md` | This file - structural reference for agents. |
| `docs/AGENT_RULES.md` | Mandatory rules for AI coding agents. |
| `docs/ROADMAP.md` | Feature roadmap (v0.1-v0.5). |
| `docs/TASKS.md` | Task tracker - update after every change. |
| `docs/business/` | Business documentation for paid audit offering. |
| `docs/demo/` | Safe public demo materials showing fictional tool outputs. |
| `docs/assets/` | Screenshots, images, and media assets for documentation. |
| `docs/assets/placeholders/` | Screenshot placeholder docs — describe future screenshots without real images. |
| `docs/launch/` | Internal outreach and beta audit workflow docs — not included in client tool package. |
| `docs/release/` | Internal release preparation docs and dashboard release candidate review docs — not included in client tool package. |
| `docs/qa/` | Internal quality assurance review checklists — not included in client tool package. |
| `docs/dashboard/` | Internal v0.5 dashboard planning, release readiness, screenshot pass, and validation docs — not included in client tool package. |
| `docs/dashboard/DASHBOARD_RELEASE_READINESS_CHECKLIST.md` | Dashboard release QA checklist — scope, scenarios, security, package, browser, screenshot, sign-off. |
| `docs/dashboard/DASHBOARD_SCREENSHOT_PASS.md` | Dashboard screenshot capture plan — 10 screenshots, naming convention, safe demo data, redaction. |
| `docs/dashboard/DASHBOARD_FINAL_VALIDATION_COMMANDS.md` | One-page dashboard validation commands — copy/paste reference for the entire dashboard. |
| `docs/release/DASHBOARD_RELEASE_CANDIDATE_REVIEW.md` | Dashboard release candidate review checklist — scope, validation, package, GitHub readiness, release decision. |
| `docs/release/DASHBOARD_RC_PACKAGE_CONTENTS.md` | Dashboard RC package contents review — expected 56 files, included/excluded categories, inspect commands. |
| `docs/release/DASHBOARD_RC_SIGNOFF_NOTES.md` | Dashboard RC sign-off notes — review date, reviewer, pass/fail, known limitations, next decision. |
| `docs/release/DASHBOARD_RELEASE_NOTES_DRAFT_v0.5.md` | Draft release notes for a future dashboard release — summary, highlights, known limitations, tagging note. |
| `docs/release/DASHBOARD_PUBLIC_ANNOUNCEMENT_DRAFT.md` | Draft public announcement templates — GitHub release, Discord, LinkedIn, forum, CTA. |
| `docs/release/DASHBOARD_RELEASE_NOTES_CHECKLIST.md` | Checklist for turning draft release notes into a real tagged release — validation, git, GitHub, post-release. |
| `docs/release/DASHBOARD_RELEASE_BUILD_DRY_RUN.md` | Dashboard release build dry-run guide — validation steps, troubleshooting, expected results. |
| `docs/release/DASHBOARD_RELEASE_BUILD_DRY_RUN_RESULTS.md` | Template for recording one dry-run result — date, reviewer, pass/hold, notes. |
| `docs/release/DASHBOARD_RELEASE_BUILD_PRECHECKS.md` | Precheck list before running the release build — repo, security, package, environment checks. |
| `docs/audit/` | Internal beta audit reporting template docs — not included in client tool package. |
| `docs/website/` | Public-facing website copy, wireframe, snippets, and SEO guidance. |
| `docs/DASHBOARD_GUIDE.md` | Local dashboard user guide — generation, data sources, security, troubleshooting. |
| `docs/demo/SAMPLE_DASHBOARD_PREVIEW.md` | Fictional ASCII preview of the local HTML dashboard layout. |
| `scripts/export_questops_dashboard.ps1` | Local HTML dashboard exporter. Reads JSON report + optional history, generates self-contained HTML with inline CSS. Safe error pages on missing/malformed report. Consolidated warning box for shape/field/history warnings. Exit codes 0/2/3/4/5. |
| `reports/questops-dashboard.html` | Generated local dashboard — gitignored, not included in client tool package. |
| `docs/launch/OUTREACH_LAUNCH_CHECKLIST.md` | What must be ready before first outreach — docs, scripts, audit flow, posting rules, success criteria. |
| `docs/launch/FIRST_BETA_AUDIT_WORKFLOW.md` | End-to-end workflow from finding server owners to delivering audit results and collecting feedback. |
| `docs/launch/BETA_AUDIT_INTAKE_FORM.md` | Copy/paste intake form for gathering server details before audit. |
| `docs/launch/BETA_AUDIT_DELIVERY_TEMPLATE.md` | Structured delivery message template for audit findings. |
| `docs/launch/OUTREACH_TRACKER_TEMPLATE.md` | Markdown table for manual outreach tracking — date, platform, status, notes. |
| `docs/launch/BETA_FEEDBACK_FORM.md` | Copy/paste feedback form for post-audit collection. |
| `docs/launch/LAUNCH_MESSAGE_PACK.md` | Refined message templates for Discord, forum posts, and follow-ups. |
| `docs/release/GITHUB_RELEASE_DRAFT_v0.4.9.md` | Ready-to-paste GitHub Release page for the current tagged release v0.4.9. |
| `docs/release/PUBLIC_LAUNCH_CHECKLIST.md` | Everything to verify before and during the first week of public launch. |
| `docs/release/PUBLIC_ANNOUNCEMENT_COPY.md` | Message templates for Discord, forums, Reddit, LinkedIn, and follow-ups. |
| `docs/release/RELEASE_ASSET_CHECKLIST.md` | Required and optional assets for the GitHub release, checksum verification, exclusion rules. |
| `docs/release/FIRST_WEEK_FEEDBACK_TRACKER.md` | Markdown table template for logging feedback types, priorities, and actions. |
| `docs/release/PUBLIC_REPO_REVIEW_CHECKLIST.md` | Final pre-publication review of the entire repository — README, security, package, screenshots, roadmap, commercial wording. |
| `docs/audit/BETA_AUDIT_REPORT_TEMPLATE.md` | Structured beta audit report template with executive summary, per-server findings, and recommendations. |
| `docs/audit/FINDINGS_SEVERITY_GUIDE.md` | 5-level severity definitions (Critical, High, Medium, Low, Informational) with example conditions and response expectations. |
| `docs/audit/COMMON_FINDINGS_LIBRARY.md` | 13 reusable finding blocks with symptom, impact, fix, severity suggestion, and client-friendly wording. |
| `docs/audit/RECOMMENDATION_STYLE_GUIDE.md` | Writing conventions — no blame, no exaggeration, factual tone, neutral explanations. |
| `docs/audit/BETA_AUDIT_REPORT_SAMPLE.md` | Fictional sample report with one healthy and one failing server. |
| `docs/audit/BETA_AUDIT_INTERNAL_REVIEW_CHECKLIST.md` | Pre-delivery quality review checklist for audit reports. |
| `docs/audit/BETA_AUDIT_DELIVERY_MESSAGE_POLISHED.md` | Refined delivery message template for sending audit results. |
| `README.md` | Public-facing project overview and usage. |

## Config files

## Config file roles

There are three config file roles, each with a different purpose:

| File | Role | Default path? | Notes |
|------|------|---------------|-------|
| `servers.example.json` | Safe local demo | **Yes** - default in all scripts | Uses `C:\Windows` / `powershell.exe` / `disk_threshold_gb: 1`. Always passes on any Windows machine. No optional checks. Won't scare first-time users. |
| `servers.game.example.json` | Game server template | No - must pass via `-ConfigPath` | Real-looking config with fake placeholder paths (Project Zomboid, Minecraft). Copy to `servers.local.json`, edit paths, then use. |
| `servers.local.json` | Your real config | No - must pass via `-ConfigPath` | Gitignored by `config/*.local.json`. Never committed. Copy from `servers.game.example.json` and edit paths/thresholds. |

### Config field reference

- **`config/servers.example.json`** - JSON array of server objects. Each entry has:
  - `name` - display name
  - `folder` - absolute path to server folder
  - `process` - process name (e.g. `java.exe`)
  - `disk_threshold_gb` - minimum free space in GB
  - `network_checks` - *optional* array of TCP port checks:
    - `name` - label for this check (e.g. "PZ Game Port")
    - `host` - hostname or IP address (e.g. `127.0.0.1`)
    - `port` - TCP port number (e.g. `16261`)
    - `timeout_ms` - connection timeout in milliseconds (e.g. `2000`)
  - `log_checks` - *optional* array of log freshness checks:
    - `name` - label for this check (e.g. "PZ console log")
    - `path` - absolute path to the log file (e.g. `C:\PZServer\Logs\console.txt`)
    - `max_age_minutes` - maximum allowed age in minutes (e.g. `30`)
  - `resource_checks` - *optional* array of process resource checks:
    - `name` - label for this check (e.g. "PZ process resources")
    - `process` - process name to monitor (e.g. `ProjectZomboid64.exe`)
    - `max_memory_mb` - maximum allowed working set in MB (0 = no limit)
    - `max_cpu_percent` - maximum allowed CPU % over sample window (0 = no limit)
    - `sample_ms` - sampling window in milliseconds for CPU measurement (default 1000)
  - `notes` - informational only

## Environment variables

| Variable | Required by | Purpose |
|----------|-------------|---------|
| `QUESTOPS_DISCORD_WEBHOOK_URL` | `questops_discord_alert.ps1` | Discord webhook URL for alert notifications. Never hardcoded or saved to disk. |

## Report / output files

- **`reports/latest-health-report.json`** - written by `questops_scan.ps1`.
- **`reports/latest-health-report.html`** - written by `export_questops_html_report.ps1`. Standalone HTML with inline CSS, no JavaScript.

The report is also emitted to the PowerShell pipeline so callers can capture it: `$report = & .\scripts\questops_scan.ps1`

## Current scripts

- **`scripts/install_questops_task.ps1`** - Scheduled Task installer. Registers a recurring task that runs `questops_run.ps1`. Supports dry-run via `-WhatIf`. Parameters: `-TaskName`, `-ProjectRoot`, `-IntervalMinutes`, `-NoAlert`, `-Force`, `-WhatIf`.
- **`scripts/uninstall_questops_task.ps1`** - Scheduled Task uninstaller. Removes the task. Supports dry-run via `-WhatIf`. Parameters: `-TaskName`, `-Force`.
- **`scripts/questops_run.ps1`** - orchestrator script. Runs scan, then optionally runs alert. Parameters: `-ConfigPath`, `-ReportPath`, `-NoAlert`, `-ForceAlert`, `-LogPath`, `-KeepReports`, `-KeepLogs`, `-NoRetention`. Creates timestamped report copies in `reports/history/` and writes a run log to `logs/questops-run.log`.
- **`scripts/questops_scan.ps1`** - health scan script. Contains 11 functions.
- **`scripts/validate_questops_config.ps1`** - config structure validator. Checks JSON syntax, required fields, field types, and value ranges. Does NOT check runtime availability. Exit codes: 0 = valid, 2 = file not found, 3 = invalid JSON/structure. Internal helpers: `Resolve-QuestValidatePath`, `Read-QuestValidateConfig`.
- **`scripts/questops_discord_alert.ps1`** - Discord webhook alert sender. Reads a report, sends notification if checks failed or if `-Force` is used. Uses helper functions: `Get-QuestFailedCategories`, `Format-QuestFailedServerLine`, `Format-QuestDiscordAlertMessage`, `Limit-QuestDiscordMessage`.
- **`scripts/export_questops_audit_package.ps1`** - client-ready audit package exporter. Creates a clean zip of client-safe files under `dist/`. Runs a preflight safety scan for hardcoded secrets. Parameters: `-OutputDir`, `-PackageName`, `-Force`. Exit codes: 0/1/2/3.
- **`scripts/export_questops_audit_results.ps1`** - audit results bundle exporter. Packages the JSON report, HTML report, and optional config/log into a clean zip under `dist/` for client review. Auto-generates HTML if missing. Runs safety scan. Parameters: `-ReportPath`, `-HtmlPath`, `-OutputDir`, `-PackageName`, `-Force`, `-RefreshHtml`, `-NoGenerateHtml`, `-IncludeConfig`, `-ConfigPath`, `-IncludeLog`, `-LogPath`. Exit codes: 0/1/2/3/4. Default output: `dist\questops-watchdog-audit-results-YYYYMMDD-HHMMSS.zip`.
- **`scripts/export_questops_html_report.ps1`** - HTML audit report exporter. Reads a JSON scan report and generates a standalone HTML file with inline CSS. No JavaScript, no external dependencies. Parameters: `-ReportPath`, `-OutputPath`, `-Title`, `-Open`. Exit codes: 0/2/3/4. Default output: `reports\latest-health-report.html`.
- **`scripts/build_questops_client_release.ps1`** - release build orchestrator. Runs config validation, safe scan, HTML export, tool package export, audit results export, copies packages with SHA256 checksums, and writes a release manifest. Parameters: `-Version` (default from VERSION), `-OutputDir`, `-Force`, `-AllowDirty`. Exit codes: 0/1/2/3/4.

| Function | Script | Purpose |
|----------|--------|---------|
| `Format-Bytes` | `questops_scan.ps1` | Converts bytes to human-readable string (TB/GB/MB/B) |
| `Resolve-QuestConfigPath` | `questops_scan.ps1` | Validates config file exists, returns resolved path or error object (exit 2) |
| `Resolve-QuestReportPath` | `questops_scan.ps1` | Interprets folder or `.json` path, creates parent dir, returns resolved path |
| `Read-QuestJsonConfig` | `questops_scan.ps1` | Reads and parses JSON config with try/catch (exit 3 on malformed) |
| `Write-QuestJsonBomless` | `questops_scan.ps1` | Writes object to JSON file using .NET UTF8Encoding without BOM |
| `Test-QuestFolder` | `questops_scan.ps1` | Checks if a folder exists |
| `Test-QuestDisk` | `questops_scan.ps1` | Checks free disk space against threshold |
| `Test-QuestProcess` | `questops_scan.ps1` | Checks if a named process is running |
| `Test-QuestTcpPort` | `questops_scan.ps1` | Tests TCP port reachability via .NET TcpClient with timeout |
| `Test-QuestLogFreshness` | `questops_scan.ps1` | Checks log file LastWriteTime against max age threshold |
| `Test-QuestProcessResources` | `questops_scan.ps1` | Measures process memory and CPU usage with optional thresholds |
| `Write-QuestLog` | `questops_run.ps1` | Appends a timestamped message to the run log and console |
| `Copy-QuestTimestampedReport` | `questops_run.ps1` | Copies latest report to `reports/history/` with timestamp filename |
| `Invoke-QuestReportRetention` | `questops_run.ps1` | Deletes oldest historical reports beyond `-KeepReports` count |
| `Get-QuestFailedCategories` | `questops_discord_alert.ps1` | Returns list of failed check categories for a server result |
| `Format-QuestFailedServerLine` | `questops_discord_alert.ps1` | Formats a single failed server line for Discord message |
| `Format-QuestDiscordAlertMessage` | `questops_discord_alert.ps1` | Builds the full Discord alert message from report |
| `Limit-QuestDiscordMessage` | `questops_discord_alert.ps1` | Truncates long messages safely within Discord 2000 char limit |
| `Get-QuestTrendSummary` | `export_questops_dashboard.ps1` | Computes pass/fail counts and pass/fail rates from timeline |
| `Get-QuestStatusStreak` | `export_questops_dashboard.ps1` | Computes current and longest status streak from timeline |
| `Get-QuestFailureCategoryCounts` | `export_questops_dashboard.ps1` | Counts failures by category across timeline reports |
| `Get-QuestServerFailureCounts` | `export_questops_dashboard.ps1` | Counts server failures across timeline reports, returns top 5 |
| `Format-QuestTimelineItems` | `export_questops_dashboard.ps1` | Generates PASS/FAIL coloured pill HTML for timeline display |
| `Format-QuestFailureInsightRows` | `export_questops_dashboard.ps1` | Generates repeated failure insight table rows HTML |
| `Get-QuestSafeProperty` | `export_questops_dashboard.ps1` | Safe property accessor with default value |
| `Get-QuestSafeBoolean` | `export_questops_dashboard.ps1` | Safe boolean coercion with default |
| `Get-QuestSafeArray` | `export_questops_dashboard.ps1` | Safe array coercion |
| `Get-QuestDashboardTimestamp` | `export_questops_dashboard.ps1` | Returns current UTC timestamp string |
| `Test-QuestDashboardReportShape` | `export_questops_dashboard.ps1` | Validates report shape, returns missing top-level field warnings |
| `Get-QuestDashboardReportWarnings` | `export_questops_dashboard.ps1` | Collects per-server missing optional field warnings |
| `Format-QuestDashboardWarningBox` | `export_questops_dashboard.ps1` | Generates HTML for a consolidated warning box |
| `Write-QuestDashboardErrorPage` | `export_questops_dashboard.ps1` | Writes a safe error dashboard page to disk |
| `Resolve-QuestValidatePath` | `validate_questops_config.ps1` | Resolves config file path, returns `$null` if not found (exit 2) |
| `Read-QuestValidateConfig` | `validate_questops_config.ps1` | Reads and parses JSON config with try/catch (exit 3 on malformed) |

## Ignored files (gitignored at repo level)

The `.gitignore` protects the following categories from accidental commits:

| Category | Files ignored | Notes |
|----------|---------------|-------|
| Secrets | `.env`, `.env.*`, `*.secret.json`, `*secrets*.json` | Never commit secrets |
| Local configs | `config/*.local.json`, `config/*private*.json` | Machine-specific overrides |
| Generated reports | `reports/*` (except `reports/.gitkeep`) | Overwritten each scan (includes `reports/history/*`) |
| Logs | `logs/*` (except `logs/.gitkeep`) | Runtime output |
| Runtime state | `state/*` (except `state/.gitkeep`) | Future runtime state |
| Temp files | `tmp/`, `temp/`, `*.tmp`, `*.bak` | Editor/OS detritus |
| Build output | `dist/`, `out/`, `release/` | Never committed (exported packages go here) |
| OS/editor junk | `.DS_Store`, `Thumbs.db`, `.vscode/`, `.idea/` | Cross-platform safety |

## Planned / Not Implemented Yet

The following do not exist and are not implemented:
- Alert config files (webhook URLs, thresholds per server)
- Log rotation (log file rotates daily or by size; `-KeepLogs` is reserved for this)

## Exit codes - questops_scan.ps1

| Code | Meaning |
|------|---------|
| 0 | All checks passed |
| 1 | One or more checks failed |
| 2 | Config file not found |
| 3 | Config file contains invalid JSON |
| 4 | Report path invalid |

## Exit codes - questops_discord_alert.ps1

| Code | Meaning |
|------|---------|
| 0 | Alert sent, or no alert needed (report passed, -Force not used) |
| 2 | `QUESTOPS_DISCORD_WEBHOOK_URL` environment variable not set |
| 3 | Report file missing or malformed |
| 4 | Discord webhook send failed |

## Exit codes - questops_run.ps1

| Code | Meaning |
|------|---------|
| 0 | Scan passed and alert step succeeded or was skipped |
| 1 | Scan completed but one or more checks failed |
| 2 | Scan config missing |
| 3 | Scan config malformed or report malformed |
| 4 | Report path invalid or Discord send failed |

If scan fails with a config/report error (exit 2-4), the alert step is skipped.
If scan completes (exit 0/1), the alert step runs unless `-NoAlert` is used.

## Exit codes - install / uninstall scripts

| Code | Meaning |
|------|---------|
| 0 | Task registered, updated, or unregistered successfully |
| 1 | Task operation failed |
| 2 | Project root or `questops_run.ps1` not found |
| 3 | Task already exists and `-Force` not used |

## Exit codes - validate_questops_config.ps1

| Code | Meaning |
|------|---------|
| 0 | Config is structurally valid |
| 2 | Config file not found at the specified path |
| 3 | Config contains invalid JSON or structural errors (missing required fields, wrong types, out-of-range values) |

Validates structure only - does not check folder existence, process running, port reachability, or log freshness at runtime.

## Exit codes - export_questops_audit_package.ps1

| Code | Meaning |
|------|---------|
| 0 | Package created successfully |
| 1 | Package creation failed (or file exists without `-Force`) |
| 2 | Required source file missing |
| 3 | Safety scan failed - hardcoded secrets detected in included files |

## Exit codes - export_questops_audit_results.ps1

| Code | Meaning |
|------|---------|
| 0 | Audit results package created successfully |
| 1 | Package creation failed (or file exists without `-Force`) |
| 2 | Required report or HTML file missing |
| 3 | Safety scan failed or HTML generation failed |
| 4 | Invalid output path |

## Exit codes - build_questops_client_release.ps1

| Code | Meaning |
|------|---------|
| 0 | Release build completed successfully |
| 1 | Release build failed |
| 2 | Required file or script (e.g. VERSION) missing |
| 3 | Validation or safety check failed (config, scan, export) |
| 4 | Dirty git working tree and `-AllowDirty` not used |

## Exit codes - export_questops_html_report.ps1

| Code | Meaning |
|------|---------|
| 0 | HTML report created successfully |
| 2 | JSON report file not found |
| 3 | JSON report is malformed |
| 4 | HTML report write failed |

## Exit codes - export_questops_dashboard.ps1

| Code | Meaning |
|------|---------|
| 0 | Dashboard created successfully |
| 2 | Latest report file not found |
| 3 | Latest report contains invalid JSON |
| 4 | Dashboard file write failed |
| 5 | Dashboard created with history read warnings (bad history files skipped) |

## Known constraints

1. **Windows only** - no cross-platform support. Script uses `Get-PSDrive`, `Get-Process`, and `PSDrive.Root` which are Windows-specific.
2. **PowerShell 5.1 only** - do not use `&&`, `||`, `??`, ternary `? :`, or other features from PowerShell 6+ / PowerShell Core.
3. **No secrets management** - webhook URLs, tokens, passwords are not stored. Any future implementation must use environment variables or gitignored config.
4. **Single drive assumption** - disk check uses `PSDrive.Root`. Mapped drives, UNC paths, or mount points may not report correctly.
5. **Process name matching** - uses `Get-Process` with the `.exe` stripped. Renamed or wrapped processes may be missed.
6. **Run as current user** - the scheduled task uses `S4U` logon and runs with the current user's rights without storing passwords. The `QUESTOPS_DISCORD_WEBHOOK_URL` environment variable must be set for the task user if alerting is enabled.

## PowerShell 5.1 compatibility rules

- No ternary operators (`$x ? 'a' : 'b'` - PowerShell 7+ only)
- No null-coalescing operators (`??`, `??=` - PowerShell 7+ only)
- No `ConvertFrom-Json -AsHashtable` (PowerShell 6+ only)
- No `Get-Content -AsByteStream` (PowerShell 7+ only)
- No `&&` / `||` pipeline chain operators (PowerShell 7+ only)
- Use `New-Object` instead of class syntax for .NET types
- Use `[PSCustomObject]@{ }` for hashtable-to-object casts
- Use `-replace` operator for regex replacement (not `.Replace()` method for regex)
- File paths must use `Join-Path`, never string concatenation

## Secret-handling rules

- Never hardcode webhook URLs, passwords, tokens, IPs, or connection strings.
- Secrets must come from environment variables or gitignored config files.
- If a secret is required, the script must fail with a clear message if it is not set.
- Example: `$env:QUESTOPS_DISCORD_WEBHOOK_URL` for Discord notifications.

## Validation commands

### Resource usage - inspect report fields
```powershell
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.results | Select-Object server_name, resources_ok, logs_ok, network_ok, passed
$report.results | ForEach-Object { $_.resource_checks }
$report.results | ForEach-Object { $_.resource_checks | Format-List * }
```

### Log freshness - inspect report fields
```powershell
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.results | Select-Object server_name, logs_ok, network_ok, passed
$report.results | ForEach-Object { $_.log_checks }
```

### Network reachability - inspect report fields
```powershell
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.results | Select-Object server_name, network_ok, passed
$report.results | ForEach-Object { $_.network_checks }
```

### Validate config structure (safe local demo)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1
```
Expected: exits 0. Output shows `valid=true`, `server_count=1`, `servers_valid=1`, `servers_invalid=0`, `errors=[]`.

### Validate config structure (game server template)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath config\servers.game.example.json
```
Expected: exits 0. Output shows `valid=true`, `server_count=2`, `servers_valid=2`.

### Validate config - missing file
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath config\missing.json
```
Expected: exits 2. Output shows `valid=false`, `errors` contains "Config file not found".

### Validate config - malformed JSON
```powershell
Set-Content "$env:TEMP\bad.json" -Value "not json" -Force
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath "$env:TEMP\bad.json"
```
Expected: exits 3. Output shows `valid=false`, `errors` contains "Invalid JSON".

### Validate config - missing required field
```powershell
Set-Content "$env:TEMP\bad-config.json" -Value '[{"name":"test"}]' -Force
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath "$env:TEMP\bad-config.json"
```
Expected: exits 3. Output shows `valid=false`, `errors` lists missing required fields.

### Test config with all check types (game server template)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -ConfigPath config\servers.game.example.json
```
Expected: script runs without crash (results depend on actual folder/process/port existence - demo uses fake placeholder paths).

### Normal scan (safe local demo - default config)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1
```
Expected: exits 0. Report shows `overall_pass=true`. The safe local demo (C:\Windows, powershell.exe, 1 GB threshold) passes on any Windows machine.

### With verbose output
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -Verbose
```

### Capture report to variable (no warnings)
```powershell
$r = & "scripts\questops_scan.ps1"; $r.overall_pass; $r.results
```

### Missing config test
```powershell
& "scripts\questops_scan.ps1" -ConfigPath "C:\nonexistent.json"
```
Expected: exit code 2, error object with `exit_code=2` and `fault=MISSING_CONFIG`.

### Malformed config test
```powershell
Set-Content "$env:TEMP\bad.json" -Value "not json" -Force
& "scripts\questops_scan.ps1" -ConfigPath "$env:TEMP\bad.json"
```
Expected: exit code 3, error object with `exit_code=3` and `fault=MALFORMED_CONFIG`.

### Custom report path
```powershell
& "scripts\questops_scan.ps1" -ReportPath "$env:TEMP\my-report.json"
```
Expected: report written to specified path, BOM-less UTF-8, valid JSON.

### Improved alert message - failed categories detail
The alert now shows per-server failed categories (folder, disk, process, network, logs, resources) with details like `network (127.0.0.1:16261)`, `logs (PZ console log)`, and `resources (ProjectZomboid64.exe mem cpu)`. Long messages are truncated to stay within Discord's 2000 character limit.

To view the full alert content that would be sent, inspect the report directly:
```powershell
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.results | Where-Object { -not $_.passed } | ForEach-Object {
  Write-Host "$($_.server_name): " -NoNewline
  $cats = @()
  if (-not $_.folder_exists) { $cats += "folder" }
  if (-not $_.disk_ok) { $cats += "disk" }
  if (-not $_.process_running) { $cats += "process" }
  if ($_.PSObject.Properties.Name -contains "network_ok" -and -not $_.network_ok) { $cats += "network" }
  if ($_.PSObject.Properties.Name -contains "logs_ok" -and -not $_.logs_ok) { $cats += "logs" }
  if ($_.PSObject.Properties.Name -contains "resources_ok" -and -not $_.resources_ok) { $cats += "resources" }
  Write-Host ($cats -join ", ")
}
```

### Discord alert - missing webhook
```powershell
Remove-Item Env:\QUESTOPS_DISCORD_WEBHOOK_URL -ErrorAction SilentlyContinue
& "scripts\questops_discord_alert.ps1" -ReportPath reports\latest-health-report.json -Force
```
Expected: exit code 2, error object with `exit_code=2` and `fault=MISSING_WEBHOOK_URL`.

### Discord alert - forced test (set webhook first)
```powershell
$env:QUESTOPS_DISCORD_WEBHOOK_URL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"
& "scripts\questops_discord_alert.ps1" -ReportPath reports\latest-health-report.json -Force
```
Expected: exit code 0, "Discord alert sent." Webhook URL must be valid.

### Discord alert - normal mode (only sends on failure)
```powershell
& "scripts\questops_discord_alert.ps1" -ReportPath reports\latest-health-report.json
```
Expected: if report shows `overall_pass=true`, exits 0 with "No alert sent." If `overall_pass=false`, sends alert.

### Run scan + alert (one command)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1
```
Expected: runs scan, then runs alert on failure. Exit code depends on scan and alert outcome.

### Run scan only (skip alert)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert
```
Expected: scan runs, alert skipped. Exit code reflects scan result (0 or 1).

### Run scan + force alert
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -ForceAlert
```
Expected: scan runs, alert forced regardless of scan result.

### Missing config via orchestrator
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -ConfigPath config\missing.json
```
Expected: exit code 2 (propagated from scan script).

### Run scan with log and history
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert
```
Expected: scan runs, alert skipped, log written to `logs\questops-run.log`, timestamped copy in `reports\history\`.

### Check report history
```powershell
Get-ChildItem reports\history -Filter *.json | Sort-Object LastWriteTime -Descending | Select-Object -First 5 FullName, LastWriteTime
```
Expected: lists recent timestamped reports.

### Check log
```powershell
Get-Content logs\questops-run.log -Tail 40
```
Expected: shows most recent run log entries.

### Test custom retention
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert -KeepReports 3
```
Expected: scan runs, only the newest 3 reports remain in history.

### Verify retention count
```powershell
Get-ChildItem reports\history -Filter *.json | Measure-Object
```
Expected: count of historical report files.

### Test no retention
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert -NoRetention
```
Expected: scan runs, report written but no cleanup performed.

### Scheduled task - dry run
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install_questops_task.ps1 -WhatIf
```
Expected: shows what would be registered without creating the task.

### Scheduled task - install (scan only, every 15 min)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install_questops_task.ps1 -NoAlert -Force
```
Expected: task registered, exit code 0.

### Scheduled task - inspect
```powershell
Get-ScheduledTask -TaskName "QuestOps Watchdog"
```
Expected: task exists with PowerShell trigger repeating every 15 minutes.

### Scheduled task - run manually
```powershell
Start-ScheduledTask -TaskName "QuestOps Watchdog"
```
Expected: task starts, results visible via `Get-ScheduledTaskInfo`.

### Scheduled task - uninstall
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\uninstall_questops_task.ps1 -Force
```
Expected: task removed, exit code 0.

### Export audit package
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_package.ps1 -Force
```
Expected: exits 0. Package written to `dist\questops-watchdog-audit-package-*.zip`. Output shows `success=true`, `included_count=56`.

### List exported packages
```powershell
Get-ChildItem dist -Filter *.zip | Sort-Object LastWriteTime -Descending | Select-Object -First 3 FullName, Length, LastWriteTime
```
Expected: lists the most recent packages in `dist\`.

### Inspect zip contents
```powershell
$zip = Get-ChildItem dist -Filter *.zip | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::OpenRead($zip.FullName).Entries | Select-Object FullName
```
Expected: lists all 56 included files with forward-slash paths.

### Check excluded files are not in zip
```powershell
[System.IO.Compression.ZipFile]::OpenRead($zip.FullName).Entries | Where-Object {
    $_.FullName -match '\.env|servers\.local\.json|reports/.+\.json|logs/.+\.log|\.git/' -or
    ($_.FullName -match '^state/.+' -and $_.FullName -ne 'state/.gitkeep')
} | Select-Object FullName
```
Expected: no results (empty output).

### Export HTML report (default paths)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1
```
Expected: exits 0. HTML report written to `reports\latest-health-report.html`. Output shows `success=true`, `exit_code=0`.

### Check HTML report exists
```powershell
Test-Path reports\latest-health-report.html
```
Expected: `True`.

### Custom HTML report path
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1 -OutputPath reports\manual-audit-report.html
```
Expected: exits 0. HTML written to custom path.

### Missing JSON report (expect exit 2)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1 -ReportPath reports\missing-report.json
```
Expected: exits 2. Warning shown, output shows `success=false`, `exit_code=2`.

### Confirm generated HTML reports are not packaged
```powershell
[System.IO.Compression.ZipFile]::OpenRead($zip.FullName).Entries | Where-Object {
    $_.FullName -match 'latest-health-report\.html|manual-audit-report\.html|reports/.+\.html'
} | Select-Object FullName
```
Expected: no results (empty output).

### Generate dashboard
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1
```
Expected: exits 0 (or 5 if history has warnings). Dashboard written to `reports\questops-dashboard.html`. Output shows `success=true`, `exit_code=0`.

### Generate dashboard with custom output
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -OutputPath reports\manual-dashboard.html
```
Expected: exits 0. Dashboard written to custom path.

### Missing latest report test (expect exit 2)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -ReportPath reports\missing-report.json
```
Expected: exits 2. Warning shown, output shows `success=false`, `exit_code=2`.

### Open dashboard in browser
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -Open
```
Expected: dashboard generated and opened in default browser.

### Confirm generated dashboard files are not packaged
```powershell
[System.IO.Compression.ZipFile]::OpenRead($zip.FullName).Entries | Where-Object {
    $_.FullName -match 'questops-dashboard\.html|manual-dashboard\.html'
} | Select-Object FullName
```
Expected: no results (empty output).

### Dashboard final validation

See `docs/dashboard/DASHBOARD_FINAL_VALIDATION_COMMANDS.md` for the complete one-page validation command reference covering:
- Safe scan, HTML audit export, dashboard export
- Trend label check, status filter check, no external dependency check
- Missing report error page, malformed report error page, partial report warning box
- Package export, package count check, generated files exclusion check
- VERSION check, git status check

### Dashboard error state - missing report test (expect exit 2, error page)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -ReportPath reports\nonexistent.json
```
Expected: exits 2. Error page written to default dashboard output path with "Report Not Found" title.

### Dashboard error state - malformed report test (expect exit 3, error page)
```powershell
Set-Content "$env:TEMP\bad-dashboard-report.json" -Value "not valid json" -Force
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -ReportPath "$env:TEMP\bad-dashboard-report.json"
```
Expected: exits 3. Error page written with "Malformed Report" title.

### Dashboard partial field test (expect exit 0, warning box)
```powershell
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.PSObject.Properties.Remove("total_servers")
$report.PSObject.Properties.Remove("passed_checks")
$report.PSObject.Properties.Remove("failed_checks")
$report.results[0].PSObject.Properties.Remove("network_checks")
$report.results[0].PSObject.Properties.Remove("log_checks")
$json = $report | ConvertTo-Json -Depth 10
Set-Content "$env:TEMP\partial-report.json" -Value $json -Force
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -ReportPath "$env:TEMP\partial-report.json" -OutputPath "$env:TEMP\partial-dashboard.html"
```
Expected: exits 0. Dashboard generated with warning box showing inferred field messages.

### Dashboard history trend validation
```powershell
# Check trend section contains enhanced metrics
Select-String -Path reports\questops-dashboard.html -Pattern "Pass / Fail Summary|Streak &amp; Timeline|Repeated Failure Insights|timeline-pill|Current streak|Longest streak|Pass rate|Fail rate|Failures by Category"

# Check timeline pills exist
Select-String -Path reports\questops-dashboard.html -Pattern "timeline-pill-pass|timeline-pill-fail"

# Check no external dependencies
Select-String -Path reports\questops-dashboard.html -Pattern "https://|http://|script src|cdn|fonts.googleapis"
```
Expected: trend section metrics present, timeline pills found, no external URLs.

### Visual polish and status filter validation
```powershell
# Check dashboard contains filter labels / sections
Select-String -Path reports\questops-dashboard.html -Pattern "All Servers|Passing|Failing|filter|print|@media print"

# Confirm no external dependencies
Select-String -Path reports\questops-dashboard.html -Pattern "https://|http://|script src|cdn|fonts.googleapis"

# Check empty states exist in HTML
Select-String -Path reports\questops-dashboard.html -Pattern "No passing servers|All servers passing"

# Confirm CSS-only radio tabs (no JS)
Select-String -Path reports\questops-dashboard.html -Pattern "<script"
```
Expected: filter labels present, no external URLs found, empty-state messages present, no `<script>` tags found.

### Check dashboard docs exist
```powershell
Test-Path docs\DASHBOARD_GUIDE.md
Test-Path docs\demo\SAMPLE_DASHBOARD_PREVIEW.md
```
Expected: `True` for both.

### Export with missing file (expect exit 2)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_package.ps1 -PackageName test-package
```
Expected: runs normally (doc files exist). To test missing file, temporarily rename a required file.

### Export audit results bundle
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1 -Force
```
Expected: exits 0. Package written to `dist\questops-watchdog-audit-results-*.zip`. Output shows `success=true`.

### Inspect latest audit results bundle
```powershell
$resultsZip = Get-ChildItem dist -Filter "questops-watchdog-audit-results-*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::OpenRead($resultsZip.FullName).Entries | Select-Object FullName
```
Expected: lists `reports/latest-health-report.json`, `reports/latest-health-report.html`, and `audit-results-manifest.json`.

### Confirm expected files in results bundle
```powershell
[System.IO.Compression.ZipFile]::OpenRead($resultsZip.FullName).Entries | Where-Object {
    $_.FullName -match 'latest-health-report\.json|latest-health-report\.html|audit-results-manifest\.json'
} | Select-Object FullName
```
Expected: three results (JSON, HTML, manifest).

### Export audit results with config/log optional
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1 -IncludeConfig -IncludeLog -Force
```
Expected: exits 0. Config and log are included if they exist; warnings are recorded in manifest if they don't.

### Refresh HTML in results bundle
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1 -RefreshHtml -Force
```
Expected: exits 0. HTML report is regenerated even if it already existed.

### No-generate HTML (expect exit 2 when missing)
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1 -NoGenerateHtml -Force
```
Expected: if HTML exists, exits 0; if HTML is missing, exits 2.

### Confirm generated reports/HTML are NOT in the tool package
```powershell
$toolZip = Get-ChildItem dist -Filter "questops-watchdog-audit-package-*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
[System.IO.Compression.ZipFile]::OpenRead($toolZip.FullName).Entries | Where-Object {
    $_.FullName -match 'latest-health-report\.json|latest-health-report\.html|manual-audit-report\.html|audit-results-manifest\.json|release-manifest\.json'
} | Select-Object FullName
```
Expected: no results (empty output).

### Confirm client package includes version/release docs
```powershell
$toolZip = Get-ChildItem dist -Filter "questops-watchdog-audit-package-*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
[System.IO.Compression.ZipFile]::OpenRead($toolZip.FullName).Entries | Where-Object {
    $_.FullName -match '^VERSION$|^CHANGELOG\.md$|docs/RELEASE_NOTES_v0\.4\.9\.md'
} | Select-Object FullName
```
Expected: three results (VERSION, CHANGELOG.md, docs/RELEASE_NOTES_v0.4.9.md).

### Run release build
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build_questops_client_release.ps1 -AllowDirty -Force
```
Expected: exits 0. Output shows release path under `dist\questops-watchdog-v0.4.9\`, package and results filenames, SHA256 checksums.

### Inspect release output
```powershell
Get-ChildItem dist\questops-watchdog-v0.4.9 -Recurse | Select-Object FullName, Length, LastWriteTime
```
Expected: lists package zip, results zip, two .sha256 files, and release-manifest.json.

### Inspect release manifest
```powershell
Get-Content dist\questops-watchdog-v0.4.9\release-manifest.json -Raw | ConvertFrom-Json
```
Expected: valid JSON with product, version, timestamps, checksums, git info, warnings.

## Agent workflow rules

These rules bind every AI agent that modifies this repository.

**Before every code edit**, the AI agent must read:
- `README.md`
- `docs/PROJECTMAP.md` if it exists
- `docs/TASKS.md` if it exists

**After every code edit**, the AI agent must update:
- `docs/PROJECTMAP.md` if structure, files, scripts, config, outputs, or commands changed
- `README.md` if usage, requirements, commands, limitations, or product behavior changed
- `docs/TASKS.md` if task status changed

**Additional rules** (from `docs/AGENT_RULES.md`):
1. No full rewrites - make small, surgical changes.
2. Keep PowerShell 5.1 compatible.
3. No hardcoded secrets.
4. Every feature must have a validation command.
5. Prefer simple local JSON before database/cloud complexity.
6. Do not commit unless asked.

## Last updated

2026-05-26 - v0.4.14: Added docs/assets/placeholders/ with 6 placeholder docs (README hero, HTML report, Discord alert, PowerShell scan, package zip, landing page). Updated README layout polish — moved Screenshots near Demo, updated milestone, added placeholders section. Updated package to 52 files. Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG, CLIENT_HANDOFF_CHECKLIST, RELEASE_CHECKLIST, export script.

2026-05-26 - v0.4.15: Created docs/launch/ with 7 internal launch docs (OUTREACH_LAUNCH_CHECKLIST, FIRST_BETA_AUDIT_WORKFLOW, BETA_AUDIT_INTAKE_FORM, BETA_AUDIT_DELIVERY_TEMPLATE, OUTREACH_TRACKER_TEMPLATE, BETA_FEEDBACK_FORM, LAUNCH_MESSAGE_PACK). Updated README with Launch / beta audit workflow section. Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG. VERSION unchanged (0.4.9). docs/launch/ excluded from export script (internal-only).

2026-05-26 - v0.4.16: Created docs/release/ with 6 release prep docs (GITHUB_RELEASE_DRAFT_v0.4.9, PUBLIC_LAUNCH_CHECKLIST, PUBLIC_ANNOUNCEMENT_COPY, RELEASE_ASSET_CHECKLIST, FIRST_WEEK_FEEDBACK_TRACKER, PUBLIC_REPO_REVIEW_CHECKLIST). Updated README with Public release preparation section. Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG. VERSION unchanged (0.4.9). docs/release/ excluded from export script (internal-only).

2026-05-26 - v0.4.17: Created docs/audit/ with 7 internal audit report docs (BETA_AUDIT_REPORT_TEMPLATE, FINDINGS_SEVERITY_GUIDE, COMMON_FINDINGS_LIBRARY, RECOMMENDATION_STYLE_GUIDE, BETA_AUDIT_REPORT_SAMPLE, BETA_AUDIT_INTERNAL_REVIEW_CHECKLIST, BETA_AUDIT_DELIVERY_MESSAGE_POLISHED). Updated README with Beta audit reporting section. Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG. VERSION unchanged (0.4.9). docs/audit/ excluded from export script (internal-only).

2026-05-26 - v0.4.18: Restructured README top-level flow: Current status, Try it in 5 minutes (with git clone), Use it with real servers, What it checks, Outputs, Demo examples, Screenshots, Commercial audit offer, Safety/security notes, then deeper technical sections. Added "Try it in 5 minutes", "Use it with real servers", and "Outputs" sections. Moved Demo, Commercial audit, Safety to top area. Moved "Who it is for" and "Requirements" to deeper section area. Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG. VERSION unchanged (0.4.9).

2026-05-26 - v0.4.19: Created docs/QUICK_START.md (standalone quick-start guide). Created docs/qa/ with 3 internal QA docs (PUBLIC_REPO_REVIEW_CHECKLIST, RELEASE_CHECKLIST, RELEASE_ASSET_CHECKLIST). Updated client package to 53 files. Updated README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG, RELEASE_CHECKLIST, RELEASE_ASSET_CHECKLIST. VERSION unchanged (0.4.9).

2026-05-26 - v0.4.20: Created docs/dashboard/ with 7 internal dashboard planning docs (V0_5_DASHBOARD_PLANNING_BRIEF, DASHBOARD_MVP_REQUIREMENTS, DASHBOARD_DATA_MODEL, DASHBOARD_UI_WIREFRAME, DASHBOARD_SECURITY_NOTES, DASHBOARD_IMPLEMENTATION_OPTIONS, DASHBOARD_TEST_PLAN). Updated README with v0.5 dashboard planning section. Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG. VERSION unchanged (0.4.9). docs/dashboard/ excluded from export script (internal planning only).

2026-05-26 - v0.5.0: Created scripts/export_questops_dashboard.ps1 (local HTML dashboard exporter with summary cards, server table, failed details, history summary, trend summary). Created docs/DASHBOARD_GUIDE.md (dashboard user guide). Created docs/demo/SAMPLE_DASHBOARD_PREVIEW.md (fictional ASCII preview). Updated README with Local dashboard section. Updated client package to 56 files (added dashboard script + 2 docs). Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG, CLIENT_HANDOFF_CHECKLIST, RELEASE_CHECKLIST, export script. VERSION unchanged (0.4.9).

2026-05-27 - v0.5.1: Improved local dashboard visual polish with better spacing, section hierarchy, summary cards, PASS/FAIL badges, table readability, empty states, CSS-only All/Passing/Failing filters, responsive table behavior, and print layout refinements. Updated DASHBOARD_GUIDE, SAMPLE_DASHBOARD_PREVIEW, README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG. Package count unchanged at 56 files. VERSION unchanged (0.4.9).

2026-05-27 - v0.5.2: Improved local dashboard history trend polish with pass/fail counts, pass/fail rates, failures by category, current/longest streaks, PASS/FAIL timeline pills, repeated failure insights, and normalized timeline deduplication by scan_timestamp_utc. Added dashboard trend helper functions. Updated DASHBOARD_GUIDE, SAMPLE_DASHBOARD_PREVIEW, README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG. Package count unchanged at 56 files. VERSION unchanged (0.4.9).

2026-05-27 - v0.5.3: Improved local dashboard error-state handling with safe error pages for missing/malformed reports, report shape validation, safe field accessors, consolidated warning box, inferred defaults for missing fields, and graceful optional field handling. Updated DASHBOARD_GUIDE, SAMPLE_DASHBOARD_PREVIEW, README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG. Package count unchanged at 56 files. VERSION unchanged (0.4.9).

2026-05-27 - v0.5.4: Added dashboard release readiness checklist, screenshot pass plan, and final validation commands. Created DASHBOARD_RELEASE_READINESS_CHECKLIST, DASHBOARD_SCREENSHOT_PASS, DASHBOARD_FINAL_VALIDATION_COMMANDS. Updated README, DASHBOARD_GUIDE, assets README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG. Package count unchanged at 56 files. VERSION unchanged (0.4.9).

2026-05-27 - v0.5.5: Added dashboard release candidate review docs. Created DASHBOARD_RELEASE_CANDIDATE_REVIEW, DASHBOARD_RC_PACKAGE_CONTENTS, DASHBOARD_RC_SIGNOFF_NOTES under docs/release/. Updated README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG. Package count unchanged at 56 files. VERSION unchanged (0.4.9). docs/release/ remains excluded from client package.

2026-05-30 - v0.5.6: Added dashboard release notes preparation docs. Created DASHBOARD_RELEASE_NOTES_DRAFT_v0.5, DASHBOARD_PUBLIC_ANNOUNCEMENT_DRAFT, DASHBOARD_RELEASE_NOTES_CHECKLIST under docs/release/. Updated README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG. Package count unchanged at 56 files. VERSION unchanged (0.4.9). docs/release/ remains excluded from client package.

2026-05-30 - v0.5.7: Added dashboard release build dry-run docs. Created DASHBOARD_RELEASE_BUILD_DRY_RUN, DASHBOARD_RELEASE_BUILD_DRY_RUN_RESULTS, DASHBOARD_RELEASE_BUILD_PRECHECKS under docs/release/. Updated README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG. Package count unchanged at 56 files. VERSION unchanged (0.4.9). docs/release/ remains excluded from client package.
