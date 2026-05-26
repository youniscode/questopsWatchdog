# PowerShell Scan Screenshot — Placeholder

## Intended image name

`screenshot-powershell-scan-v0.4.14.png`

## Purpose

Show the command-line output of a QuestOps Watchdog scan with mixed results (some pass, some fail). Used in documentation to illustrate a typical scan workflow.

## What the screenshot should show

A PowerShell console window after running a scan with mixed results:

- Command line: `.\questops_scan.ps1 -ConfigPath config\servers.game.example.json`
- At least one server with PASS (all checks green)
- At least one server with FAIL (one or more checks failed)
- Mixed summary at the bottom: X of Y checks passed
- Clear PASS/FAIL badges per server

## Data requirements

- Must use safe demo config (`config/servers.example.json` or `config/servers.game.example.json`)
- Server names must be fictional: `Demo Project Zomboid`, `Demo Minecraft`
- Must avoid personal Windows username paths
- PowerShell prompt must use generic or fictional machine name
- No real webhook URLs, IPs, or environment variables

## Suggested command

```powershell
.\questops_scan.ps1 -ConfigPath config\servers.game.example.json
```

## Suggested alt text

"QuestOps Watchdog PowerShell scan output showing one passing server and one failing server with mixed PASS/FAIL results."
