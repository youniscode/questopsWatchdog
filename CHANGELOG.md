# QuestOps Watchdog — Changelog

## v0.5.1 — Dashboard Visual Polish and Status Filters (unreleased)

- Improved dashboard visual polish: better spacing, section hierarchy, summary cards, PASS/FAIL badges, failed-row styling, table readability, empty-state messages, warning box styling, system fonts
- Added CSS-only radio tab status filters (All Servers / Passing / Failing) with server counts — no JavaScript
- Added empty-state messages when a filter has no matching servers
- Added responsive layout: overflow-x table scroll, compact cards on smaller screens
- Added print layout refinements: hidden filter controls, page-break avoidance, black/white contrast
- Updated DASHBOARD_GUIDE.md, SAMPLE_DASHBOARD_PREVIEW.md, README.md, PROJECTMAP.md, TASKS.md, ROADMAP.md, CHANGELOG.md
- Package count unchanged (56 files)
- VERSION unchanged (0.4.9)

## v0.5.0 — Local HTML Dashboard MVP (unreleased)

- Created `scripts/export_questops_dashboard.ps1` — local static HTML dashboard exporter
  - Reads `reports/latest-health-report.json` (required) and `reports/history/` (optional)
  - Generates summary cards, latest server table, failed server details, history summary, trend summary
  - Inline CSS only, no JavaScript, no external dependencies
  - Handles malformed history files gracefully (skip, warn, exit 5)
  - Redacts Discord webhook URLs, HTML-encodes all string values
  - Exit codes 0/2/3/4/5
- Created `docs/DASHBOARD_GUIDE.md` — dashboard user guide with generation, security, and troubleshooting
- Created `docs/demo/SAMPLE_DASHBOARD_PREVIEW.md` — fictional ASCII preview of dashboard layout
- Updated README with "Local dashboard" section
- Updated tool package to 56 files (added dashboard script + 2 docs)
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG, CLIENT_HANDOFF_CHECKLIST, RELEASE_CHECKLIST
- VERSION unchanged (0.4.9)

## v0.4.20 — Prepare v0.5 dashboard planning brief (unreleased)

- Created `docs/dashboard/` with 7 internal dashboard planning docs:
  - `V0_5_DASHBOARD_PLANNING_BRIEF.md` — purpose, scope, risks, build order
  - `DASHBOARD_MVP_REQUIREMENTS.md` — granular MVP checklist
  - `DASHBOARD_DATA_MODEL.md` — expected JSON report fields with optional handling
  - `DASHBOARD_UI_WIREFRAME.md` — ASCII layout wireframe
  - `DASHBOARD_SECURITY_NOTES.md` — no secrets, local-only, no telemetry, no CDN
  - `DASHBOARD_IMPLEMENTATION_OPTIONS.md` — compares 4 approaches, recommends extending existing HTML export
  - `DASHBOARD_TEST_PLAN.md` — 12 manual validation scenarios
- Updated README with "v0.5 dashboard planning" section linking to 3 key dashboard docs
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG
- VERSION unchanged (0.4.9) — `docs/dashboard/` excluded from export script (internal planning only)

## v0.4.19 — Client package final sanity review (unreleased)

- Created `docs/QUICK_START.md` — standalone quick-start guide with 5 steps from clone to scheduled task
- Created `docs/qa/` with 3 internal QA review docs:
  - `PUBLIC_REPO_REVIEW_CHECKLIST.md` — pre-publication repo review checklist (53 files, docs/qa/ exclusion)
  - `RELEASE_CHECKLIST.md` — internal release checklist updated for v0.4.19
  - `RELEASE_ASSET_CHECKLIST.md` — release asset checklist updated for v0.4.19
- Updated client tool package to 53 files (added `docs/QUICK_START.md`)
- Updated `docs/RELEASE_CHECKLIST.md` and `docs/release/RELEASE_ASSET_CHECKLIST.md` with 53-file count and v0.4.19 references
- Updated README "What is included" count from 52 to 53 files
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG
- VERSION unchanged (0.4.9)

## v0.4.18 — Public README quick-start polish (unreleased)

