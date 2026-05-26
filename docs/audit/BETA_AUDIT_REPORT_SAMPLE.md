# QuestOps Watchdog — Beta Audit Report Sample

A fictional completed audit report for demonstration. All server names, paths, and data are fictional.

---

## Audit Report: Demo Game Servers

**Date:** 2026-05-26
**Auditor:** [Your Name]
**Tier:** Free Beta Audit

## Client/server context

- **Server setup:** Two game servers on a single Windows machine — Project Zomboid and Minecraft. Self-hosted, moderate player count.
- **Concerns raised:** Occasional reports of Minecraft server being unreachable. Unsure if thresholds are correct.
- **Bundle received:** 2026-05-25
- **Files reviewed:** latest-health-report.json, latest-health-report.html

## Scope reviewed

- [x] JSON health report (latest-health-report.json)
- [x] HTML audit report (latest-health-report.html)
- [ ] Client config (servers.local.json) — not provided
- [ ] Run log (questops-run.log) — not provided

## Executive summary

The Demo Project Zomboid server is healthy — all checks pass with reasonable thresholds. The Demo Minecraft server has multiple issues: the game port is unreachable, the log file is stale, and process memory exceeds the configured threshold. These issues suggest the Minecraft server may be hung or misconfigured. Two recommendations are quick wins that can be applied in under 5 minutes.

## Overall status

**MIXED** — 1 of 2 servers has failures.

## Health check summary

| Server | Folder | Disk | Process | Network | Logs | Resources | Overall |
|--------|--------|------|---------|---------|------|-----------|---------|
| Demo Project Zomboid Server | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| Demo Minecraft Server | PASS | PASS | PASS | FAIL | FAIL | FAIL | FAIL |

## Key findings

### 1. Minecraft game port unreachable — High

**What the scan showed:** Port 25565 on 127.0.0.1 timed out after 3000 ms.

**Why it matters:** Players cannot connect to the Minecraft server even though the process (java.exe) is running. The server appears running but is not accepting connections.

**Recommended fix:** Check whether the server bound to the expected address and port. Verify firewall rules, port forwarding, and that no other application is using port 25565.

### 2. Minecraft log file stale — High

**What the scan showed:** The log at `C:\GameServers\Minecraft\logs\latest.log` was last written 980 minutes ago (threshold: 15 minutes).

**Why it matters:** The server process may be hung or crashed. A running process that stops writing logs is often unresponsive.

**Recommended fix:** Restart the Minecraft server. After restart, confirm the log resumes updating normally. If the log stops again soon, investigate plugin or mod issues.

### 3. Minecraft memory over threshold — Medium

**What the scan showed:** java.exe using 5120.8 MB with a threshold of 4096 MB.

**Why it matters:** The server regularly exceeds its configured memory threshold, causing false failure flags on every scan.

**Recommended fix:** Increase `max_memory_mb` to 6144 MB (or higher depending on player count) to match actual usage. If memory keeps growing over time, monitor for a potential leak.

### 4. Config and log not provided — Informational

**What the scan showed:** The audit bundle contained only the JSON report, HTML report, and manifest.

**Why it matters:** Without the config file, thresholds and paths cannot be verified directly. Without the run log, scan history and error patterns are unavailable.

**Recommended fix:** If comfortable, re-export with `-IncludeConfig -IncludeLog` for a more thorough review in a future audit.

## Severity table

| Severity | Count |
|----------|-------|
| Critical | 0 |
| High | 2 |
| Medium | 1 |
| Low | 0 |
| Informational | 1 |

## Recommended fixes

| Priority | Issue | Action | Est. effort |
|----------|-------|--------|-------------|
| 1 | Minecraft port unreachable | Check firewall and server bind address | 15 min |
| 2 | Minecraft log stale | Restart server, monitor log | 10 min |
| 3 | Minecraft memory threshold | Increase max_memory_mb to 6144 | 2 min |

## Quick wins

- **Increase memory threshold** — edit `max_memory_mb` from 4096 to 6144 in the config. (Under 2 minutes.)
- **Re-export bundle with config/log** — run `export_questops_audit_results.ps1 -IncludeConfig -IncludeLog`. (Under 1 minute.)

## Follow-up questions

- Was the Minecraft server running normally at the time of the scan, or were you aware of issues?
- Can you share the config file (redacted if needed) for threshold verification?
- Would you like a follow-up review after applying the fixes?

## Next steps

1. Restart the Minecraft server and confirm the log resumes updating
2. Check port 25565 reachability after restart
3. Increase memory threshold to match actual usage
4. Re-run the scan and confirm all checks pass
5. If issues persist, feel free to send an updated bundle for re-review

---

## Disclaimer

This audit report is operational guidance based on the scan outputs the client voluntarily provided. It is not a guarantee of server stability, security, or performance. Findings are based on the data available at the time of review. Always verify recommendations before applying them to a production environment. The tool is provided as-is with no uptime guarantees.
