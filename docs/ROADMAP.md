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

## v0.4.15 — Outreach Launch Checklist and First Beta Audit Workflow (shipped)
- [x] Create docs/launch/ with 7 internal workflow docs (outreach checklist, beta audit workflow, intake form, delivery template, outreach tracker, feedback form, message pack)
- [x] Define beta audit workflow from qualification to delivery
- [x] Prepare message templates for Discord, forums, and follow-ups
- [ ] First beta audit with real client (if applicable)

## v0.4.16 — First Public Release Page Preparation (shipped)
- [x] Create docs/release/ with 6 release prep docs (GitHub release draft, public launch checklist, announcement copy, asset checklist, feedback tracker, repo review checklist)
- [x] Draft public announcement copy (Discord, forums, Reddit, LinkedIn, GitHub)
- [x] Create GitHub release page template for v0.4.9
- [x] Create public repo review checklist for final pre-publication review

## v0.4.17 — Beta Audit Reporting Template Polish (shipped)
- [x] Create structured beta audit report template with executive summary, per-server findings, and recommendations
- [x] Create 5-level severity guide (Critical, High, Medium, Low, Informational)
- [x] Create common findings library with 13 reusable finding blocks
- [x] Create recommendation style guide (no blame, no exaggeration, factual tone)
- [x] Create fictional sample report with one healthy and one failing server
- [x] Create pre-delivery internal review checklist
- [x] Create polished delivery message template

## v0.4.18 — Public README Quick-Start Polish (shipped)
- [x] Restructure README top-level section ordering
- [x] Add "Try it in 5 minutes" section with git clone, validate, scan, HTML export
- [x] Add "Use it with real servers" 4-step config/setup workflow
- [x] Add "Outputs" summary table (JSON report, HTML report, Discord alert)
- [x] Move Demo, Screenshots, Commercial audit, Safety up to top area
- [x] Move "Who it is for" and "Requirements" to deeper section area
- [x] Update CHANGELOG, TASKS, ROADMAP, PROJECTMAP

## v0.4.19 — Client Package Final Sanity Review (shipped)
- [x] Create `docs/QUICK_START.md` — standalone quick-start guide (5 steps: requirements, clone, validate, scan, HTML export, scheduled task)
- [x] Create `docs/qa/` with 3 internal QA review docs:
  - `PUBLIC_REPO_REVIEW_CHECKLIST.md` — pre-publication repo review (53 files, docs/qa/ exclusion)
  - `RELEASE_CHECKLIST.md` — release checklist updated for v0.4.19
  - `RELEASE_ASSET_CHECKLIST.md` — release asset checklist updated for v0.4.19
- [x] Update client tool package to 53 files (added `docs/QUICK_START.md`)
- [x] Update release checklists with 53-file count and v0.4.19 references
- [x] Update README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG

## v0.4.20 — Prepare v0.5 Dashboard Planning Brief (shipped)
- [x] Create `docs/dashboard/` with 7 internal dashboard planning docs:
  - `V0_5_DASHBOARD_PLANNING_BRIEF.md` — purpose, scope, risks, build order
  - `DASHBOARD_MVP_REQUIREMENTS.md` — granular MVP requirements checklist
  - `DASHBOARD_DATA_MODEL.md` — expected JSON report fields with optional handling
  - `DASHBOARD_UI_WIREFRAME.md` — ASCII layout wireframe (header, summary cards, filters, server cards, footer)
  - `DASHBOARD_SECURITY_NOTES.md` — no secrets, local-only, no telemetry, no CDN
  - `DASHBOARD_IMPLEMENTATION_OPTIONS.md` — 4 approaches compared, recommends extending existing HTML export
  - `DASHBOARD_TEST_PLAN.md` — 12 manual validation scenarios
- [x] Update README with "v0.5 dashboard planning" section linking to 3 key docs
- [x] Update PROJECTMAP, TASKS, ROADMAP, CHANGELOG

