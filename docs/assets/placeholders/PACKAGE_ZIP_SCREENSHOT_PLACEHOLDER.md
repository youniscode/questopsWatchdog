# Package Zip Screenshot — Placeholder

## Intended image name

`screenshot-package-zip-v0.4.14.png`

## Purpose

Show what the client-ready audit package looks like when extracted. Used in documentation to illustrate the tool package structure.

## What the screenshot should show

A file explorer window or zip archive viewer showing the contents of the exported client package:

- Top-level files: `VERSION`, `CHANGELOG.md`, `README.md`
- `docs/` folder with subdirectories
- `scripts/` folder with `.ps1` files
- `config/` folder with `.json` files
- No generated reports, logs, or local configs visible

## Data requirements

- Must show client package contents only
- Must not show generated reports, HTML/manifest files, or local configs
- File list should match exactly what `export_questops_audit_package.ps1` includes
- Use fictional zip name: `questops-watchdog-audit-package-20260526-120000.zip`

## Suggested alt text

"QuestOps Watchdog client audit package zip contents showing VERSION, CHANGELOG, README, docs, scripts, and config folders."
