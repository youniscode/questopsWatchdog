# QuestOps Watchdog — Release Checklist

Use this checklist when preparing a new release.

---

## Pre-release checks

- [ ] `VERSION` file contains the correct version number
- [ ] `CHANGELOG.md` has an entry for the new version
- [ ] `docs/RELEASE_NOTES_v*.md` exists and is up to date
- [ ] All doc version references (README, PROJECTMAP, ROADMAP, TASKS) are updated
- [ ] Client package file counts are consistent everywhere (41 for v0.4.12)

## Validation commands

Run each and confirm exit code 0:

```powershell
# Config validation
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1

# Safe scan
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert

# HTML export
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1
```

## Package export checks

```powershell
# Client tool package
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_package.ps1 -Force

# Audit results bundle
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1 -Force

# Full release build (runs all of the above plus checksums)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build_questops_client_release.ps1 -AllowDirty -Force
```

## Secret / file exclusion checks

```powershell
$toolZip = Get-ChildItem dist -Filter "questops-watchdog-audit-package-*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Confirm file count
$entries = [System.IO.Compression.ZipFile]::OpenRead($toolZip.FullName).Entries
$entries.Count

# Confirm no generated reports
$entries | Where-Object {
    $_.FullName -match 'latest-health-report\.json|latest-health-report\.html|manual-audit-report\.html|audit-results-manifest\.json|release-manifest\.json'
} | Select-Object FullName

# Confirm version/release notes/docs/demo/website docs present
$entries | Where-Object {
    $_.FullName -match '^VERSION$|^CHANGELOG\.md$|docs/RELEASE_NOTES_v0\.4\.9\.md|docs/business/|docs/demo/|docs/assets/README\.md|docs/website/'
} | Select-Object FullName
```

Expected:
- File count = 41
- Generated reports: empty
- Version/release notes/docs/demo/website docs: 19 results

## Checksum generation

After release build, verify checksums:

```powershell
Get-ChildItem dist\questops-watchdog-v0.4.9 -Filter *.sha256 | ForEach-Object {
    Get-Content $_.FullName
}
```

## Git commands (run manually after validation)

```powershell
# Stage all changes
git add -A

# Commit
git commit -m "v0.4.9 - Paid audit offer kit and landing copy"

# Tag
git tag -a v0.4.9 -m "QuestOps Watchdog v0.4.9 - Paid audit offer kit and landing copy"

# Push
git push origin main --tags
```

## Rollback notes

If a release needs to be rolled back:

1. Revert the commit: `git revert HEAD`
2. Delete the tag locally: `git tag -d v0.4.9`
3. Delete the tag remotely: `git push origin :refs/tags/v0.4.9`
4. Delete the release folder: `Remove-Item -Recurse -Force dist\questops-watchdog-v0.4.9`
5. Update `VERSION` back to the previous version
6. Re-run the release build
