# QuestOps Watchdog — Release Asset Checklist

## Required release assets

- [ ] GitHub release draft is ready (see GITHUB_RELEASE_DRAFT_v0.4.19.md)
- [ ] Tag v0.4.19 exists on GitHub
- [ ] VERSION file reads `0.4.19` in the repository
- [ ] CHANGELOG.md contains all entries since the last release
- [ ] Client tool package exported and verified (53 files, safety scan passes)
- [ ] SHA256 checksum of the tool package is calculated and ready to attach
- [ ] Release notes are complete and accurate

## Optional screenshots

Screenshots can be uploaded as GitHub release assets once captured and redacted:
- `screenshot-readme-hero-v0.4.19.png` — PowerShell scan output showing healthy servers
- `screenshot-html-report-v0.4.19.png` — HTML report in browser
- `screenshot-discord-alert-v0.4.19.png` — Discord alert message
- `screenshot-powershell-scan-v0.4.19.png` — terminal with scan in progress

Screenshot placeholders exist in `docs/assets/placeholders/` — review them before capturing real images.

## What files can be attached to the GitHub release

- The client tool package zip (`questops-watchdog-audit-package-*.zip`)
- Its `.sha256` checksum file
- Real screenshots (once captured, reviewed, and redacted)
- The release notes (`docs/RELEASE_NOTES_v0.4.19.md`)

## What files must never be attached

- `docs/launch/` files — internal outreach workflow
- `docs/release/` files — internal release preparation
- `docs/RELEASE_CHECKLIST.md` — internal pre-release checklist
- `docs/qa/` files — internal quality assurance docs
- Any file containing a real Discord webhook URL, password, token, or secret
- Any generated reports (`reports/*.json`, `reports/*.html`)
- Any log files (`logs/*.log`)
- Any local config files (`config/*.local.json`, `config/*private*.json`, `config/*secret*.json`)
- Any `.env`, `.env.*` files
- The build output directory (`dist/`, `out/`, `release/`)
- `.git/` directory or any `.git*` metadata files
- GitHub-facing files already in the repository (SECURITY.md, CONTRIBUTING.md, LICENSE-NOTE.md — they are visible on GitHub without being attached)

## Package checksum notes

- Generate SHA256 checksum alongside the package zip
- Use PowerShell:
  ```powershell
  Get-FileHash -Path dist\questops-watchdog-audit-package-*.zip -Algorithm SHA256 | Select-Object Hash, Path
  ```
- Save the checksum to a `.sha256` file with the same base name as the zip
- End users can verify by running:
  ```powershell
  Get-FileHash -Path downloaded-file.zip -Algorithm SHA256
  ```
  and comparing to the published checksum

## How to verify zip contents

```powershell
$zip = Get-ChildItem dist -Filter "questops-watchdog-audit-package-*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Add-Type -AssemblyName System.IO.Compression.FileSystem
$entries = [System.IO.Compression.ZipFile]::OpenRead($zip.FullName).Entries
$entries.Count  # Should be 53
$entries | Select-Object FullName  # Inspect all paths
```

## How to verify no generated reports/logs/local configs are included

```powershell
$entries | Where-Object {
    $_.FullName -match 'latest-health-report\.json|latest-health-report\.html|manual-audit-report\.html|audit-results-manifest\.json|release-manifest\.json|\.env|servers\.local\.json|servers\.private\.json|servers\.secret\.json|logs/.+\.log|state/.+'
} | Select-Object FullName
```
Expected: no results (empty output).
