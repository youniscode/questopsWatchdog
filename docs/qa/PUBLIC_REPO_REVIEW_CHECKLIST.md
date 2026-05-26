# QuestOps Watchdog — Public Repository Review Checklist

## README review

- [ ] README accurately describes the tool without exaggeration
- [ ] "Current status" section shows correct tagged release and repository milestone
- [ ] "What it currently checks" table matches all scan capabilities
- [ ] Requirements section is accurate (Windows, PowerShell 5.1)
- [ ] All command examples are syntactically correct
- [ ] All exit code tables are accurate
- [ ] Safety/security section is present and up to date
- [ ] No hardcoded secrets, tokens, or webhook URLs

## Docs links review

- [ ] Every relative link in the README resolves (click through each one)
- [ ] Business docs links work (PAID_AUDIT_OFFER.md, LANDING_PAGE_COPY.md)
- [ ] Demo docs links work (all 5 SAMPLE_* files)
- [ ] Screenshot docs links work (capture checklist, redaction guide, shot list, demo script, review checklist)
- [ ] Website docs links work (all 4 docs)
- [ ] Launch docs links work (all 7 docs)
- [ ] CHANGELOG.md links in README resolve
- [ ] Security/Contributing/License links in README resolve
- [ ] QUICK_START.md link in README resolves

## Issue templates review

- [ ] Bug report template has clear steps, environment fields, and security reminder
- [ ] Feature request template captures problem, solution, game type, scope preference
- [ ] PR template has validation, PowerShell 5.1, docs update, and security checklists
- [ ] All templates render correctly on GitHub (no broken YAML front matter)

## Security policy review

- [ ] SECURITY.md lists supported versions (must include v0.4.9)
- [ ] Reporting process is clear
- [ ] Secret handling guidance is included
- [ ] No-telemetry statement is included

## License note review

- [ ] LICENSE-NOTE.md matches the intended copyright position
- [ ] Permitted use and restrictions are clear
- [ ] No contradiction with README's "free, open-source" statement

## Package count review

- [ ] README says 53 files — verify by exporting the package
- [ ] CLIENT_HANDOFF_CHECKLIST.md expects 53 files — verify consistency
- [ ] No `docs/launch/` files leaked into the package
- [ ] No `docs/release/` files leaked into the package
- [ ] No `docs/qa/` files leaked into the package
- [ ] No GitHub-facing files (SECURITY.md, CONTRIBUTING.md, LICENSE-NOTE.md) in the package
- [ ] No generated reports, logs, or HTML files in the package

## Screenshots status review

- [ ] README is clear that real screenshots are not yet captured
- [ ] All 6 placeholder docs are present in `docs/assets/placeholders/`
- [ ] Placeholder docs use fictional data only
- [ ] `docs/assets/README.md` links to all placeholder docs

## Roadmap clarity review

- [ ] ROADMAP.md clearly distinguishes shipped (v0.4.9) from unreleased (v0.4.10+)
- [ ] README roadmap table matches ROADMAP.md
- [ ] Next milestone is clearly stated

## Commercial audit wording review

- [ ] Paid audit is presented as optional, not required
- [ ] Free tool is clearly positioned as fully functional without purchase
- [ ] No misleading urgency or pressure language
- [ ] Pricing is clearly marked as suggested/adjustable

## Final "safe to share publicly?" checklist

- [ ] No real IP addresses in any documentation file
- [ ] No real server names, player names, or usernames
- [ ] No real webhook URLs, passwords, tokens, or secrets
- [ ] No real file paths from the developer's machine
- [ ] No Discord channel IDs or private message content
- [ ] All demo/fictional data is clearly marked as fictional
- [ ] All placeholder docs reference only fictional data
- [ ] Export script safety scan passes on the full repo
- [ ] No `docs/launch/` content is visible in the repository (these are internal workflow docs)
- [ ] No `docs/release/` content is visible in the repository (these are internal prep docs)
- [ ] No `docs/qa/` content is visible in the repository (these are internal QA docs)
- [ ] `.gitignore` protects all generated, local, and secret content
- [ ] The repository is ready for public visibility on GitHub
