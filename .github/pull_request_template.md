## Summary

Briefly describe the change and its purpose.

## Type of change

- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactor / code style
- [ ] Build / release
- [ ] Other (please describe)

## Validation commands run

List the commands you ran to verify the change works:

```powershell

```

## PowerShell 5.1 compatibility checked

- [ ] No `&&` / `||` pipeline chain operators
- [ ] No `??` / `??=` null-coalescing operators
- [ ] No ternary `? :` operator
- [ ] No `ConvertFrom-Json -AsHashtable`
- [ ] No `Get-Content -AsByteStream`
- [ ] Tested on PowerShell 5.1

## Docs updated

- [ ] `README.md`
- [ ] `docs/PROJECTMAP.md`
- [ ] `docs/TASKS.md`
- [ ] `docs/ROADMAP.md`
- [ ] `docs/CLIENT_AUDIT_GUIDE.md`
- [ ] `docs/CLIENT_HANDOFF_CHECKLIST.md`
- [ ] `docs/RELEASE_CHECKLIST.md`
- [ ] `CHANGELOG.md`

## Security / secrets checked

- [ ] No hardcoded webhook URLs, passwords, tokens, or secrets
- [ ] Webhook URLs use `$env:QUESTOPS_DISCORD_WEBHOOK_URL` only
- [ ] No `.env`, `*.local.json`, `reports/*`, `logs/*` committed
- [ ] No generated or build artifacts included
