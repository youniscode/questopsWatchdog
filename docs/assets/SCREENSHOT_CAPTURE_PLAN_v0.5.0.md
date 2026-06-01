# QuestOps Watchdog — Screenshot Capture Plan (v0.5.0)

Focused screenshot capture plan for the official **v0.5.0 Local Dashboard Release**.

## Goal

Capture and commit safe, redacted screenshots for the README and GitHub release page. Focus on the local dashboard feature (new in v0.5.0) plus existing core features.

## Safety rules

- No real webhook URLs — redact or replace with `https://discord.com/api/webhooks/demo/demo`
- No real IP addresses — use `192.0.2.x` (RFC 5737 documentation prefix)
- No real server/client names — use fictional demo names (e.g. "Demo Project Zomboid", "Demo Minecraft")
- No real file paths with user components — use `C:\GameServers\Demo\...`
- No real Windows usernames — use `Admin`
- Verify every image at 100% zoom before committing

## Naming convention

`screenshot-{feature}-v0.5.0.png`

Examples:
- `screenshot-dashboard-overview-v0.5.0.png`
- `screenshot-scan-healthy-v0.5.0.png`

## Recommended first shots

| # | Feature | What to show | Priority |
|---|---------|-------------|----------|
| 1 | Dashboard overview | Full dashboard with summary cards, server table, filters | P1 |
| 2 | Dashboard filters | Dashboard with "Failing" filter active, showing only failing servers | P1 |
| 3 | Dashboard trend section | Dashboard scrolled to trend cards (pass/fail, streak, timeline) | P1 |
| 4 | Healthy scan output | Console: all servers PASS | P1 |
| 5 | Mixed scan output | Console: some PASS, some FAIL | P1 |
| 6 | TCP failure | Console: unreachable port error | P2 |
| 7 | HTML report | Browser: HTML report with summary cards | P2 |
| 8 | Config file | Editor: `servers.example.json` open | P2 |
| 9 | Help output | Console: `-help` parameter listing | P3 |

## Redaction review workflow

1. Capture the screenshot using Windows + Shift + S (or preferred tool)
2. Open in image editor
3. Apply redactions per [SCREENSHOT_REDACTION_GUIDE.md](SCREENSHOT_REDACTION_GUIDE.md)
4. Save as PNG with correct naming convention
5. Run through [SCREENSHOT_REVIEW_CHECKLIST.md](SCREENSHOT_REVIEW_CHECKLIST.md)
6. Place in `docs/assets/`
7. Update README screenshot links and alt text
8. Commit

## Related docs

- [Capture checklist](SCREENSHOT_CAPTURE_CHECKLIST.md) — full 10-type capture workflow
- [Redaction guide](SCREENSHOT_REDACTION_GUIDE.md) — detailed redaction rules
- [Shot list](SCREENSHOT_SHOT_LIST.md) — 12 planned screenshots with priorities
- [Demo script](SCREENSHOT_DEMO_SCRIPT.md) — step-by-step PowerShell commands
- [Review checklist](SCREENSHOT_REVIEW_CHECKLIST.md) — pre-publication checklist