- Restructured README top-level flow: Current status → Try it in 5 minutes (with git clone) → Use it with real servers → What it checks → Outputs → Demo examples → Screenshots → Commercial audit offer → Safety/security notes → deeper technical sections
- Added "Try it in 5 minutes" section with git clone, validate, scan, and HTML export commands
- Added "Use it with real servers" section with 4-step config/setup workflow
- Added "Outputs" section summarizing JSON report, HTML report, and Discord alert
- Moved "Demo examples" (with Screenshots), "Commercial audit offer", and "Safety / security notes" to top area
- Moved "Who it is for" and "Requirements" to the deeper technical section area
- Updated current milestone and roadmap table in README
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG
- VERSION unchanged (0.4.9)

## v0.4.17 — Beta audit reporting template polish (unreleased)

- Created `docs/audit/` with 7 internal audit reporting docs:
  - `BETA_AUDIT_REPORT_TEMPLATE.md` — structured report template with executive summary, per-server findings, and recommendations
  - `FINDINGS_SEVERITY_GUIDE.md` — 5-level severity definitions (Critical, High, Medium, Low, Informational)
  - `COMMON_FINDINGS_LIBRARY.md` — 13 reusable finding blocks with symptom, impact, fix, severity, and client-friendly wording
  - `RECOMMENDATION_STYLE_GUIDE.md` — writing conventions: no blame, no exaggeration, factual tone
  - `BETA_AUDIT_REPORT_SAMPLE.md` — fictional report with one healthy and one failing server
  - `BETA_AUDIT_INTERNAL_REVIEW_CHECKLIST.md` — pre-delivery quality review checklist
  - `BETA_AUDIT_DELIVERY_MESSAGE_POLISHED.md` — refined delivery message template
- Updated README with "Beta audit reporting" section linking to 3 key audit docs
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG
- VERSION unchanged (0.4.9) — `docs/audit/` excluded from export script (internal-only)

## v0.4.16 — First public release page preparation (unreleased)

- Created `docs/release/` with 6 internal release preparation docs:
  - `GITHUB_RELEASE_DRAFT_v0.4.9.md` — ready-to-paste GitHub Release page for v0.4.9
  - `PUBLIC_LAUNCH_CHECKLIST.md` — repo readiness, security, package export, screenshots, where/where not to share, first-week monitoring
  - `PUBLIC_ANNOUNCEMENT_COPY.md` — 8 message templates (Discord, community forum, Reddit, LinkedIn, GitHub description, beta audit ask, soft CTA, follow-up)
  - `RELEASE_ASSET_CHECKLIST.md` — required/optional assets, checksum verification, exclusion rules
  - `FIRST_WEEK_FEEDBACK_TRACKER.md` — markdown table template with feedback types, priorities, and statuses
  - `PUBLIC_REPO_REVIEW_CHECKLIST.md` — final pre-publication review of README, docs links, templates, security, license, package, screenshots, roadmap, commercial wording
- Updated README with "Public release preparation" section linking to all 6 release docs
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG
- VERSION unchanged (0.4.9) — `docs/release/` excluded from export script (internal-only)

## v0.4.15 — Outreach launch checklist and first beta audit workflow (unreleased)

- Created `docs/launch/` with 7 internal workflow docs:
  - `OUTREACH_LAUNCH_CHECKLIST.md` — readiness checklist with platform rules, daily limits, success criteria
  - `FIRST_BETA_AUDIT_WORKFLOW.md` — end-to-end process from qualifying server owners to delivering results
  - `BETA_AUDIT_INTAKE_FORM.md` — copy/paste intake form for gathering server details
  - `BETA_AUDIT_DELIVERY_TEMPLATE.md` — structured delivery message for audit findings
  - `OUTREACH_TRACKER_TEMPLATE.md` — markdown table for manual outreach tracking
  - `BETA_FEEDBACK_FORM.md` — copy/paste form for collecting beta feedback
  - `LAUNCH_MESSAGE_PACK.md` — refined message templates for Discord, forums, follow-ups
- Updated README with "Launch / beta audit workflow" section linking to all 7 docs
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG
- VERSION unchanged (0.4.9) — `docs/launch/` excluded from export script (internal-only)

## v0.4.14 — Screenshot placeholder references and README layout polish (unreleased)

