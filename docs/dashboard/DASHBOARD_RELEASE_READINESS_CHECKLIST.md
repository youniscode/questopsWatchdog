# QuestOps Watchdog — Dashboard Release Readiness Checklist

## Scope confirmation

- [ ] Dashboard is a local static HTML file — no server, no backend, no database
- [ ] No JavaScript — all interactivity is CSS-only radio tabs
- [ ] No external dependencies — no CDN, no fonts, no images, no frameworks
- [ ] No telemetry, no phone-home, no analytics
- [ ] No web server required — open directly from the filesystem

## Required dashboard scenarios

- [ ] Normal passing report — green PASS, all checks OK, summary cards correct
- [ ] Failing report — red FAIL, failed categories shown, details present
- [ ] Missing report — error page with "Report Not Found" and suggested fixes (exit 2)
- [ ] Malformed report — error page with "Malformed Report" and suggested fixes (exit 3)
- [ ] Partial report — warning box with inferred field messages (exit 0)
- [ ] Empty history — no history directory or files, dashboard still renders
- [ ] Malformed history warning — bad history files skipped, warning box shown (exit 5)
- [ ] History trend view — trend cards display counts, rates, streaks, timeline pills, failure insights
- [ ] Print preview — filter tabs hidden, all views shown, page-break avoidance, monochrome-friendly
- [ ] Small screen / responsive — tables scroll horizontally, cards stack on narrow viewports

## Security review

- [ ] No webhook URLs appear in any rendered output
- [ ] No secrets (passwords, tokens, API keys) present in the HTML
- [ ] No raw logs, stack traces, or environment variables in error pages
- [ ] No config file content exposed in the dashboard
- [ ] All rendered string values are HTML-encoded
- [ ] Discord webhook URL patterns are redacted as `[REDACTED]`
- [ ] Error pages contain no raw JSON or exception details

## Package review

- [ ] Package count remains 56 files
- [ ] Generated dashboard files (`reports/*.html`) are excluded from the client package
- [ ] Generated JSON reports (`reports/*.json`) are excluded from the client package
- [ ] Internal docs (`docs/dashboard/`) are excluded from the client package
- [ ] VERSION remains 0.4.9 unless tagging later

## Browser review

- [ ] Microsoft Edge — opens, renders correctly, filters work, print preview OK
- [ ] Google Chrome — opens, renders correctly, filters work, print preview OK
- [ ] Mozilla Firefox — opens, renders correctly, filters work, print preview OK (optional)

## Screenshot readiness

- [ ] Dashboard screenshots use only fictional/safe demo data
- [ ] All server names, IPs, and paths are fictional or redacted
- [ ] No real webhook URLs, usernames, or client data visible in any screenshot
- [ ] Screenshots pass the redaction checklist before commit
- [ ] No unreviewed screenshots are committed to the repository
- [ ] See `docs/dashboard/DASHBOARD_SCREENSHOT_PASS.md` for the capture plan

## Final sign-off

- [ ] All Required dashboard scenarios pass
- [ ] Security review has no findings
- [ ] Package review confirms 56 files, no leaks
- [ ] Browser review at least Edge + Chrome
- [ ] Screenshot plan documented and ready to execute

---

*Use `docs/dashboard/DASHBOARD_FINAL_VALIDATION_COMMANDS.md` to run all validation steps.*
