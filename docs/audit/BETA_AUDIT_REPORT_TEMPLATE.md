# QuestOps Watchdog — Beta Audit Report Template

Copy/paste and fill in the bracketed sections. This template is for internal operator use when preparing audit reports for beta/manual review clients.

---

## Title

**Audit Report: [Client/Server Name]**
**Date:** [Date]
**Auditor:** [Your Name]
**Tier:** [Free Beta / Quick Scan / Standard Audit / Comprehensive Audit]

## Client/server context

- **Server setup:** [Brief description: games, player count, hosting type, any known issues]
- **Concerns raised:** [What the client wanted the audit to address]
- **Bundle received:** [Date]
- **Files reviewed:** [List of files from the audit results bundle]

## Scope reviewed

- [ ] JSON health report (latest-health-report.json)
- [ ] HTML audit report (latest-health-report.html)
- [ ] Client config (servers.local.json) — if provided
- [ ] Run log (questops-run.log) — if provided

## Executive summary

[2–3 sentence summary of overall findings. Start with what is healthy, then note the key issues.]

## Overall status

**PASS / FAIL / MIXED**

[One-line summary.]

## Health check summary

| Server | Folder | Disk | Process | Network | Logs | Resources | Overall |
|--------|--------|------|---------|---------|------|-----------|---------|
| [Server name] | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL |
| [Server name] | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL |

## Key findings

### 1. [Finding title] — [Severity]

**What the scan showed:** [Quote or paraphrase the relevant report data]

**Why it matters:** [Explain the impact on the server or operations]

**Recommended fix:** [Actionable step to resolve]

### 2. [Finding title] — [Severity]

...

## Severity table

| Severity | Count | Total issues |
|----------|-------|-------------|
| Critical | [N] | [N] |
| High | [N] | [N] |
| Medium | [N] | [N] |
| Low | [N] | [N] |
| Informational | [N] | [N] |

## Recommended fixes

List all actionable recommendations in priority order:

| Priority | Issue | Action | Est. effort |
|----------|-------|--------|-------------|
| 1 | [Issue] | [Action] | [Time] |
| 2 | [Issue] | [Action] | [Time] |
| 3 | [Issue] | [Action] | [Time] |

## Quick wins

Things that can be fixed in under 5 minutes:

- [Quick fix 1]
- [Quick fix 2]

## Follow-up questions

- [Question about config, setup, or behavior that could not be determined from the bundle]
- [Question about the client's environment]

## Next steps

1. [First actionable step for the client]
2. [Second step]
3. [Optional: offer follow-up support or paid audit]

---

## Disclaimer

This audit report is operational guidance based on the scan outputs the client voluntarily provided. It is not a guarantee of server stability, security, or performance. Findings are based on the data available at the time of review. Always verify recommendations before applying them to a production environment. The tool is provided as-is with no uptime guarantees.
