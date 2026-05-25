<#
.SYNOPSIS
    Creates an audit results bundle zip of scan outputs for client review.
.DESCRIPTION
    Packages the JSON report, HTML report, and optional config/log into a
    clean zip under dist\ for sending back for a paid/manual audit.
    Automatically generates the HTML report if missing.
    Runs a safety scan before packaging.
    This is different from export_questops_audit_package.ps1
    (which packages the tool to send to a client).
.PARAMETER ReportPath
    Path to the JSON scan report (default: reports\latest-health-report.json).
.PARAMETER HtmlPath
    Path to the HTML audit report (default: reports\latest-health-report.html).
.PARAMETER OutputDir
    Directory for the zip output (default: dist).
.PARAMETER PackageName
    Optional custom zip file name (without .zip extension) or full name.
    Default: questops-watchdog-audit-results-YYYYMMDD-HHMMSS.zip.
.PARAMETER Force
    Overwrite existing package file if it exists.
.PARAMETER RefreshHtml
    Regenerate the HTML report even if it already exists.
.PARAMETER NoGenerateHtml
    Do not generate HTML if missing; fail with exit 2 instead.
.PARAMETER IncludeConfig
    Include config\servers.local.json in the package (safety-scanned).
.PARAMETER ConfigPath
    Path to config file to include (default: config\servers.local.json).
.PARAMETER IncludeLog
    Include logs\questops-run.log in the package (safety-scanned).
.PARAMETER LogPath
    Path to log file to include (default: logs\questops-run.log).
.EXAMPLE
    .\export_questops_audit_results.ps1
    .\export_questops_audit_results.ps1 -Force
    .\export_questops_audit_results.ps1 -IncludeConfig -IncludeLog -Force
    .\export_questops_audit_results.ps1 -RefreshHtml -Force
.OUTPUTS
    [PSCustomObject] with fields: success, exit_code, package_path, warnings
#>

[CmdletBinding()]
param(
    [string]$ReportPath = "",
    [string]$HtmlPath = "",
    [string]$OutputDir = "dist",
    [string]$PackageName = "",
    [switch]$Force,
    [switch]$RefreshHtml,
    [switch]$NoGenerateHtml,
    [switch]$IncludeConfig,
    [string]$ConfigPath = "",
    [switch]$IncludeLog,
    [string]$LogPath = ""
)

$ScriptDir = Split-Path -Parent -Path $PSCommandPath
$ProjectRoot = Split-Path -Parent -Path $ScriptDir

# Default paths
if (-not $ReportPath) {
    $ReportPath = Join-Path -Path $ProjectRoot -ChildPath "reports\latest-health-report.json"
}
if (-not $HtmlPath) {
    $HtmlPath = Join-Path -Path $ProjectRoot -ChildPath "reports\latest-health-report.html"
}
if (-not $ConfigPath) {
    $ConfigPath = Join-Path -Path $ProjectRoot -ChildPath "config\servers.local.json"
}
if (-not $LogPath) {
    $LogPath = Join-Path -Path $ProjectRoot -ChildPath "logs\questops-run.log"
}

# Validate output directory
$outputDirPath = Join-Path -Path $ProjectRoot -ChildPath $OutputDir
try {
    if (-not (Test-Path -LiteralPath $outputDirPath)) {
        New-Item -ItemType Directory -Path $outputDirPath -Force -ErrorAction Stop | Out-Null
    }
} catch {
    Write-Warning "Invalid output path: $OutputDir"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 4; package_path = ""; warnings = @() })
    exit 4
}

# Package name
if (-not $PackageName) {
    $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
    $PackageName = "questops-watchdog-audit-results-$timestamp.zip"
}
if (-not $PackageName.EndsWith(".zip")) {
    $PackageName = "$PackageName.zip"
}

$packagePath = Join-Path -Path $outputDirPath -ChildPath $PackageName

if (Test-Path -LiteralPath $packagePath) {
    if (-not $Force) {
        Write-Warning "Package already exists: $packagePath. Use -Force to overwrite."
        Write-Output ([PSCustomObject]@{ success = $false; exit_code = 1; package_path = $packagePath; warnings = @() })
        exit 1
    }
    Remove-Item -LiteralPath $packagePath -Force
}

# Collect warnings
$warnings = @()

# Step 1: Check report exists
if (-not (Test-Path -LiteralPath $ReportPath -PathType Leaf)) {
    Write-Warning "Report file not found: $ReportPath"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 2; package_path = ""; warnings = $warnings })
    exit 2
}

# Step 2: Check / generate HTML report
$htmlExists = Test-Path -LiteralPath $HtmlPath -PathType Leaf

if ($NoGenerateHtml) {
    if (-not $htmlExists) {
        Write-Warning "HTML report not found and -NoGenerateHtml specified: $HtmlPath"
        Write-Output ([PSCustomObject]@{ success = $false; exit_code = 2; package_path = ""; warnings = $warnings })
        exit 2
    }
} else {
    $shouldGenerate = $RefreshHtml -or (-not $htmlExists)
    if ($shouldGenerate) {
        Write-Verbose "Generating HTML report from: $ReportPath"
        $htmlScript = Join-Path -Path $ScriptDir -ChildPath "export_questops_html_report.ps1"
        if (-not (Test-Path -LiteralPath $htmlScript -PathType Leaf)) {
            Write-Warning "HTML export script not found: $htmlScript"
            Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; package_path = ""; warnings = $warnings })
            exit 3
        }
        & $htmlScript -ReportPath $ReportPath -OutputPath $HtmlPath
        $htmlExit = $LASTEXITCODE
        if ($htmlExit -ne 0) {
            Write-Warning "HTML report generation failed (exit code: $htmlExit)"
            Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; package_path = ""; warnings = $warnings })
            exit 3
        }
        if ($RefreshHtml) {
            $warnings += "HTML report regenerated (-RefreshHtml)"
        }
    }
}