- Added `docs/assets/placeholders/` folder with 6 placeholder docs:
  - `README_HERO_SCREENSHOT_PLACEHOLDER.md` — intended hero image for GitHub README
  - `HTML_REPORT_SCREENSHOT_PLACEHOLDER.md` — future HTML report screenshot
  - `DISCORD_ALERT_SCREENSHOT_PLACEHOLDER.md` — future Discord alert screenshot
  - `POWERSHELL_SCAN_SCREENSHOT_PLACEHOLDER.md` — future PowerShell scan screenshot
  - `PACKAGE_ZIP_SCREENSHOT_PLACEHOLDER.md` — future package zip screenshot
  - `LANDING_PAGE_SCREENSHOT_PLACEHOLDER.md` — future landing page mockup
- Updated `docs/assets/README.md` with "Screenshot placeholders" section linking to all placeholder docs
- Polished README layout — moved Screenshots subsection near Demo examples, updated milestone to v0.4.14, added placeholder references, updated package count to 52
- Updated tool package to 52 files (includes 6 placeholder docs)
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG, CLIENT_HANDOFF_CHECKLIST, RELEASE_CHECKLIST

## v0.4.13 — Real screenshot capture checklist (unreleased)

- Added `docs/assets/SCREENSHOT_CAPTURE_CHECKLIST.md` — 10 screenshot types with scenario, visual elements, redaction notes, and capture workflow
- Added `docs/assets/SCREENSHOT_REDACTION_GUIDE.md` — redaction rules for file paths, Discord webhook URLs, JSON configs, PowerShell terminal output, usernames, IPs, and timestamps
- Added `docs/assets/SCREENSHOT_SHOT_LIST.md` — 12 planned screenshots table with IDs, descriptions, priorities (P1-P3), and naming convention
- Added `docs/assets/SCREENSHOT_DEMO_SCRIPT.md` — step-by-step PowerShell demo flow for each of the 12 planned screenshots, from setup through capture
- Added `docs/assets/SCREENSHOT_REVIEW_CHECKLIST.md` — pre-publication review checklist covering content, redaction, technical, legal, and sign-off
- Updated `docs/assets/README.md` with links to all new screenshot docs
- Updated README with "Screenshots" section linking to all screenshot docs
- Updated tool package to 46 files (includes 5 screenshot docs)
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG, CLIENT_HANDOFF_CHECKLIST, RELEASE_CHECKLIST

## v0.4.12 — Website landing page draft (unreleased)

- Added `docs/website/LANDING_PAGE_DRAFT.md` — complete landing page draft with hero, problem, solution, who it's for, what it checks, how it works, paid audit tiers, demo links, security/privacy, FAQ, and final CTA
- Added `docs/website/HOMEPAGE_WIREFRAME.md` — ASCII wireframe of the homepage layout (nav, hero, trust strip, feature cards, demo preview, pricing cards, how it works timeline, FAQ, footer)
- Added `docs/website/WEBSITE_COPY_SNIPPETS.md` — reusable copy snippets: 5 alternative hero headlines, 5 subheadlines, 5 CTAs, 5 social posts, 5 repo descriptions, 5 audit descriptions, 5 FAQ answer variants
- Added `docs/website/SEO_NOTES.md` — SEO guidance with suggested page title, meta description, primary/secondary/long-tail keywords, target audience table, content sections to rank for, phrases to avoid, honest positioning notes, and technical SEO notes
- Updated README with "Website / landing page draft" section linking to all website docs
- Updated tool package to 41 files (includes 4 website docs)
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG, CLIENT_HANDOFF_CHECKLIST, RELEASE_CHECKLIST

## v0.4.11 — Sample screenshots and demo assets (unreleased)

- Added `docs/demo/SAMPLE_HEALTH_REPORT_JSON.md` — fictional health report JSON with one passing server (Demo Project Zomboid) and one failing server (Demo Minecraft), including folder/disk/process/network/log/resource checks
- Added `docs/demo/SAMPLE_HTML_REPORT_PREVIEW.md` — ASCII-style preview of the HTML audit report layout with summary cards, PASS/FAIL badges, per-server sections, and optional check tables
- Added `docs/demo/SAMPLE_DISCORD_ALERT.md` — fictional Discord alert examples for single failure, multiple failures, forced test, and truncated messages
- Added `docs/demo/SAMPLE_AUDIT_RESULTS_MANIFEST.md` — fictional audit-results-manifest.json examples with and without optional config/log
- Added `docs/demo/SAMPLE_CLIENT_BEFORE_AFTER.md` — fictional before/after transformation story showing how QuestOps Watchdog helps a server owner
- Added `docs/assets/README.md` — screenshot naming convention and asset rules (no real webhook URLs, client names, IPs, private messages, or log usernames)
- Updated README with "Demo examples" section linking to all sample docs
- Updated tool package to 37 files (includes 5 demo docs + assets README)
- Updated PROJECTMAP, TASKS, ROADMAP, CHANGELOG, CLIENT_HANDOFF_CHECKLIST, RELEASE_CHECKLIST

