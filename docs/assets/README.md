# QuestOps Watchdog — Assets

This folder contains screenshots, images, and media assets used in documentation and marketing.

## Naming convention

| Pattern | Example | Purpose |
|---------|---------|---------|
| `screenshot-{feature}-{version}.png` | `screenshot-html-report-v0.4.9.png` | Feature screenshots |
| `diagram-{description}.png` | `diagram-architecture-overview.png` | Architecture or workflow diagrams |
| `demo-{description}.gif` | `demo-scan-to-alert.gif` | Animated demos (if added later) |
| `social-preview.png` | `social-preview.png` | GitHub social preview (repo card image) |

## Rules

1. **No real webhook URLs** — any screenshots showing Discord alerts must use fictional webhook URLs or have them redacted.
2. **No real client names** — blur or replace any identifiable client/server names in screenshots.
3. **Redact IPs if public** — if a screenshot contains an IP address, redact or replace it with a placeholder (e.g. `127.0.0.1` or `192.0.2.x`).
4. **No private Discord messages** — do not include Discord chat messages from private servers or DMs without explicit consent.
5. **No real logs with usernames** — redact or replace any usernames, player names, or other identifiers in log excerpts.

## Screenshot documentation

- [Capture checklist](SCREENSHOT_CAPTURE_CHECKLIST.md) — 10 screenshot types and capture workflow
- [Redaction guide](SCREENSHOT_REDACTION_GUIDE.md) — what to redact and how (webhooks, IPs, paths, names)
- [Shot list](SCREENSHOT_SHOT_LIST.md) — 12 planned screenshots with priorities
- [Demo script](SCREENSHOT_DEMO_SCRIPT.md) — step-by-step PowerShell commands for each capture
- [Review checklist](SCREENSHOT_REVIEW_CHECKLIST.md) — pre-publication review checklist

## Screenshot placeholders

Placeholder documents that describe future screenshots. No actual images here yet — these are planning references for what each screenshot should show and what data it must avoid.

- [README hero screenshot placeholder](placeholders/README_HERO_SCREENSHOT_PLACEHOLDER.md)
- [HTML report screenshot placeholder](placeholders/HTML_REPORT_SCREENSHOT_PLACEHOLDER.md)
- [Discord alert screenshot placeholder](placeholders/DISCORD_ALERT_SCREENSHOT_PLACEHOLDER.md)
- [PowerShell scan screenshot placeholder](placeholders/POWERSHELL_SCAN_SCREENSHOT_PLACEHOLDER.md)
- [Package zip screenshot placeholder](placeholders/PACKAGE_ZIP_SCREENSHOT_PLACEHOLDER.md)
- [Landing page screenshot placeholder](placeholders/LANDING_PAGE_SCREENSHOT_PLACEHOLDER.md)

Placeholders are documentation-only. They describe intended screenshots but do not contain or reference any actual images. The naming convention and redaction rules above apply to all future screenshots.

## Current contents

*(No image assets yet — only planning, reference, and placeholder documents.)*
