# QuestOps Watchdog — Outreach Launch Checklist

## Goal

Approach first beta users, run safe paid/manual audits, collect results and feedback, and learn from real use cases before a wider public release.

## What must be ready before outreach

- [x] Tool package exports cleanly (52 files, safety scan passes)
- [x] Config validator works
- [x] Scan produces a valid JSON report
- [x] HTML exporter works
- [x] Audit results bundle exports cleanly
- [ ] This launch checklist filled out
- [ ] Beta audit workflow defined (see FIRST_BETA_AUDIT_WORKFLOW.md)
- [ ] Intake form ready (see BETA_AUDIT_INTAKE_FORM.md)
- [ ] Delivery template ready (see BETA_AUDIT_DELIVERY_TEMPLATE.md)
- [ ] Message templates ready (see LAUNCH_MESSAGE_PACK.md)
- [ ] Feedback form ready (see BETA_FEEDBACK_FORM.md)
- [ ] Outreach tracker ready (see OUTREACH_TRACKER_TEMPLATE.md)
- [ ] Pricing tiers confirmed (see docs/business/PAID_AUDIT_OFFER.md)
- [ ] First beta audit agreed in principle (preferred target)

## Where to post or message

- **Discord servers** for Project Zomboid, Minecraft, Valheim, ICARUS, survival games (use existing help channels, not DMs unless you have a conversation history)
- **Reddit** — r/ProjectZomboid, r/admincraft, r/gameserver, r/selfhosted (use community posts, not direct DMs)
- **GitHub** — if you already contribute to related open-source projects, reference this tool where relevant
- **Personal network** — server owners you already know who might benefit
- **Game hosting communities** — forums or Discord communities for self-hosters

## Where not to post

- Do not post in channels/servers that prohibit self-promotion
- Do not DM random users without context
- Do not post the same message in multiple channels of the same server
- Do not repost the same message to the same community within 30 days
- Do not post where the rules explicitly forbid commercial or promotional content

## Rules for ethical outreach

1. **Be transparent** — state clearly that this is an early/beta tool and a paid audit is optional
2. **Add value first** — help someone with their issue before mentioning the tool
3. **No pressure** — if someone says no, thank them and move on. Do not follow up again about the paid service
4. **No scraping** — do not use automated tools to collect user data or send messages
5. **Respect opt-out** — if someone asks not to be contacted, honor it immediately
6. **No fake urgency** — do not use "limited time" or "act now" language
7. **Do not exaggerate** — do not claim the tool fixes problems it cannot fix

## How to avoid spammy behavior

- Send no more than **5 outreach messages per day** in the first week
- Each message should be individually written or adapted to the context (never mass-copy-paste without reading)
- Always include a clear opt-out: "No worries if this isn't for you — just let me know and I won't follow up again"
- Do not send follow-up messages less than 5 days after no reply
- After one follow-up with no reply, mark the contact as "No reply" and do not contact again through the same channel

## Suggested daily outreach limit

| Phase | Messages per day |
|-------|-----------------|
| First week | 5 max |
| Weeks 2–4 | 10 max |
| After feedback collected | Adjust based on response rate |

## What to track

Use the outreach tracker (OUTREACH_TRACKER_TEMPLATE.md) to log:
- Date of contact
- Platform and community
- Message used (reference the template ID)
- Response received
- Status in the pipeline

**Do not store private sensitive data in the tracker.** Use only the information needed to follow up (contact handle, date, status).

## What to do after someone replies

1. Read the full reply — do not pre-judge the intent
2. If interested: send the intake form (BETA_AUDIT_INTAKE_FORM.md)
3. If asking questions: answer honestly. If you don't know, say so
4. If reporting a bug: thank them, log the issue, fix it, and follow up
5. If they say no: thank them, mark as "Closed lost" in the tracker

## What to do if someone says no

- Respond with something like: "No problem at all — thanks for your time. If anything changes, feel free to reach out."
- Do not ask why — unless they offer an explanation
- Do not try to convince them
- Mark as "Closed lost" in the tracker

## What to do if someone reports a bug

1. Thank them for the report
2. Ask for details: what they ran, what they expected, what happened instead
3. If possible, ask for a sanitised copy of the report/error output
4. Fix the bug
5. Follow up with the reporter once the fix is available
6. Ask if they would like to test the fix

## Launch success criteria

- [ ] At least 5 outreach messages sent
- [ ] At least 2 replies received
- [ ] At least 1 beta audit started
- [ ] At least 1 beta audit completed
- [ ] At least 1 feedback form collected
- [ ] No complaints about spam or unwanted contact
- [ ] At least 1 bug or improvement identified from real use
