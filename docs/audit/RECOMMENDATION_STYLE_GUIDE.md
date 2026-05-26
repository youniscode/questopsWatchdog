# QuestOps Watchdog — Recommendation Style Guide

Guidelines for writing clear, professional, non-alarming audit recommendations.

---

## How to write non-alarming findings

- **State the fact first.** Begin with what the scan showed, not with a judgement.
  - Good: "The scan shows the log file has not been updated in 45 minutes."
  - Avoid: "The log file is dangerously stale."
- **Explain the consequence neutrally.** Describe what could happen without dramatising.
  - Good: "This may mean the server process is not writing output as expected."
  - Avoid: "This means your server is definitely broken."
- **Offer the fix as a suggestion, not an order.**
  - Good: "Consider checking whether the server is still responding to players."
  - Avoid: "You must fix this immediately."

## How to avoid blame

- Use "the config shows" instead of "you configured this wrong".
- Use "the scan reports" instead of "your server failed".
- Use passive constructions when describing problems: "the threshold was set to X" instead of "you set the threshold to X".
- Never imply the client made a mistake — assume good intentions and focus on the data.

## How to prioritise fixes

- List findings in order of impact: Critical → High → Medium → Low → Informational.
- Group urgent fixes together at the top.
- Separate "quick wins" (under 5 minutes) from longer tasks.
- If multiple issues are related, group them and suggest a single fix.

## How to write "quick win" recommendations

- Identify fixes that require only a config edit (no restart, no install).
- Examples: correcting a path typo, adjusting a threshold, adding a missing field.
- Label them clearly: **Quick win: [fix description] (under 5 minutes)**
- Explain the config change in plain language: "Change `max_memory_mb` from 2048 to 4096."

## How to explain uncertainty

- If you cannot determine the root cause from the data, say so.
  - Good: "The port is unreachable, but the report does not indicate why. Possible causes include firewall rules, port conflicts, or the server binding to a different address."
  - Avoid: "The port is unreachable because of a firewall."
- If you need more information, ask clearly.
  - Good: "Could you confirm whether the server was running at the time of the scan?"
  - Avoid: "You probably did not have the server running."

## How to ask for missing information

- Be specific about what you need and why.
  - Good: "The bundle did not include the config file. If you can share it (redacted if needed), I can check thresholds and path settings."
  - Avoid: "Send me more files."
- Make it easy to comply: explain the command to run, what it produces, and how to send it.

## Phrases to use

- "The scan indicates that…"
- "According to the report…"
- "Consider adjusting…"
- "A common starting point is…"
- "If this behaviour is expected, you can…"
- "For more thorough monitoring, you could…"
- "One possible explanation is…"
- "Based on the data available…"
- "Here are a few things to check…"

## Phrases to avoid

- "You made a mistake."
- "Your server is broken."
- "This is a critical failure."
- "You need to fix this now."
- "This is obviously wrong."
- "Anyone can see that…"
- "I do not know why you would…"
- Any phrasing that assumes fault, exaggerates risk, or pressures the client.

---

## Summary

| Principle | Do | Don't |
|-----------|----|-------|
| State facts neutrally | "The report shows folder_exists: false" | "Your server folder is missing" |
| Avoid blame | "The threshold was set to 5 GB" | "You set the wrong threshold" |
| Prioritise clearly | "High: Port unreachable — check firewall" | "Everything is broken" |
| Explain uncertainty | "Possible causes include…" | "This is definitely caused by…" |
| Ask clearly | "Could you confirm if the server was running?" | "Send more data" |
