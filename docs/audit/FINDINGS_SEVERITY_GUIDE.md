# QuestOps Watchdog — Findings Severity Guide

Define severity levels consistently across all audit reports.

---

## Severity levels

### Critical

| Field | Value |
|-------|-------|
| **Definition** | Immediate risk to server availability, data safety, or security. Must be addressed as soon as possible. |
| **Example conditions** | Discord webhook URL exposed in config notes field. Config file contains hardcoded passwords or tokens. Server process is not running. Disk is completely full (0 bytes free). |
| **Response expectation** | Inform the client immediately. Recommend fix within 24 hours. Offer guidance on how to resolve. |
| **Example wording** | "Your Discord webhook URL was found in the config notes field. This means the webhook could be exposed if the config is shared or committed. Remove it immediately and use the environment variable `$env:QUESTOPS_DISCORD_WEBHOOK_URL` instead." |

### High

| Field | Value |
|-------|-------|
| **Definition** | Significant operational risk. Likely to cause failures or incorrect monitoring. Should be addressed soon. |
| **Example conditions** | TCP port unreachable (game not accepting connections). Log file stale by hours (server may be hung). Memory threshold set well below actual usage causing false failures. Log path points to a non-existent file. |
| **Response expectation** | Recommend fix within the week. Explain the impact clearly. |
| **Example wording** | "The Minecraft game port (25565) was unreachable during the scan. This means players cannot connect even though the server process is running. Check the firewall, server bind address, and whether the port is in use by another application." |

### Medium

| Field | Value |
|-------|-------|
| **Definition** | Moderate risk. May cause false positives, missed alerts, or inefficiencies. Should be noted and fixed when convenient. |
| **Example conditions** | Disk threshold too conservative (e.g. 5 GB on a 2 TB drive — will never trigger). No network checks configured for a server. No scheduled task installed (manual scans only). Missing optional config or log in audit bundle. |
| **Response expectation** | Recommend fix when time allows. Provide reasoning. |
| **Example wording** | "The disk threshold is set to 5 GB on a drive with 2 TB total space. This threshold is unlikely to ever trigger in practice. Consider lowering it to 20 GB to get earlier warning of disk issues." |

### Low

| Field | Value |
|-------|-------|
| **Definition** | Minor issue or suggestion. No immediate operational impact but worth addressing for completeness. |
| **Example conditions** | Config uses placeholder paths (from the example config) that do not match the actual server locations. No notes field used. Minor formatting inconsistencies. |
| **Response expectation** | Note for the client. No urgent action needed. |
| **Example wording** | "The config still contains placeholder paths from the game server template. These have been updated for the actual scan but double-check that all paths point to your real server folders." |

### Informational

| Field | Value |
|-------|-------|
| **Definition** | Observation or recommendation. Not a problem but may improve operations or monitoring quality. |
| **Example conditions** | Discord webhook not configured (no alerting — tool still works). Scheduled task not installed (manual scans only). Audit bundle missing config/log — bundle still usable but less context available. CPU threshold set but never exceeded. |
| **Response expectation** | Mention for awareness. No action required. |
| **Example wording** | "Discord alerting is not configured. The tool will still run and produce reports, but you will not receive notifications on failure. To enable alerts, set `$env:QUESTOPS_DISCORD_WEBHOOK_URL` and run `questops_run.ps1`." |

---

## Severity at a glance

| Level | Impact | Response time | Colour |
|-------|--------|---------------|--------|
| Critical | Immediate risk | ASAP — within 24h | Red |
| High | Significant risk | Within a week | Orange |
| Medium | Moderate risk | When convenient | Yellow |
| Low | Minor issue | Note only | Blue |
| Informational | Observation | No action required | Grey |