## v0.4.10 — Public GitHub polish and issue templates (unreleased)

- Added `.github/ISSUE_TEMPLATE/bug_report.md` — structured bug report template with environment, sanitized report snippet, and security reminder
- Added `.github/ISSUE_TEMPLATE/feature_request.md` — feature request template with problem, solution, game type, and scope preference
- Added `.github/pull_request_template.md` — PR template with validation, PowerShell 5.1 compatibility, docs update, and security checklists
- Added `SECURITY.md` — security policy with supported versions (v0.4.9+), reporting process, secret handling, and no-telemetry statement
- Added `CONTRIBUTING.md` — contribution guidelines with setup, coding rules, validation commands, and PR process
- Added `LICENSE-NOTE.md` — copyright notice with permitted use and commercial restriction; no open-source license yet
- Updated README with GitHub-friendly intro pitch, quick links to security/contributing/audit docs

## v0.4.9 — Paid audit offer kit and landing copy

- Added `docs/business/` folder with 7 business documentation files:
  - `PAID_AUDIT_OFFER.md` — pricing, scope, what's included
  - `LANDING_PAGE_COPY.md` — landing page copy draft
  - `OUTREACH_MESSAGES.md` — message templates for outreach
  - `SAMPLE_CLIENT_PROPOSAL.md` — customizable proposal template
  - `SAMPLE_AUDIT_SUMMARY.md` — fictional audit summary sample
  - `GITHUB_README_POSITIONING.md` — GitHub positioning guidance
  - `PRICING_NOTES.md` — pricing rationale and strategy notes
- Updated README with "Commercial audit offer" section linking to business docs
- Updated client tool package to 31 files (includes 6 business docs — excluding internal-only GITHUB_README_POSITIONING.md)
- Updated PROJECTMAP, TASKS, ROADMAP, CLIENT_HANDOFF_CHECKLIST, RELEASE_CHECKLIST
- VERSION bumped to 0.4.9 for release consistency

## v0.4.8 — Release hygiene and first tagged client build

- Added `VERSION` file with current version number
- Added `CHANGELOG.md` with version history
- Added `docs/RELEASE_NOTES_v0.4.8.md` — client-facing release notes
- Added `docs/RELEASE_CHECKLIST.md` — internal pre-release validation steps
- Added `scripts/build_questops_client_release.ps1` — repeatable release build workflow
- Release build runs config validation, scan, HTML export, package export, results bundle, checksum generation, and writes a release manifest
- Client tool package updated to include `VERSION`, `CHANGELOG.md`, and `RELEASE_NOTES_v0.4.8.md` (25 files total)

## v0.4.7 — Audit results bundle

- Added `scripts/export_questops_audit_results.ps1` — packages scan outputs (JSON report, HTML report, manifest) into a clean zip for client review
- Auto-generates HTML if missing; `-RefreshHtml` and `-NoGenerateHtml` options
- Safety scan for webhook URLs, passwords, tokens, secrets in included files
- Optional `-IncludeConfig` and `-IncludeLog` with safety scan
- Updated tool package to 22 files

## v0.4.6 — HTML audit report export

- Added `scripts/export_questops_html_report.ps1` — standalone HTML exporter with inline CSS
- No JavaScript, no external dependencies, safe for print-to-PDF
- Summary cards, per-server detail tables, optional check detail tables
- Generated HTML is gitignored and excluded from the tool package

## v0.4.5 — Client-ready audit package

- Added `scripts/export_questops_audit_package.ps1` — clean zip with preflight safety scan
- Added `docs/CLIENT_AUDIT_GUIDE.md` and `docs/CLIENT_HANDOFF_CHECKLIST.md`
- Prevents secrets, local configs, reports, logs from being packaged
