# HTML Report Screenshot — Placeholder

## Intended image name

`screenshot-html-report-v0.4.14.png`

## Purpose

Show what the generated HTML audit report looks like in a browser. Used in documentation and the landing page.

## What the screenshot should show

A browser window (viewport only, no browser chrome) displaying the generated HTML report:

- Summary cards at the top: Total servers, Passed (green card), Failed (red card)
- One PASS server section with green badge and ✓ indicators
- One FAIL server section with red badge and ✗ indicators
- Detail lines for failed optional checks
- Clean inline CSS styling

## Data requirements

- Must show fictional/safe report data only
- Server names: `Demo Project Zomboid`, `Demo Minecraft` only
- IPs: `127.0.0.1` or `192.0.2.x` only
- All metrics must be fictional and within reasonable ranges
- Must not show real server paths, usernames, IPs, logs, or client data

## Suggested crop area

Browser viewport showing the full report from the title bar down to the last server section. Do not include browser tabs, bookmarks bar, or desktop background.

## Suggested alt text

"QuestOps Watchdog HTML audit report showing summary cards with 2 servers, 1 passed, 1 failed, and per-server PASS/FAIL sections with check details."
