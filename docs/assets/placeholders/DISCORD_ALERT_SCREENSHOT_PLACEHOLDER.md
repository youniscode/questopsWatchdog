# Discord Alert Screenshot — Placeholder

## Intended image name

`screenshot-discord-alert-v0.4.14.png`

## Purpose

Show what a Discord alert looks like when QuestOps Watchdog detects a failure. Used in documentation and the landing page.

## What the screenshot should show

A Discord channel with a single alert message from QuestOps Watchdog:

- Alert header: `QuestOps Watchdog — Health Alert`
- UTC timestamp of the scan
- Status: `FAILED — 1/2 servers failed`
- Failed server name and failed categories
- Detail lines for specific check failures
- Report path at the bottom

## Data requirements

- Must use fake Discord server/channel or a local mock
- Channel name must be fictional (e.g. `#server-alerts`, `#demo`)
- Server name in alert: `Demo Minecraft Server` only
- Alert must reference fictional check failures (network timeout, stale log)
- IPs: `127.0.0.1:25565` or `192.0.2.x` only
- Must not show real Discord messages, user avatars, channel IDs, webhook URLs, or server names
- Blur or crop out any Discord UI elements outside the alert message (sidebar, user list, channel list)

## Suggested alt text

"Discord alert from QuestOps Watchdog showing a failed server check with server name, failed categories, and timestamp."
