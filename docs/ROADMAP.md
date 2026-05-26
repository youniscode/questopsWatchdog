# QuestOps Watchdog — Roadmap

## v0.1 — Local Health Scan (shipped)
- [x] Project scaffold (dirs, docs, example config)
- [x] `questops_scan.ps1` — folder existence, disk space, process check
- [x] JSON report written to `reports/latest-health-report.json`
- [ ] Repo initialised and first commit

## v0.2 — Discord Webhook Alerting (shipped)
- [x] `questops_discord_alert.ps1` — reads report, sends Discord alert on failure
- [x] `-Force` switch for test alerts
- [x] Clean error handling (missing webhook, malformed report, send failure)

## v0.2.1 — Integrated Scan + Alert Workflow (shipped)
- [x] `questops_run.ps1` — orchestrator: runs scan then optionally sends alert
- [x] Parameters: `-ConfigPath`, `-ReportPath`, `-NoAlert`, `-ForceAlert`
- [x] Clean exit code propagation (0/1/2/3/4)

## v0.3 — Scheduled Execution (shipped)
- [x] `install_questops_task.ps1` — register recurring task via Task Scheduler
- [x] `uninstall_questops_task.ps1` — remove task
- [x] Parameters: `-TaskName`, `-ProjectRoot`, `-IntervalMinutes`, `-NoAlert`, `-Force`, `-WhatIf`
- [x] Runs as current user via S4U logon (no password storage)

## v0.3.1 — Report Retention and Logging (shipped)
- [x] Report retention / rotation for old reports (`reports/history/`, `-KeepReports`, `-NoRetention`)
- [x] Log file output for scheduled runs (`logs/questops-run.log`, `-LogPath`)
- [x] `Write-QuestLog`, `Copy-QuestTimestampedReport`, `Invoke-QuestReportRetention` helper functions
- [x] `-KeepLogs` parameter reserved for future log rotation

## v0.4 — Network Reachability Checks (shipped)
- [x] `Test-QuestTcpPort` helper function
- [x] Optional `network_checks` array in server config
- [x] `network_checks` and `network_ok` in per-server report results
- [x] Backward compatible — existing configs without `network_checks` work unchanged
- [x] Timeout, error handling, invalid parameter handling

## v0.4.1 — Log Staleness Checks (shipped)
- [x] `Test-QuestLogFreshness` helper function
- [x] Optional `log_checks` array in server config
- [x] `log_checks` and `logs_ok` in per-server report results
- [x] Backward compatible — existing configs without `log_checks` work unchanged
- [x] Error handling for missing files, invalid thresholds, permission errors

## v0.4.2 — Process CPU and Memory Usage (shipped)
- [x] `Test-QuestProcessResources` helper function
- [x] Optional `resource_checks` array in server config
- [x] `resource_checks` and `resources_ok` in per-server report results
- [x] Backward compatible — existing configs without `resource_checks` work unchanged
- [x] Memory aggregation across multiple matching processes
- [x] CPU sampling via `TotalProcessorTime` with configurable sample window
- [x] Informational mode when threshold is 0 or missing

## v0.4.3 — Alert Message Improvements (shipped)
- [x] Per-server failed category breakdown (folder, disk, process, network, logs, resources)
- [x] Detail lines for failed optional checks (host:port, log name, process mem/cpu)
- [x] Safe truncation within Discord's 2000 character limit
- [x] Forced test alert clearly marked as `(FORCED TEST)`
- [x] Backward compatible with older reports missing optional fields
- [x] Helper functions: `Get-QuestFailedCategories`, `Format-QuestFailedServerLine`, `Format-QuestDiscordAlertMessage`, `Limit-QuestDiscordMessage`

## v0.4.4 — Config Validation and Safer Examples (shipped)
- [x] Create `config/servers.game.example.json` — game server template with fake placeholder paths (Project Zomboid, Minecraft)
- [x] Rewrite `config/servers.example.json` as safe local demo (C:\Windows, powershell.exe, 1 GB threshold, no optional checks)
- [x] Create `scripts/validate_questops_config.ps1` — validates JSON syntax, required fields, types, and ranges
- [x] Document three config file roles (demo, template, local)
- [x] Update all docs (PROJECTMAP, README, TASKS, ROADMAP)

## v0.4.5 — First Client-Ready Audit Package (shipped)
- [x] Create `scripts/export_questops_audit_package.ps1` — creates clean zip with preflight safety scan
- [x] Create `docs/CLIENT_AUDIT_GUIDE.md` — client-facing setup and scan guide
- [x] Create `docs/CLIENT_HANDOFF_CHECKLIST.md` — delivery checklist with security reminders
- [x] Prevent secrets (webhook URLs, local configs, reports, logs) from being packaged
- [x] Document export exit codes and validation commands

