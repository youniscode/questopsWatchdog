# QuestOps Watchdog — Screenshot Review Checklist

Use this checklist before publishing any screenshot to the repository or using it in public-facing materials.

## Content review

- [ ] Screenshot matches its intended scenario (healthy scan, TCP fail, etc.)
- [ ] Output shown is consistent with what the tool actually produces
- [ ] No misleading or exaggerated claims implied by the screenshot (e.g. showing features that don't exist yet)
- [ ] Fictional server names match the demo convention (Demo Project Zomboid, Demo Minecraft, etc.)
- [ ] Config values in screenshots are consistent across related captures (same fictional servers, same fictional IPs)

## Redaction review

- [ ] No real webhook URLs visible anywhere in the image
- [ ] No real IP addresses visible (public or private)
- [ ] No real server or client names visible
- [ ] No real player or Discord usernames visible
- [ ] No real file paths with user-specific components (usernames, drive letters that don't match the convention)
- [ ] No real Windows usernames visible in the prompt or output
- [ ] No real environment variable values that reveal system information
- [ ] Redaction is applied consistently to every occurrence in the image

## Technical review

- [ ] Image is in PNG format (not JPEG — text should be crisp)
- [ ] Image resolution is at least 1280x720 (or higher for full-window captures)
- [ ] Text in the image is readable at 100% zoom
- [ ] No scrollbars visible unless the scrollbar is part of the scenario (browser frame)
- [ ] No window borders or desktop backgrounds visible unless intentional (crop to content)
- [ ] File name follows the naming convention: `screenshot-{id}-v{version}.png`
- [ ] File name uses lowercase, hyphens for spaces
- [ ] File size is below 2 MB (optimize if larger)

## Legal review

- [ ] No copyrighted or trademarked content visible (game logos, brand names)
- [ ] No real user data or server metrics from a production environment
- [ ] Screenshot does not reveal internal project structure or file contents beyond what is intended

## Final check

- [ ] Screenshot has been opened at 100% zoom and visually inspected
- [ ] All redaction overlays are opaque (not semi-transparent)
- [ ] The image tells its intended story without needing additional explanation

## Sign-off

| Role | Name | Date |
|------|------|------|
| Captured by | | |
| Reviewed by | | |
| Approved by | | |

## Related

- [Capture checklist](SCREENSHOT_CAPTURE_CHECKLIST.md) — what screenshots to take
- [Redaction guide](SCREENSHOT_REDACTION_GUIDE.md) — what to redact and how
