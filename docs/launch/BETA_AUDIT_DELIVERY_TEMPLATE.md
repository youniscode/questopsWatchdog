# QuestOps Watchdog — Beta Audit Delivery Template

Use this structure when delivering a beta audit summary to a client. Fill in the bracketed sections.

---

## Delivery message

**Subject:** QuestOps Watchdog — Audit Summary for [Server/Client Name]

Hi [Name],

Thank you for participating in the beta audit and for sharing your scan outputs.

### Scope reviewed

- **Bundle received:** [Date]
- **Files reviewed:** [latest-health-report.json, latest-health-report.html, config/servers.local.json, logs/questops-run.log, etc.]
- **Servers reviewed:** [Number]
- **Audit tier:** [Free beta / Quick Scan / Standard / etc.]

### Overall status

**PASS / FAIL / MIXED**

[One-sentence summary of overall health.]

### Top 3 findings

1. **[Finding title]** — [Brief description of the issue, what data showed, and why it matters]
2. **[Finding title]** — [Brief description]
3. **[Finding title]** — [Brief description]

### Priority fixes

| Priority | Issue | Suggested action |
|----------|-------|-----------------|
| Critical | [Issue] | [Action] |
| High | [Issue] | [Action] |
| Medium | [Issue] | [Action] |
| Low | [Issue] | [Action] |

### What looks healthy

- [Check or server that passed and is well configured]
- [Another healthy aspect]

### What needs follow-up

- [Issue that could not be fully assessed from the data provided]
- [Suggestion for what to try or monitor next]

### Suggested next steps

1. [First actionable step]
2. [Second actionable step]
3. [Optional: third step or recommendation]

---

### Feedback request (optional)

If you found this audit helpful, I would appreciate any feedback:

- Was the tool easy to run?
- Did the report make sense?
- What confused you?
- Would you use this again?
- Can I quote your feedback anonymously?

No pressure — your time and honesty are what matter most.

---

**Disclaimer:** This audit is operational guidance based on the scan outputs you provided. It is not a guarantee of server stability, security, or performance. Always verify recommendations before applying them to a production environment.

---

## After delivery

- [ ] Mark the audit as delivered in the outreach tracker
- [ ] Send the feedback form if the client is open to it
- [ ] Note any bugs or improvements discovered during the audit
- [ ] Follow up within 7 days if the client had questions