## v0.4.6 — HTML Audit Report Export (shipped)
- [x] Create `scripts/export_questops_html_report.ps1` — standalone HTML exporter with inline CSS
- [x] Read JSON report, generate professional audit HTML with PASS/FAIL badges, summary cards, per-server detail, and optional check tables
- [x] Escape all HTML content, exclude secrets, no JavaScript/CDN/external deps
- [x] Update export package script to include the new exporter (21 files)
- [x] Document HTML export in README, PROJECTMAP, CLIENT_AUDIT_GUIDE, CLIENT_HANDOFF_CHECKLIST

## v0.4.7 — HTML Report Package Integration Polish (shipped)
- [x] Create `scripts/export_questops_audit_results.ps1` — audit results bundle exporter
- [x] Package JSON report, HTML report, and manifest into `dist/questops-watchdog-audit-results-*.zip`
- [x] Auto-generate HTML if missing; `-RefreshHtml` and `-NoGenerateHtml` flags
- [x] Safety scan for secrets (webhook URLs, passwords, tokens, secrets)
- [x] Optional config (`-IncludeConfig`) and log (`-IncludeLog`) with safety scan
- [x] Generate `audit-results-manifest.json` inside zip without writing to disk
- [x] Update tool package to include the new script (22 files)

## v0.4.8 — Release Hygiene and First Tagged Client Build (shipped)
- [x] Create `VERSION` file with current version number
- [x] Create `CHANGELOG.md` with version history
- [x] Create `docs/RELEASE_NOTES_v0.4.8.md` — client-facing release notes
- [x] Create `docs/RELEASE_CHECKLIST.md` — internal pre-release validation steps
- [x] Create `scripts/build_questops_client_release.ps1` — repeatable release build workflow
- [x] Release build: config validation, safe scan, HTML export, package export, results export, checksums, release manifest
- [x] Release build checks git status; fails on dirty unless `-AllowDirty`
- [x] Run all validation steps, copy packages with SHA256 checksums, write `release-manifest.json`
- [x] Update tool package to include `VERSION`, `CHANGELOG.md`, `RELEASE_NOTES_v0.4.8.md` (25 files)

## v0.4.9 — Paid Audit Offer Kit and Landing Copy (shipped)
- [x] Create `docs/business/` with 7 business documentation files
- [x] Landing page copy, pricing tiers, sample report examples
- [x] Outreach message templates and proposal template
- [x] GitHub positioning guidance and pricing strategy notes
- [x] Update tool package to 31 files (6 business docs included)

## v0.4.10 — Public GitHub Polish (shipped)
- [x] Issue templates (bug report, feature request)
- [x] Pull request template
- [x] Security policy (SECURITY.md)
- [x] Contribution guidelines (CONTRIBUTING.md)
- [x] License note (LICENSE-NOTE.md)
- [x] README polish with GitHub-friendly intro and links

## v0.4.11 — Sample Screenshots and Demo Assets (shipped)
- [x] Sample health report JSON (passing + failing server)
- [x] HTML report preview (ASCII-style layout description)
- [x] Sample Discord alert messages (various scenarios)
- [x] Sample audit results manifest (fictional manifest examples)
- [x] Sample client before/after transformation story
- [x] Assets folder with naming convention and rules
- [x] Updated tool package to include demo docs (37 files)

## v0.4.12 — Website Landing Page Draft (shipped)
- [x] Complete landing page draft (hero, problem, solution, who it's for, what it checks, how it works, pricing, demo, security, FAQ, CTA)
- [x] Homepage wireframe (ASCII layout with nav, hero, trust strip, features, demo, pricing, timeline, FAQ, footer)
- [x] Copy snippets (5 alternative headlines, subheadlines, CTAs, social posts, repo descriptions, audit descriptions, FAQ variants)
- [x] SEO guidance (keywords, target audience, ranking sections, phrases to avoid, honest positioning, technical notes)
- [x] Updated tool package to include website docs (41 files)

## v0.4.13 — Real Screenshot Capture Checklist (shipped)
- [x] Define screenshot capture workflow (which features, what scenarios)
- [x] Create redaction/anonymisation rules
- [x] Create screenshot planning docs (capture checklist, shot list, demo script, review checklist)
- [x] Updated tool package to include all screenshot docs (46 files)

## v0.4.14 — Screenshot Placeholder References and README Layout Polish (shipped)
- [x] Create docs/assets/placeholders/ with 6 placeholder docs (README hero, HTML report, Discord alert, PowerShell scan, package zip, landing page)
- [x] Update docs/assets/README.md with placeholders section
- [x] Polish README layout — Screenshots section near Demo, milestone updated, placeholder references added
- [x] Updated tool package to include placeholder docs (52 files)

## v0.4.15 — Outreach Launch Checklist and First Beta Audit Workflow
- [ ] Create outreach checklist docs
- [ ] Define beta audit workflow
- [ ] First beta audit with real client (if applicable)

## v0.5 — Dashboard (optional)
- [ ] Local HTML report viewer
- [ ] Historical trend chart
