# QuestOps Watchdog — Dashboard Security Notes

## No secrets in the dashboard

- The dashboard reads only the JSON health report.
- The health report contains server metadata (paths, names, process names) — not secrets.
- Webhook URLs, passwords, tokens, and environment variables are never written to the report.
- The dashboard must never display `$env:*` values or webhook URLs.

## No webhook display

- The dashboard shows scan results only.
- Discord webhook configuration is not part of the report and must never appear.

## Local file access only

- The dashboard reads `reports/latest-health-report.json` from the local filesystem.
- No network requests are made.
- No remote data sources are accessed.
- The dashboard works fully offline.

## No remote upload

- The dashboard is a local viewer only.
- It does not upload, transmit, or share any data.
- There is no "share" or "export to cloud" feature in v0.5.

## No telemetry

- The dashboard does not collect usage statistics.
- No analytics, no crash reports, no page view tracking.
- No external scripts (not even for fonts or icons).

## No external scripts or CDN

- All CSS is inline.
- Any JavaScript (if used) is inline and minimal.
- No CDN-hosted libraries, fonts, or icons.
- The dashboard works fully offline after the HTML file is generated or saved.

## Safe handling of paths

- File paths in the report (e.g. `C:\GameServers\...`) are informational.
- They are displayed as plain text only.
- They are not hyperlinks, not actionable, not clickable.
- Users should be reminded that paths are local to the scanned machine.

## Avoid exposing the dashboard publicly unless reviewed

- The dashboard may contain server names, folder paths, and health status.
- Before sharing a screenshot or PDF of the dashboard, review for:
  - Real server names or player-identifying information
  - Real file paths from the scanned machine
  - Any sensitive data that should not be visible externally
- Use fictional server names in demo screenshots.
- The existing screenshot redaction guide (`docs/assets/SCREENSHOT_REDACTION_GUIDE.md`) applies to dashboard screenshots as well.
