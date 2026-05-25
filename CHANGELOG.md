# QuestOps Watchdog — Changelog

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
