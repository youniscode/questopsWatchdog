# QuestOps Watchdog — Agent Rules

These rules govern any AI agent working on this project.

1. **No full rewrites** — make small, surgical changes. Never replace an entire file unless it is brand-new.
2. **Update PROJECTMAP.md** after every structural change (new files, moved files, removed files).
3. **Update TASKS.md** after every completed task.
4. **PowerShell 5.1 only** — do not use `&&`, `||`, `Get-Content -AsByteStream`, or other features added in PowerShell 6+ / PowerShell Core.
5. **No hardcoded secrets** — webhook URLs, passwords, tokens, IPs must come from environment variables or config files that are gitignored.
6. **Every feature must have a validation command** — the user must be able to run a single command to confirm the feature works.
7. **Prefer simple local JSON** — no databases, no cloud services, no REST APIs unless the need is proven.
8. **Do not commit unless asked** — stage changes only when the user explicitly requests a commit.
