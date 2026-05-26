# QuestOps Watchdog — Beta Audit Internal Review Checklist

Use this checklist before sending any audit report to a client.

---

## Audit bundle opened and inspected

- [ ] The zip was extracted and all expected files are present (JSON report, HTML report, manifest)
- [ ] The manifest confirms no safety scan warnings or errors
- [ ] If config was included: it is readable and structurally valid
- [ ] If log was included: it contains relevant scan history

## JSON report reviewed

- [ ] Overall status noted (PASS / FAIL / MIXED)
- [ ] Per-server pass/fail checked for each server
- [ ] Failed checks reviewed in detail (folder, disk, process, network, logs, resources)
- [ ] Error messages in failed checks recorded for the report
- [ ] Optional check results (network, logs, resources) verified against what was configured

## HTML report reviewed

- [ ] HTML report renders correctly (open in browser, check layout)
- [ ] Summary cards match the JSON report data
- [ ] Per-server detail tables match expectations
- [ ] No formatting issues or broken content

## Optional config/log checked if provided

- [ ] Config thresholds reviewed for reasonableness
- [ ] Config paths checked for placeholder values that should have been replaced
- [ ] Config security reviewed (no hardcoded webhook URLs, passwords, or tokens)
- [ ] Run log reviewed for recurring errors or patterns

## No secrets copied into the report

- [ ] The audit report does not contain any webhook URLs from the client's config
- [ ] The audit report does not contain any passwords, tokens, or secrets
- [ ] The audit report does not contain any real IPs (use hostnames or redact)
- [ ] The audit report does not contain any real Discord usernames or identifiers
- [ ] The audit report uses only fictional paths or generic descriptions (e.g. "config path points to a non-existent file")

## Findings classified by severity

- [ ] Each finding has a severity label (Critical / High / Medium / Low / Informational)
- [ ] Severity is consistent with the severity guide
- [ ] No intentional downplaying of serious issues
- [ ] No inflation of minor issues into high-severity findings

## Recommendations are actionable

- [ ] Each recommendation includes a specific action the client can take
- [ ] Recommendations are written in the style guide format (factual, non-alarming)
- [ ] Quick wins are identified and clearly labelled
- [ ] No vague suggestions like "monitor it" without explaining what to look for

## Report does not overpromise

- [ ] The report clearly states it is based on the data the client provided
- [ ] The disclaimer is included: operational guidance, not a guarantee
- [ ] No claims that the tool or the audit will prevent future failures
- [ ] No promises of uptime, security, or performance improvements

## Client questions are clearly separated

- [ ] Any questions for the client are in a separate section
- [ ] Questions are specific and answerable (not open-ended)
- [ ] The client is not asked to provide sensitive information

## Delivery message prepared

- [ ] The delivery message includes the key findings summary
- [ ] The delivery message tone matches the style guide (calm, professional, not pushy)
- [ ] The delivery message includes the feedback request

## Feedback request prepared

- [ ] The feedback form (or a link to it) is ready to send after delivery
- [ ] The client is told their feedback is optional and appreciated

---

## Sign-off

| Check | Completed |
|-------|-----------|
| Bundle opened and inspected | [ ] |
| JSON report reviewed | [ ] |
| HTML report reviewed | [ ] |
| Config/log checked (if provided) | [ ] |
| No secrets in report | [ ] |
| Findings classified by severity | [ ] |
| Recommendations actionable | [ ] |
| Report does not overpromise | [ ] |
| Client questions separated | [ ] |
| Delivery message ready | [ ] |
| Feedback request ready | [ ] |
