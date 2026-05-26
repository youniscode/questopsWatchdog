# README Hero Screenshot — Placeholder

## Intended image name

`screenshot-readme-hero-v0.4.14.png`

## Purpose

Hero image for the GitHub README — shown near the top of the page to give visitors an immediate visual of what QuestOps Watchdog does.

## What the screenshot should show

A PowerShell console window after running a successful scan. The output should show:

- The command line: `.\questops_scan.ps1` or `.\questops_run.ps1`
- Two servers (Demo Project Zomboid, Demo Minecraft) both PASSING all checks
- The summary line: "All checks passed" or equivalent
- Green PASS badges for both servers
- Clean, professional console output

## Safe data requirements

- Server names: `Demo Project Zomboid`, `Demo Minecraft` only
- IPs: `127.0.0.1` or `192.0.2.x` only
- Paths: `C:\GameServers\Demo\...` or `C:\Users\Admin\...` only
- No real usernames, webhook URLs, or environment variables

## Redaction checklist

- [ ] No real webhook URLs
- [ ] No real IP addresses
- [ ] No real server or client names
- [ ] No real Windows usernames (prompt line must show fictional or generic)
- [ ] No real file paths with user-specific components
- [ ] PowerShell prompt should not reveal real machine name or user

## Suggested alt text

"QuestOps Watchdog PowerShell scan output showing two game servers with green PASS badges and a clean health summary."

## Where it will be referenced later

Embedded in the README near the top, after the "What it checks" table or the "Quick start" command block.
