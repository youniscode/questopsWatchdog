# QuestOps Watchdog — Screenshot Capture Results (v0.5.0)

## Results table

| # | Shot ID | Feature | Status | File name | Redacted | Reviewed | Notes |
|---|---------|---------|--------|-----------|----------|----------|-------|
| 1 | dashboard-overview | Dashboard overview | Manual capture required | | | | Requires browser render of generated dashboard HTML |
| 2 | dashboard-filters | Dashboard filters | Manual capture required | | | | Requires browser render with filter tab selected |
| 3 | dashboard-trends | Dashboard trend section | Manual capture required | | | | Requires browser scroll to trend section |
| 4 | scan-healthy | Healthy scan output | Manual capture required | | | | Requires console capture after running scan |
| 5 | scan-mixed | Mixed scan output | Manual capture required | | | | Requires custom config with failing server |
| 6 | scan-tcp-fail | TCP failure | Manual capture required | | | | Requires offline target or wrong port |
| 7 | html-report | HTML report | Manual capture required | | | | Requires browser render of generated HTML report |
| 8 | config-file | Config file | Manual capture required | | | | Requires editor showing config JSON |
| 9 | help-output | Help output | Manual capture required | | | | Requires console capture of -help output |

## Summary

| Metric | Value |
|--------|-------|
| Total planned | 9 |
| Captured | 0 |
| Redacted | — |
| Reviewed | — |
| Committed | — |

## Notes

- All 9 shots require manual capture — screenshots cannot be captured in a headless/text-only environment
- See [SCREENSHOT_CAPTURE_PLAN_v0.5.0.md](SCREENSHOT_CAPTURE_PLAN_v0.5.0.md) for capture instructions
- See [SCREENSHOT_DEMO_SCRIPT.md](SCREENSHOT_DEMO_SCRIPT.md) for step-by-step PowerShell commands
- Use `192.0.2.x` for all IP addresses (RFC 5737)
- Use fictional server names: "Demo Project Zomboid", "Demo Minecraft"
- Redact webhook URLs to `https://discord.com/api/webhooks/demo/demo`
- Save screenshots to `docs/assets/screenshots/` using naming convention `questops-v0.5.0-{feature}.png`
- After capturing, run review per [SCREENSHOT_REVIEW_CHECKLIST.md](SCREENSHOT_REVIEW_CHECKLIST.md)
