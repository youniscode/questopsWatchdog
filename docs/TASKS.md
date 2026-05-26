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
| Done   | v0.4.10 - Public GitHub polish and issue templates |
| Done   | - Create .github/ISSUE_TEMPLATE/bug_report.md |
| Done   | - Create .github/ISSUE_TEMPLATE/feature_request.md |
| Done   | - Create .github/pull_request_template.md |
| Done   | - Create SECURITY.md, CONTRIBUTING.md, LICENSE-NOTE.md |
| Done   | - Update README with GitHub-friendly intro and links |
| Done   | - Update PROJECTMAP, TASKS, ROADMAP, CHANGELOG |
| Done   | v0.4.11 - Sample screenshots and demo assets |
| Done   | - Create docs/demo/SAMPLE_HEALTH_REPORT_JSON.md |
| Done   | - Create docs/demo/SAMPLE_HTML_REPORT_PREVIEW.md |
| Done   | - Create docs/demo/SAMPLE_DISCORD_ALERT.md |
| Done   | - Create docs/demo/SAMPLE_AUDIT_RESULTS_MANIFEST.md |
| Done   | - Create docs/demo/SAMPLE_CLIENT_BEFORE_AFTER.md |
| Done   | - Create docs/assets/README.md |
| Done   | - Update README with Demo examples section |
| Done   | - Update export script and package count to 37 files |
| Done   | v0.4.12 - Website landing page draft |
| Done   | - Create docs/website/LANDING_PAGE_DRAFT.md |
| Done   | - Create docs/website/HOMEPAGE_WIREFRAME.md |
| Done   | - Create docs/website/WEBSITE_COPY_SNIPPETS.md |
| Done   | - Create docs/website/SEO_NOTES.md |
| Done   | - Update README with Website section |
| Done   | - Update export script and package count to 41 files |
| Done   | v0.4.13 - Real screenshot capture checklist |
| Done   | - Create SCREENSHOT_CAPTURE_CHECKLIST.md — 10 screenshot types with capture workflow |
| Done   | - Create SCREENSHOT_REDACTION_GUIDE.md — redaction rules for webhooks, IPs, paths, names |
| Done   | - Create SCREENSHOT_SHOT_LIST.md — 12 planned screenshots table |
| Done   | - Create SCREENSHOT_DEMO_SCRIPT.md — step-by-step PowerShell demo flow |
| Done   | - Create SCREENSHOT_REVIEW_CHECKLIST.md — pre-publication review checklist |
| Done   | - Update README, docs/assets/README.md with Screenshots section |
| Done   | - Update export script and package count to 46 files |
| Done   | v0.4.14 - Screenshot placeholder references and README layout polish |
| Done   | - Create docs/assets/placeholders/ with 6 placeholder docs |
| Done   | - Add README_HERO_SCREENSHOT_PLACEHOLDER.md, HTML_REPORT_SCREENSHOT_PLACEHOLDER.md |
| Done   | - Add DISCORD_ALERT_SCREENSHOT_PLACEHOLDER.md, POWERSHELL_SCAN_SCREENSHOT_PLACEHOLDER.md |
| Done   | - Add PACKAGE_ZIP_SCREENSHOT_PLACEHOLDER.md, LANDING_PAGE_SCREENSHOT_PLACEHOLDER.md |
| Done   | - Polish README layout (Screenshots near Demo, milestone v0.4.14, placeholders section) |
| Done   | - Update docs/assets/README.md with placeholders section |
| Done   | - Update export script and package count to 52 files |
| Done   | v0.4.15 - Outreach launch checklist and first beta audit workflow |
| Done   | - Create docs/launch/ with 7 internal launch docs |
| Done   | - Create OUTREACH_LAUNCH_CHECKLIST.md — readiness checklist, platform rules, daily limits, success criteria |
| Done   | - Create FIRST_BETA_AUDIT_WORKFLOW.md — end-to-end process from qualifying to delivery |
| Done   | - Create BETA_AUDIT_INTAKE_FORM.md, BETA_AUDIT_DELIVERY_TEMPLATE.md |
| Done   | - Create OUTREACH_TRACKER_TEMPLATE.md, BETA_FEEDBACK_FORM.md, LAUNCH_MESSAGE_PACK.md |
| Done   | - Update README with Launch / beta audit workflow section |
| Done   | - Update PROJECTMAP, TASKS, ROADMAP, CHANGELOG (VERSION unchanged) |