# Verify HTML exists now
if (-not (Test-Path -LiteralPath $HtmlPath -PathType Leaf)) {
    Write-Warning "HTML report not found: $HtmlPath"
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 2; package_path = ""; warnings = $warnings })
    exit 2
}

# Step 3: Build include list
$includeEntries = @()

$includeEntries += @{ Path = $ReportPath; Label = "report" }
$includeEntries += @{ Path = $HtmlPath; Label = "html" }

if ($IncludeConfig) {
    if (Test-Path -LiteralPath $ConfigPath -PathType Leaf) {
        $includeEntries += @{ Path = $ConfigPath; Label = "config" }
    } else {
        $warnings += "Config file not found, skipping: $ConfigPath"
    }
}

if ($IncludeLog) {
    if (Test-Path -LiteralPath $LogPath -PathType Leaf) {
        $includeEntries += @{ Path = $LogPath; Label = "log" }
    } else {
        $warnings += "Log file not found, skipping: $LogPath"
    }
}

# Step 4: Safety scan
Write-Verbose "Running safety scan..."
$safetyFailures = @()

$safetyPatterns = @(
    @{ Pattern = 'discord\.com/api/webhooks'; Category = "Discord webhook URL" }
    @{ Pattern = 'QUESTOPS_DISCORD_WEBHOOK_URL='; Category = "Discord webhook environment variable" }
    @{ Pattern = '"password"'; Category = "Possible password" }
    @{ Pattern = '"token"'; Category = "Possible token" }
    @{ Pattern = '"secret"'; Category = "Possible secret" }
)

foreach ($entry in $includeEntries) {
    $filePath = $entry.Path
    $content = Get-Content -LiteralPath $filePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }

    foreach ($sp in $safetyPatterns) {
        if ($content -match $sp.Pattern) {
            if ($filePath.Length -gt $ProjectRoot.Length) {
                $relPath = $filePath.Substring($ProjectRoot.Length + 1)
            } else {
                $relPath = [System.IO.Path]::GetFileName($filePath)
            }
            $safetyFailures += "$relPath -- $($sp.Category)"
        }
    }
}

if ($safetyFailures.Count -gt 0) {
    Write-Warning "SAFETY SCAN FAILED:"
    foreach ($f in $safetyFailures) {
        Write-Warning "  $f"
    }
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 3; package_path = ""; warnings = $warnings })
    exit 3
}

# Step 5: Create zip package
Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
Add-Type -AssemblyName System.IO.Compression -ErrorAction Stop

$zipStream = $null
try {
    $zipStream = [System.IO.Compression.ZipFile]::Open($packagePath, [System.IO.Compression.ZipArchiveMode]::Create)

    # Add each file to zip
    foreach ($entry in $includeEntries) {
        $filePath = $entry.Path
        if ($filePath.Length -gt $ProjectRoot.Length) {
            $relPath = $filePath.Substring($ProjectRoot.Length + 1)
        } else {
            $relPath = [System.IO.Path]::GetFileName($filePath)
        }
        $entryName = $relPath -replace '\\', '/'
        $null = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zipStream, $filePath, $entryName, [System.IO.Compression.CompressionLevel]::Optimal)
    }

    # Build manifest
    $manifestFileList = @()
    foreach ($entry in $includeEntries) {
        $fp = $entry.Path
        if ($fp.Length -gt $ProjectRoot.Length) {
            $manifestFileList += ($fp.Substring($ProjectRoot.Length + 1) -replace '\\', '/')
        } else {
            $manifestFileList += [System.IO.Path]::GetFileName($fp)
        }
    }

    $manifestObj = @{
        generated_at_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss UTC")
        source_report    = $manifestFileList[0]
        source_html      = $manifestFileList[1]
        included_config  = ($IncludeConfig -and (Test-Path -LiteralPath $ConfigPath -PathType Leaf))
        included_log     = ($IncludeLog -and (Test-Path -LiteralPath $LogPath -PathType Leaf))
        files_included   = $manifestFileList
        warnings         = $warnings
        product          = "QuestOps Watchdog"
        package_type     = "audit-results"
    }

    # ConvertTo-Json default depth is 2 - sufficient for this flat structure
    $manifestJson = $manifestObj | ConvertTo-Json

    # Add manifest entry directly to zip (no temp file)
    $manifestEntry = $zipStream.CreateEntry("audit-results-manifest.json")
    $manifestWriter = New-Object System.IO.StreamWriter($manifestEntry.Open())
    $manifestWriter.Write($manifestJson)
    $manifestWriter.Close()

} catch {
    Write-Warning "Package creation failed: $_"
    if ($zipStream) { $zipStream.Dispose() }
    Write-Output ([PSCustomObject]@{ success = $false; exit_code = 1; package_path = $packagePath; warnings = $warnings })
    exit 1
} finally {
    if ($zipStream) { $zipStream.Dispose() }
}

Write-Host "Audit results package created: $packagePath"
Write-Host "Files included: $($includeEntries.Count)"

Write-Output ([PSCustomObject]@{
    success      = $true
    exit_code    = 0
    package_path = $packagePath
    warnings     = $warnings
})
exit 0
