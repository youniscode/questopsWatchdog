<#
.SYNOPSIS
    Creates a repeatable local release build under dist\.
.DESCRIPTION
    Runs config validation, safe scan, HTML export, tool package export,
    and audit results bundle export, then gathers outputs with checksums
    and a release manifest into a versioned release folder.
    Does not commit or tag — those steps remain manual.
.PARAMETER Version
    Version string (default: read from VERSION file in project root).
.PARAMETER OutputDir
    Directory for release output (default: dist).
.PARAMETER Force
    Overwrite existing release folder if it exists.
.PARAMETER AllowDirty
    Allow release build when git working tree has uncommitted changes.
.EXAMPLE
    .\build_questops_client_release.ps1
    .\build_questops_client_release.ps1 -AllowDirty -Force
    .\build_questops_client_release.ps1 -Version "0.4.8" -Force
.OUTPUTS
    [PSCustomObject] with fields: success, exit_code, release_path, warnings
#>

[CmdletBinding()]
param(
    [string]$Version = "",
    [string]$OutputDir = "dist",
    [switch]$Force,
    [switch]$AllowDirty
)

$ScriptDir = Split-Path -Parent -Path $PSCommandPath
$ProjectRoot = Split-Path -Parent -Path $ScriptDir

# Collect warnings
$warnings = @()

# Step 1: Resolve version
if (-not $Version) {
    $versionFile = Join-Path -Path $ProjectRoot -ChildPath "VERSION"
    if (-not (Test-Path -LiteralPath $versionFile -PathType Leaf)) {
        Write-Warning "VERSION file not found: $versionFile"
        Write-Output ([PSCustomObject]@{ success = $false; exit_code = 2; release_path = ""; warnings = $warnings })
        exit 2
    }
    $Version = (Get-Content -LiteralPath $versionFile -Raw -ErrorAction Stop).Trim()
}

if (-not $Version) {
    Write-Warning "Version is empty"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 1; release_path = ""; warnings = $warnings })
    exit 1
}

Write-Host "Building release: v$Version"

# Step 2: Check git status
$gitDirty = $false
$gitBranch = ""
$gitCommit = ""

try {
    $gitBranch = & git -C $ProjectRoot rev-parse --abbrev-ref HEAD 2>$null
    if ($LASTEXITCODE -eq 0) {
        $gitCommit = & git -C $ProjectRoot rev-parse --short HEAD 2>$null
        $gitStatus = & git -C $ProjectRoot status --porcelain 2>$null
        if ($gitStatus) {
            $gitDirty = $true
        }
    }
} catch {
    $warnings += "Git not available: skipping branch/commit detection"
}

if ($gitDirty -and (-not $AllowDirty)) {
    Write-Warning "Git working tree has uncommitted changes. Use -AllowDirty to proceed."
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 4; release_path = ""; warnings = $warnings })
    exit 4
}

if ($gitDirty) {
    $warnings += "Git working tree is dirty (-AllowDirty used)"
}

# Step 3: Set up release folder
$outputDirPath = Join-Path -Path $ProjectRoot -ChildPath $OutputDir
$releaseDir = "questops-watchdog-v$Version"
$releasePath = Join-Path -Path $outputDirPath -ChildPath $releaseDir

if (Test-Path -LiteralPath $releasePath) {
    if (-not $Force) {
        Write-Warning "Release folder already exists: $releasePath. Use -Force to overwrite."
        Write-Output ([PSCustomObject]@{ success = $false; exit_code = 1; release_path = ""; warnings = $warnings })
        exit 1
    }
    Remove-Item -LiteralPath $releasePath -Recurse -Force
}

New-Item -ItemType Directory -Path $releasePath -Force | Out-Null

# Step 4: Run validation steps

# 4a: Config validation
Write-Host "Running config validation..."
$validateScript = Join-Path -Path $ScriptDir -ChildPath "validate_questops_config.ps1"
& $validateScript
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Config validation failed (exit code: $LASTEXITCODE)"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; release_path = ""; warnings = $warnings })
    exit 3
}

