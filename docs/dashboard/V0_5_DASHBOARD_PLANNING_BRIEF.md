# QuestOps Watchdog — v0.5 Dashboard Planning Brief

## Purpose

Provide a local, browser-based HTML dashboard that displays health scan results in a readable, filterable layout — improving on the current single-report HTML export by adding multi-report awareness, server status cards, and pass/fail filtering.

The dashboard is a **planning-only placeholder** until v0.5 development begins. No dashboard code exists yet.

## Why it comes after the current audit package workflow

The current v0.4.x line focuses on:
- A reliable CLI-based scan tool
- Safe client-ready packages
- Internal QA and release hygiene
- Commercial audit preparation

The dashboard is the next natural step because:
- The data model (JSON health report) is stable
- The HTML report export proves the rendering approach works
- Users want a quick visual overview without running multiple commands
- Paid audit clients benefit from a cleaner results presentation

## What problem it solves

- Opening a JSON file is not user-friendly
- The current HTML export is single-report only
- No easy way to glance at overall health across servers
- No filtering by pass/fail status
- No visual server cards showing status at a glance

## Who it is for

- Server operators who want a quick health overview
- Paid audit clients receiving results
- The maintainer for demo and marketing purposes

## What data it should read

- `reports/latest-health-report.json` — the most recent scan result
- Optionally `reports/history/*.json` — historical reports for trend awareness (v0.5+, not MVP)

## What it should not do

- No edit or modify scan config
- No trigger or schedule scans
- No send alerts
- No expose secrets (webhooks, passwords, tokens)
- No write to disk except its own generated HTML
- No network requests
- No telemetry
- No user accounts or login

## MVP definition

A standalone HTML file (generated from PowerShell or opened directly from a static file) that:
- Loads `reports/latest-health-report.json`
- Displays overall pass/fail status
- Shows per-server cards with key check results
- Highlights failed checks
- Shows network, log, and resource check details
- Shows scan timestamp
- Filters by pass/fail
- Prints cleanly to PDF
- Works offline, no CDN

## Non-goals

- Live auto-refresh — the dashboard is a snapshot viewer, not a monitoring panel
- Historical trends — charting reports over time is post-v0.5
- Multi-user — local-only single user
- Mobile-responsive — primarily desktop/print use
- Dark/light mode toggle — not in MVP
- Interactive charts — static visual indicators are sufficient for v0.5

## Success criteria

- Opens in any modern browser from the filesystem
- Displays correct pass/fail from a real or demo report
- Filtering works without page reload (CSS-only or minimal JS)
- Print-to-PDF produces a clean, readable document
- Handles missing or malformed report gracefully
- No secrets or sensitive data visible

## Risks

- HTML file size may grow with many servers — should test with 10+ servers
- Browser CORS policies may block local file reads if JS is used — mitigated by using a pre-generated static HTML or a local-file-friendly approach
- Paths in the report (e.g. `C:\GameServers\...`) are informational only — must not be treated as actionable links
- Users may expect live updates — must be clearly documented as a snapshot viewer

## Suggested build order

1. **Extend the existing HTML export script** to produce a dashboard-like layout (summary cards, server cards, filtering)
2. **Add pass/fail filter** as a toggle (CSS-only or minimal vanilla JS)
3. **Add print styles** for clean PDF output
4. **Add graceful error handling** for missing/malformed JSON
5. **Test with real and edge-case reports**
6. **Document** as v0.5 release
