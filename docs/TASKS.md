# QuestOps Watchdog - Tasks

## Current

| Status | Task |
|--------|------|
| Done   | Create project scaffold (dirs, docs) |
| Done   | Write `config/servers.example.json` |
| Done   | Write `scripts/questops_scan.ps1` |
| Done   | Validate end-to-end and report back |
| Done   | Harden script - safe config path handling (exit 2) |
| Done   | Harden script - safe JSON reading with try/catch (exit 3) |
| Done   | Harden script - flexible report path (folder or .json) |
| Done   | Harden script - BOM-less UTF-8 JSON output |
| Done   | Harden script - replace Write-Host with Write-Verbose/Warning/Error |
| Done   | Harden script - functions for every check |
| Done   | Harden script - pipeline output of report object |
| Done   | Create and enforce project documentation discipline |
| Done   | - Write comprehensive README.md |
| Done   | - Expand PROJECTMAP.md with architecture, constraints, rules, validation commands |
| Done   | - Add agent workflow rules to both PROJECTMAP.md and README.md |
| Done   | - Update TASKS.md |
| Done   | Task 37 - Add .gitignore and repo hygiene |
| Done   | v0.2 - Discord webhook alerting |
| Done   | v0.2.1 - Integrate scan + alert workflow |
| Done   | v0.3 - Windows Task Scheduler integration |
| Done   | v0.3.1 - Report retention and log file output |
| Done   | v0.4 - Network reachability checks |
| Done   | v0.4.1 - Log staleness checks |
| Done   | v0.4.2 - Process CPU and memory usage |
| Done   | v0.4.3 - Alert message improvements |
| Done   | v0.4.4 - Config validation and safer examples |
| Done   | - Create config/servers.game.example.json (game server template with fake paths) |
| Done   | - Rewrite config/servers.example.json (safe local demo) |
| Done   | - Create scripts/validate_questops_config.ps1 (structure validator) |
| Done   | - Update docs (PROJECTMAP, README, TASKS, ROADMAP) |
| Done   | v0.4.5 - First client-ready audit package |
| Done   | - Create scripts/export_questops_audit_package.ps1 |
| Done   | - Create docs/CLIENT_AUDIT_GUIDE.md |
| Done   | - Create docs/CLIENT_HANDOFF_CHECKLIST.md |
| Done   | - Update README.md with Client-ready audit package section |
| Done   | - Update PROJECTMAP.md with new files, export exit codes, dist/ |
| Done   | - Update TASKS.md and ROADMAP.md |
| Done   | v0.4.6 - HTML audit report export |
| Done   | - Create scripts/export_questops_html_report.ps1 |
| Done   | - Update export script to include new script (21 files) |
| Done   | - Update README with HTML export section |
| Done   | - Update PROJECTMAP, TASKS, ROADMAP, client docs |
| Done   | - Fix architecture diagram indentation in PROJECTMAP.md |
| Done   | v0.4.7 - HTML report package integration polish |
| Done   | - Create scripts/export_questops_audit_results.ps1 |
| Done   | - Add audit results bundle workflow (JSON report, HTML report, manifest) |
| Done   | - Auto-generate HTML if missing; -RefreshHtml and -NoGenerateHtml options |
| Done   | - Safety scan: discord/webhooks, webhook URL, password/token/secret patterns |
| Done   | - Optional config (-IncludeConfig) and log (-IncludeLog) with safety scan |
| Done   | - Output: dist\questops-watchdog-audit-results-YYYYMMDD-HHMMSS.zip |
| Done   | - Generate audit-results-manifest.json inside zip (no disk write) |
| Done   | - Update export_questops_audit_package.ps1 to include new script (22 files) |
| Done   | - Update all docs (README, PROJECTMAP, CLIENT docs, TASKS, ROADMAP) |
| Done   | v0.4.8 - Release hygiene and first tagged client build |
| Done   | - Create VERSION file, CHANGELOG.md, docs/RELEASE_NOTES_v0.4.8.md |
| Done   | - Create docs/RELEASE_CHECKLIST.md (internal pre-release checklist) |
| Done   | - Create scripts/build_questops_client_release.ps1 (release build orchestrator) |
| Done   | - Build script: config validation, scan, HTML export, package export, results export, checksums, manifest |
| Done   | - Git status check: fail on dirty unless -AllowDirty |
| Done   | - Update export_questops_audit_package.ps1 to include VERSION, CHANGELOG, RELEASE_NOTES (25 files) |
| Done   | - Update all docs (README, PROJECTMAP, CLIENT docs, TASKS, ROADMAP) |
| Done   | v0.4.9 - Paid audit offer kit and landing copy |
| Done   | - Create docs/business/ with PAID_AUDIT_OFFER.md, LANDING_PAGE_COPY.md, OUTREACH_MESSAGES.md |
| Done   | - Create SAMPLE_CLIENT_PROPOSAL.md, SAMPLE_AUDIT_SUMMARY.md, GITHUB_README_POSITIONING.md, PRICING_NOTES.md |
| Done   | - Update export_questops_audit_package.ps1 to include business docs (31 files) |
| Done   | - Update README with Commercial audit offer section |
| Done   | - Update PROJECTMAP, TASKS, ROADMAP, CHANGELOG, CLIENT_HANDOFF_CHECKLIST, RELEASE_CHECKLIST |

## Upcoming

- v0.4.10 - Public GitHub polish and issue templates
- v0.5 - HTML dashboard