# 4b: Safe scan
Write-Host "Running safe scan..."
$runScript = Join-Path -Path $ScriptDir -ChildPath "questops_run.ps1"
& $runScript -NoAlert
$scanExit = $LASTEXITCODE
if ($scanExit -ge 2) {
    Write-Warning "Safe scan failed with exit code: $scanExit"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; release_path = ""; warnings = $warnings })
    exit 3
}

# 4c: Export HTML
Write-Host "Exporting HTML report..."
$htmlScript = Join-Path -Path $ScriptDir -ChildPath "export_questops_html_report.ps1"
& $htmlScript
if ($LASTEXITCODE -ne 0) {
    Write-Warning "HTML export failed (exit code: $LASTEXITCODE)"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; release_path = ""; warnings = $warnings })
    exit 3
}

# 4d: Export client tool package
Write-Host "Exporting client tool package..."
$packageScript = Join-Path -Path $ScriptDir -ChildPath "export_questops_audit_package.ps1"
& $packageScript -Force
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Tool package export failed (exit code: $LASTEXITCODE)"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; release_path = ""; warnings = $warnings })
    exit 3
}

# 4e: Export audit results bundle
Write-Host "Exporting audit results bundle..."
$resultsScript = Join-Path -Path $ScriptDir -ChildPath "export_questops_audit_results.ps1"
& $resultsScript -Force
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Audit results export failed (exit code: $LASTEXITCODE)"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; release_path = ""; warnings = $warnings })
    exit 3
}

# Step 5: Copy packages and generate checksums
$packageZip = $null
$resultsZip = $null

# Find latest tool package
$latestPackage = Get-ChildItem -Path $outputDirPath -Filter "questops-watchdog-audit-package-*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($latestPackage) {
    $destPackage = Join-Path -Path $releasePath -ChildPath $latestPackage.Name
    Copy-Item -LiteralPath $latestPackage.FullName -Destination $destPackage -Force
    $packageZip = $latestPackage.Name

    # Generate SHA256 checksum
    $packageHash = Get-FileHash -LiteralPath $destPackage -Algorithm SHA256
    $packageHashFile = Join-Path -Path $releasePath -ChildPath "$($latestPackage.Name).sha256"
    Set-Content -Path $packageHashFile -Value "$($packageHash.Hash)  $($latestPackage.Name)" -Force
} else {
    $warnings += "No tool package found to copy"
}

# Find latest results bundle
$latestResults = Get-ChildItem -Path $outputDirPath -Filter "questops-watchdog-audit-results-*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($latestResults) {
    $destResults = Join-Path -Path $releasePath -ChildPath $latestResults.Name
    Copy-Item -LiteralPath $latestResults.FullName -Destination $destResults -Force
    $resultsZip = $latestResults.Name

    # Generate SHA256 checksum
    $resultsHash = Get-FileHash -LiteralPath $destResults -Algorithm SHA256
    $resultsHashFile = Join-Path -Path $releasePath -ChildPath "$($latestResults.Name).sha256"
    Set-Content -Path $resultsHashFile -Value "$($resultsHash.Hash)  $($latestResults.Name)" -Force
} else {
    $warnings += "No audit results bundle found to copy"
}

# Step 6: Write release manifest
$manifestObj = @{
    product           = "QuestOps Watchdog"
    version           = $Version
    generated_at_utc  = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss UTC")
    package_zip       = $packageZip
    package_sha256    = if ($packageHash) { $packageHash.Hash } else { $null }
    audit_results_zip = $resultsZip
    audit_results_sha256 = if ($resultsHash) { $resultsHash.Hash } else { $null }
    git_branch        = $gitBranch
    git_commit        = $gitCommit
    git_dirty         = $gitDirty
    warnings          = $warnings
}

$manifestPath = Join-Path -Path $releasePath -ChildPath "release-manifest.json"
$manifestObj | ConvertTo-Json | Set-Content -Path $manifestPath -Force

Write-Host ""
Write-Host "Release build completed: $releasePath"
Write-Host "Package: $($packageZip)"
Write-Host "Audit results: $($resultsZip)"
if ($packageHash) { Write-Host "Package SHA256: $($packageHash.Hash)" }
if ($resultsHash) { Write-Host "Results SHA256: $($resultsHash.Hash)" }

Write-Output ([PSCustomObject]@{
    success      = $true
    exit_code    = 0
    release_path = $releasePath
    warnings     = $warnings
})
exit 0