| Done   | v0.4.16 - First public release page preparation |
| Done   | - Create docs/release/ with 6 release prep docs |
| Done   | - Create GITHUB_RELEASE_DRAFT_v0.4.9.md — ready-to-paste GitHub release page for v0.4.9 |
| Done   | - Create PUBLIC_LAUNCH_CHECKLIST.md — repo readiness, security, package, screenshots, release page, where/where not to share, first-week monitoring |
| Done   | - Create PUBLIC_ANNOUNCEMENT_COPY.md — 8 message templates (Discord, forums, Reddit, LinkedIn, GitHub, beta audit ask, soft CTA, follow-up) |
| Done   | - Create RELEASE_ASSET_CHECKLIST.md — required/optional assets, checksum verification, exclusion rules |
| Done   | - Create FIRST_WEEK_FEEDBACK_TRACKER.md — markdown table for feedback with types, priorities, statuses |
| Done   | - Create PUBLIC_REPO_REVIEW_CHECKLIST.md — README, docs links, issue templates, security, license, package count, screenshots, roadmap, commercial wording, final safe-to-share review |
| Done   | - Update README with Public release preparation section |
| Done   | - Update PROJECTMAP, TASKS, ROADMAP, CHANGELOG (VERSION unchanged) |

| Done   | v0.4.17 - Beta audit reporting template polish |
| Done   | - Create docs/audit/ with 7 internal audit report docs |
| Done   | - Create BETA_AUDIT_REPORT_TEMPLATE.md — structured report template |
| Done   | - Create FINDINGS_SEVERITY_GUIDE.md — 5-level severity definitions |
| Done   | - Create COMMON_FINDINGS_LIBRARY.md — 13 reusable finding blocks |
| Done   | - Create RECOMMENDATION_STYLE_GUIDE.md — writing conventions |
| Done   | - Create BETA_AUDIT_REPORT_SAMPLE.md — fictional report example |
| Done   | - Create BETA_AUDIT_INTERNAL_REVIEW_CHECKLIST.md — pre-delivery checklist |
| Done   | - Create BETA_AUDIT_DELIVERY_MESSAGE_POLISHED.md — refined delivery message |
| Done   | - Update README with Beta audit reporting section |
| Done   | - Update PROJECTMAP, TASKS, ROADMAP, CHANGELOG (VERSION unchanged) |

| Done   | v0.4.18 - Public README quick-start polish |
| Done   | - Restructure README top-level section ordering |
| Done   | - Add "Try it in 5 minutes" with git clone + HTML export |
| Done   | - Add "Use it with real servers" 4-step workflow |
| Done   | - Add "Outputs" summary table |
| Done   | - Move Demo/Screenshots/Commercial/Safety up to top area |
| Done   | - Move "Who it is for" and "Requirements" to deeper section area |
| Done   | - Update CHANGELOG, TASKS, ROADMAP, PROJECTMAP |

| Done   | v0.4.19 - Client package final sanity review |
| Done   | - Create docs/QUICK_START.md (5-step standalone quick-start guide) |
| Done   | - Create docs/qa/ with 3 internal QA review docs (PUBLIC_REPO_REVIEW_CHECKLIST, RELEASE_CHECKLIST, RELEASE_ASSET_CHECKLIST) |
| Done   | - Update client tool package to 53 files |
| Done   | - Update README, PROJECTMAP, TASKS, ROADMAP, CHANGELOG |
| Done   | - Update release checklists with 53-file count and v0.4.19 references |

| Done   | v0.4.20 - Prepare v0.5 dashboard planning brief |
| Done   | - Create docs/dashboard/ with 7 internal dashboard planning docs |
| Done   | - Create V0_5_DASHBOARD_PLANNING_BRIEF.md (purpose, scope, risks, build order) |
| Done   | - Create DASHBOARD_MVP_REQUIREMENTS.md (granular MVP checklist) |
| Done   | - Create DASHBOARD_DATA_MODEL.md (expected JSON report fields with optional handling) |
| Done   | - Create DASHBOARD_UI_WIREFRAME.md (ASCII layout wireframe) |
| Done   | - Create DASHBOARD_SECURITY_NOTES.md (no secrets, local-only, no telemetry, no CDN) |
| Done   | - Create DASHBOARD_IMPLEMENTATION_OPTIONS.md (4 approaches, recommend extending HTML export) |
| Done   | - Create DASHBOARD_TEST_PLAN.md (12 manual validation scenarios) |
| Done   | - Update README with v0.5 dashboard planning section |
| Done   | - Update PROJECTMAP, TASKS, ROADMAP, CHANGELOG |

## Upcoming

- v0.5.0 - HTML dashboard MVP implementation plan
- v0.5 - HTML dashboard
