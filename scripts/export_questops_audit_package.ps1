<#
.SYNOPSIS
    Creates a clean, client-ready audit package zip of QuestOps Watchdog.
.DESCRIPTION
    Archives only safe, client-facing files into a zip under dist\.
    Runs a preflight safety scan to detect hardcoded secrets before packaging.
    Excludes .git, .env, local configs, reports, logs, state, and development files.
.PARAMETER OutputDir
    Directory for the zip output. Default: dist
.PARAMETER PackageName
    Optional custom zip file name (without .zip extension) or full name.
    Default: questops-watchdog-audit-package-YYYYMMDD-HHMMSS.zip
.PARAMETER Force
    Overwrite existing package file if it exists.
.EXAMPLE
    .\export_questops_audit_package.ps1
    .\export_questops_audit_package.ps1 -Force
    .\export_questops_audit_package.ps1 -PackageName "my-custom-package" -Force
.OUTPUTS
    [PSCustomObject] with fields: success, exit_code, package_path, included_count
#>

[CmdletBinding()]
param(
    [string]$OutputDir = "dist",
    [string]$PackageName = "",
    [switch]$Force
)

$ScriptDir = Split-Path -Parent -Path $PSCommandPath
$ProjectRoot = Split-Path -Parent -Path $ScriptDir

if (-not $PackageName) {
    $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
    $PackageName = "questops-watchdog-audit-package-$timestamp.zip"
}
if (-not $PackageName.EndsWith(".zip")) {
    $PackageName = "$PackageName.zip"
}

$outputDirPath = Join-Path -Path $ProjectRoot -ChildPath $OutputDir
if (-not (Test-Path -LiteralPath $outputDirPath)) {
    New-Item -ItemType Directory -Path $outputDirPath -Force | Out-Null
}

$packagePath = Join-Path -Path $outputDirPath -ChildPath $PackageName

if (Test-Path -LiteralPath $packagePath) {
    if (-not $Force) {
        Write-Warning "Package already exists: $packagePath. Use -Force to overwrite."
        Write-Output ([PSCustomObject]@{ success = $false; exit_code = 1; package_path = $packagePath; included_count = 0 })
        exit 1
    }
    Remove-Item -LiteralPath $packagePath -Force
}

$includeRelative = @(
    "VERSION",
    "CHANGELOG.md",
    "README.md",
    "docs\PROJECTMAP.md",
    "docs\ROADMAP.md",
    "docs\AGENT_RULES.md",
    "docs\TASKS.md",
    "docs\CLIENT_AUDIT_GUIDE.md",
    "docs\CLIENT_HANDOFF_CHECKLIST.md",
    "docs\RELEASE_NOTES_v0.4.8.md",
    "scripts\questops_scan.ps1",
    "scripts\questops_run.ps1",
    "scripts\questops_discord_alert.ps1",
    "scripts\validate_questops_config.ps1",
    "scripts\install_questops_task.ps1",
    "scripts\uninstall_questops_task.ps1",
    "scripts\export_questops_audit_package.ps1",
    "scripts\export_questops_html_report.ps1",
    "scripts\export_questops_audit_results.ps1",
    "config\servers.example.json",
    "config\servers.game.example.json",
    "reports\.gitkeep",
    "reports\history\.gitkeep",
    "logs\.gitkeep",
    "state\.gitkeep"
)

$includePaths = @()
$missingFiles = @()

foreach ($rel in $includeRelative) {
    $fullPath = Join-Path -Path $ProjectRoot -ChildPath $rel
    if (Test-Path -LiteralPath $fullPath -PathType Leaf) {
        $includePaths += $fullPath
    } else {
        $missingFiles += $rel
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Warning "Required files missing:"
    $missingFiles | ForEach-Object { Write-Warning "  - $_" }
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 2; package_path = $packagePath; included_count = 0 })
    exit 2
}

# Safety scan: check included text files for hardcoded secrets
Write-Verbose "Running preflight safety scan..."
$safetyFailures = @()
$textExtensions = @(".ps1", ".md", ".json")

foreach ($path in $includePaths) {
    $ext = [System.IO.Path]::GetExtension($path)
    if ($ext -notin $textExtensions) { continue }

    $content = Get-Content -LiteralPath $path -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }

    # Check for Discord webhook URLs with actual IDs (allow doc placeholder patterns)
    if ($content -match 'discord\.com/api/webhooks/[a-zA-Z0-9_/-]+' -and
        $content -notmatch 'YOUR_WEBHOOK_ID' -and
        $content -notmatch 'your_webhook') {
        $relPath = $path.Substring($ProjectRoot.Length + 1)
        $safetyFailures += "Discord webhook URL detected in: $relPath"
    }
}

if ($safetyFailures.Count -gt 0) {
    Write-Warning "SAFETY SCAN FAILED - secrets detected in package files:"
    $safetyFailures | ForEach-Object { Write-Warning "  $_" }
    Write-Warning "Fix the reported files before packaging."
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; package_path = $packagePath; included_count = 0 })
    exit 3
}

# Create zip package
Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
Add-Type -AssemblyName System.IO.Compression -ErrorAction Stop

try {
    $zipStream = [System.IO.Compression.ZipFile]::Open($packagePath, [System.IO.Compression.ZipArchiveMode]::Create)
    foreach ($path in $includePaths) {
        $relPath = $path.Substring($ProjectRoot.Length + 1)
        $entryName = $relPath -replace '\\', '/'
        $null = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zipStream, $path, $entryName, [System.IO.Compression.CompressionLevel]::Optimal)
    }
} catch {
    Write-Warning "Package creation failed: $_"
    if ($zipStream) { $zipStream.Dispose() }
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 1; package_path = $packagePath; included_count = $includePaths.Count })
    exit 1
} finally {
    if ($zipStream) { $zipStream.Dispose() }
}

Write-Host "Package created: $packagePath"
Write-Host "Files included: $($includePaths.Count)"

Write-Output ([PSCustomObject]@{
    success        = $true
    exit_code      = 0
    package_path   = $packagePath
    included_count = $includePaths.Count
})
exit 0
