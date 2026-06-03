# QuestOps Watchdog — Screenshot Assets

Committed screenshot images for documentation and README.

## Safety rules

- All images use safe demo data (default `servers.example.json` config) only
- No real webhook URLs, IP addresses, server names, or usernames
- All images reviewed per [SCREENSHOT_REVIEW_CHECKLIST.md](../SCREENSHOT_REVIEW_CHECKLIST.md)
- Redactions applied per [SCREENSHOT_REDACTION_GUIDE.md](../SCREENSHOT_REDACTION_GUIDE.md)

## Naming convention

`questops-v{version}-{feature}.png`

Examples:
- `questops-v0.5.0-dashboard-overview.png`
- `questops-v0.5.0-trend-summary.png`

## Included screenshots

*(No screenshots captured yet. See [docs/assets/SCREENSHOT_CAPTURE_PLAN_v0.5.0.md](../SCREENSHOT_CAPTURE_PLAN_v0.5.0.md) for the capture plan.)*

## Package note

Screenshots in this folder are not included in the client tool package unless `scripts/export_questops_audit_package.ps1` is intentionally changed later. The package uses a whitelist — only files explicitly listed are included.