## v0.5.0 — Local HTML Dashboard MVP (shipped)
- [x] Create scripts/export_questops_dashboard.ps1 — local HTML dashboard exporter with inline CSS
- [x] Read latest JSON report + optional history reports
- [x] Generate summary cards (total servers, passed, failed, failed servers, history loaded)
- [x] Generate latest server table with per-check PASS/FAIL badges
- [x] Generate failed server detail section with per-category explanations
- [x] Generate history summary (last N report timestamps with status)
- [x] Generate trend summary (PASS/FAIL counts, most recent failure timestamp)
- [x] Handle malformed history files gracefully (skip, warn, exit 5)
- [x] Redact Discord webhook URL patterns in rendered values
- [x] HTML-encode all string values
- [x] Exit codes: 0/2/3/4/5
- [x] Create docs/DASHBOARD_GUIDE.md — generation, data sources, security, troubleshooting
- [x] Create docs/demo/SAMPLE_DASHBOARD_PREVIEW.md — fictional ASCII layout preview
- [x] Update client package to include dashboard script and docs (56 files)

## v0.5.1 — Dashboard Visual Polish and Status Filters (shipped)
- [x] Visual polish: improved spacing, hierarchy, summary cards, PASS/FAIL badges, section separation
- [x] CSS-only radio tab status filters (All Servers / Passing / Failing) without JavaScript
- [x] Responsive layout (overflow-x table scroll, smaller screens)
- [x] Print layout refinements (hidden controls, page-break avoidance, black/white contrast)
- [x] Empty-state messages for filters with no results
- [x] Updated dashboard docs and project docs

## v0.5.2 — Dashboard History Trend Polish (shipped)
- [x] Added 6 trend helper functions: Get-QuestTrendSummary, Get-QuestStatusStreak, Get-QuestFailureCategoryCounts, Get-QuestServerFailureCounts, Format-QuestTimelineItems, Format-QuestFailureInsightRows
- [x] Enhanced trend section with 3 cards: Pass/Fail Summary (counts, rates, failures by category), Streak & Timeline (current streak, longest streak, timeline pills for last 20 scans), Repeated Failure Insights (top 5 most-failing servers)
- [x] Built normalized timeline with deduplication by scan_timestamp_utc
- [x] Updated DASHBOARD_GUIDE.md, SAMPLE_DASHBOARD_PREVIEW.md, README.md, PROJECTMAP.md, ROADMAP.md, CHANGELOG.md, TASKS.md
- [x] Package count unchanged (56 files), VERSION unchanged (0.4.9)

## v0.5.3 — Dashboard Error State Polish (shipped)
- [x] Safe error pages for missing (exit 2) and malformed (exit 3) reports
- [x] Report shape validation with inferred defaults for missing fields
- [x] Per-server missing optional field warnings (non-fatal)
- [x] Consolidated warning box showing history + shape + field warnings
- [x] 8 new helper functions: Get-QuestSafeProperty, Get-QuestSafeBoolean, Get-QuestSafeArray, Get-QuestDashboardTimestamp, Test-QuestDashboardReportShape, Get-QuestDashboardReportWarnings, Format-QuestDashboardWarningBox, Write-QuestDashboardErrorPage
- [x] Updated docs (DASHBOARD_GUIDE, SAMPLE_DASHBOARD_PREVIEW, README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG)
- [x] Package count unchanged (56 files), VERSION unchanged (0.4.9)

## v0.5.4 — Dashboard release readiness and screenshot pass (shipped)
- [x] Created DASHBOARD_RELEASE_READINESS_CHECKLIST.md — QA checklist for scope, scenarios, security, package, browser, and screenshot readiness
- [x] Created DASHBOARD_SCREENSHOT_PASS.md — 10-dashboard-screenshot capture plan with safe data conventions, naming, and redaction
- [x] Created DASHBOARD_FINAL_VALIDATION_COMMANDS.md — one-page copy/paste validation command reference
- [x] Updated README, DASHBOARD_GUIDE, docs/assets/README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG
- [x] Package count unchanged (56 files), VERSION unchanged (0.4.9)

## v0.5.5 — Dashboard release candidate package review (shipped)
- [x] Created DASHBOARD_RELEASE_CANDIDATE_REVIEW.md — release candidate checklist with scope, validation scenarios, package review, GitHub readiness, release decision
- [x] Created DASHBOARD_RC_PACKAGE_CONTENTS.md — expected 56 files, included/excluded categories, inspect commands
- [x] Created DASHBOARD_RC_SIGNOFF_NOTES.md — review date, reviewer, pass/fail, known limitations, next decision
- [x] Updated README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG
- [x] Package count unchanged (56 files), VERSION unchanged (0.4.9)

## v0.5.6 — Dashboard release notes preparation (upcoming)
