# QuestOps Watchdog — GitHub README Positioning

Guidance for positioning the project on GitHub to attract both free users and paid audit clients.

---

## Target audiences

1. **Self-hosters** — individual server operators looking for free monitoring
2. **Hosting providers** — small businesses that resell game server hosting
3. **Server admins** — managing multiple servers for a community

The README serves all three. The paid audit offering should be visible but not pushy.

## Tone

- Professional, straightforward, no hype
- Emphasise "free and open-source" as the primary value
- Paid audit is presented as a *service*, not a *paywall*
- No fake scarcity, no "limited time", no aggressive CTAs

## Where paid audit fits in the README

### Option A (recommended): Dedicated section near the bottom

After all technical documentation, add a "Commercial audit offer" heading. This keeps the README useful for free users first.

### Option B: Single line in the header

Minimal. Adds "Paid audits available" next to the version badge.

## What to avoid

- DO NOT imply the free tool is incomplete without the paid audit
- DO NOT use "upgrade", "premium", "pro", or "enterprise" as feature tiers of the tool itself
- DO NOT gate features behind payment (the full tool is free)
- DO NOT include fake testimonials
- DO NOT hardcode prices in the README (link to `PRICING_NOTES.md` or `PAID_AUDIT_OFFER.md`)

## Suggested badge

```
[![Paid audits available](https://img.shields.io/badge/audits-paid-blue)](docs/business/PAID_AUDIT_OFFER.md)
```

## Suggested README placement

```markdown
## Commercial audit offer

Need a deeper analysis of your server setup? I offer paid manual audits that include
config review, security checks, and actionable recommendations.

→ [View audit packages](docs/business/PAID_AUDIT_OFFER.md)
```

## Repository structure for business docs

```
docs/business/
├── PAID_AUDIT_OFFER.md          # Pricing, scope, what's included
├── LANDING_PAGE_COPY.md          # Marketing copy reference
├── OUTREACH_MESSAGES.md          # Message templates
├── SAMPLE_CLIENT_PROPOSAL.md     # Proposal template
├── SAMPLE_AUDIT_SUMMARY.md       # Sample audit output
├── GITHUB_README_POSITIONING.md  # This file
└── PRICING_NOTES.md              # Pricing rationale and strategy
```

All business docs are included in the client tool package for easy reference.
