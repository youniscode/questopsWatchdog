# QuestOps Watchdog — Changelog

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
