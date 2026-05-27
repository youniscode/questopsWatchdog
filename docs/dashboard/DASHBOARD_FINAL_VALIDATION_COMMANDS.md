# QuestOps Watchdog — Dashboard Final Validation Commands

Copy/paste these commands into a PowerShell prompt to validate the entire dashboard feature.

PowerShell 5.1 compatible only.

## Prerequisites

```powershell
# Ensure you are in the project root
Set-Location -LiteralPath "D:\DevProjects\questops-watchdog"
```

## 1. Safe scan

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_run.ps1 -NoAlert
```

Expected: exits 0. Report written to `reports/latest-health-report.json`.

## 2. HTML audit report export

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1
```

Expected: exits 0. HTML written to `reports/latest-health-report.html`.

## 3. Dashboard export (normal)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1
```

Expected: exits 0. Dashboard written to `reports\questops-dashboard.html`.

## 4. Trend label check

```powershell
Select-String -Path reports\questops-dashboard.html -Pattern "Pass / Fail Summary|Streak &amp; Timeline|Repeated Failure Insights|timeline-pill"
```

Expected: all patterns found.

## 5. Status filter check

```powershell
Select-String -Path reports\questops-dashboard.html -Pattern "All Servers|Passing|Failing|@media print"
```

Expected: all patterns found.

## 6. No external dependency check

```powershell
Select-String -Path reports\questops-dashboard.html -Pattern "https://|http://|script src|cdn|fonts.googleapis|<script"
```

Expected: no matches found.

## 7. Missing report error page (exit 2)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -ReportPath reports\missing-report.json -OutputPath reports\missing-report-dashboard.html
Test-Path reports\missing-report-dashboard.html
```

Expected: exits 2. Error page written to custom path.

## 8. Malformed report error page (exit 3)

```powershell
Set-Content "$env:TEMP\questops-bad-report.json" -Value "not json" -Force
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -ReportPath "$env:TEMP\questops-bad-report.json" -OutputPath reports\malformed-report-dashboard.html
Test-Path reports\malformed-report-dashboard.html
```

Expected: exits 3. Error page written.

## 9. Partial report warning box (exit 0)

```powershell
$report = Get-Content reports\latest-health-report.json -Raw | ConvertFrom-Json
$report.PSObject.Properties.Remove("total_servers")
$report.PSObject.Properties.Remove("passed_checks")
$report.PSObject.Properties.Remove("failed_checks")
$json = $report | ConvertTo-Json -Depth 10
Set-Content "$env:TEMP\partial-report.json" -Value $json -Force
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_dashboard.ps1 -ReportPath "$env:TEMP\partial-report.json" -OutputPath reports\partial-report-dashboard.html
```

Expected: exits 0. Dashboard generated with warning box.

## 10. Package export

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_package.ps1 -Force
```

Expected: exits 0. Package written to `dist\questops-watchdog-audit-package-*.zip`.

## 11. Package count check

```powershell
$toolZip = Get-ChildItem dist -Filter "questops-watchdog-audit-package-*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Add-Type -AssemblyName System.IO.Compression.FileSystem
$toolEntries = [System.IO.Compression.ZipFile]::OpenRead($toolZip.FullName).Entries
$toolEntries.Count
$toolEntries.FullName -match '\.json$|\.ps1$|\.md$|\.example\.json$'
```

Expected: count = 56.

## 12. Generated reports/dashboard exclusion check

```powershell
$toolEntries | Where-Object {
    $_.FullName -match 'questops-dashboard\.html|missing-report-dashboard\.html|malformed-report-dashboard\.html|partial-report-dashboard\.html|manual-dashboard\.html|latest-health-report\.json|latest-health-report\.html|manual-audit-report\.html|audit-results-manifest\.json|release-manifest\.json'
} | Select-Object FullName
```

Expected: no results (empty output).

## 13. Internal dashboard docs exclusion check

```powershell
$toolEntries | Where-Object {
    $_.FullName -match 'docs/dashboard/'
} | Select-Object FullName
```

Expected: no results (empty output).

## 14. VERSION check

```powershell
Get-Content VERSION
```

Expected: `0.4.9`.

## 15. Git status check

```powershell
git status --short
```

Expected: only intentional changes visible. No unintended modifications.
