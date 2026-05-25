# QuestOps Watchdog — Contributing

## Setup

1. Clone the repository.
2. Ensure you are on **Windows** with **PowerShell 5.1**.
3. Open a PowerShell terminal at the project root.
4. Run the validation suite to confirm the tool works:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1
```

## Coding rules

1. **PowerShell 5.1 compatibility** — do not use:
   - `&&` / `||` pipeline chain operators
   - `??` / `??=` null-coalescing operators
   - Ternary `? :` operator
   - `ConvertFrom-Json -AsHashtable`
   - `Get-Content -AsByteStream`
   - Class syntax (`class Foo { }`)
   - Any feature from PowerShell 6+ / PowerShell Core

2. **No hardcoded secrets** — webhook URLs, passwords, tokens must come from environment variables or gitignored config. Never commit `.env` files, `servers.local.json`, or any file containing credentials.

3. **No generated files in commits** — `reports/`, `logs/`, `dist/`, `*.html`, `*.zip`, `*.tmp`, `*.bak` are gitignored. Never force-add them.

4. **Docs must be updated** — after any change that affects structure, behavior, commands, or file listings, update the following as applicable:
   - `README.md`
   - `docs/PROJECTMAP.md`
   - `docs/TASKS.md`
   - `docs/ROADMAP.md`
   - `docs/CLIENT_AUDIT_GUIDE.md`
   - `docs/CLIENT_HANDOFF_CHECKLIST.md`
   - `docs/RELEASE_CHECKLIST.md`
   - `CHANGELOG.md`

5. **Validation commands** — every feature must have a validation command the user can run to confirm it works. Add it to `docs/PROJECTMAP.md` under the Validation commands section.

6. **Small, surgical changes** — no full rewrites. Make targeted edits.

## Before submitting a pull request

- Run the full validation suite:
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert
  powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_package.ps1 -Force
  ```
- Confirm no generated files are staged: `git status`
- Confirm no secrets are staged: review all staged diffs
- Update the PR template checklist

## Code of conduct

Be respectful, constructive, and professional. This is a small open-source project — assume good intent.
