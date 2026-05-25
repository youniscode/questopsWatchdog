<#
.SYNOPSIS
    Validates the structure of a QuestOps Watchdog server config file.
.DESCRIPTION
    Checks JSON syntax, required fields, field types, and value ranges.
    Does NOT check runtime availability (folder existence, process running, port reachability).
    Exit codes: 0 = valid, 2 = file not found, 3 = invalid JSON or structure error.
.PARAMETER ConfigPath
    Path to the server config JSON file. Defaults to ..\config\servers.example.json.
.EXAMPLE
    .\validate_questops_config.ps1
    .\validate_questops_config.ps1 -ConfigPath config\servers.game.example.json
.OUTPUTS
    [PSCustomObject] with fields: valid, errors, warnings, server_count, servers_valid, servers_invalid, exit_code
#>

[CmdletBinding()]
param(
    [string]$ConfigPath
)

function Resolve-QuestValidatePath {
    param([string]$Path)
    $resolved = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    if (-not (Test-Path -LiteralPath $resolved -PathType Leaf)) {
        return $null
    }
    return $resolved
}

function Read-QuestValidateConfig {
    param([string]$Path)
    try {
        $content = Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
        $parsed = $content | ConvertFrom-Json -ErrorAction Stop
        return [PSCustomObject]@{ success = $true; data = $parsed }
    } catch {
        return [PSCustomObject]@{ success = $false; error = $_.Exception.Message }
    }
}

if (-not $ConfigPath) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $ConfigPath = Join-Path -Path $scriptDir -ChildPath "..\config\servers.example.json"
}

$errors = @()
$warnings = @()
$resolvedPath = Resolve-QuestValidatePath -Path $ConfigPath

if ($null -eq $resolvedPath) {
    $unresolved = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ConfigPath)
    $report = [PSCustomObject]@{
        valid = $false
        errors = @("Config file not found: $unresolved")
        warnings = @()
        server_count = 0
        servers_valid = 0
        servers_invalid = 0
        exit_code = 2
    }
    Write-Output $report
    exit 2
}

$jsonResult = Read-QuestValidateConfig -Path $resolvedPath
if (-not $jsonResult.success) {
    $report = [PSCustomObject]@{
        valid = $false
        errors = @("Invalid JSON: $($jsonResult.error)")
        warnings = @()
        server_count = 0
        servers_valid = 0
        servers_invalid = 0
        exit_code = 3
    }
    Write-Output $report
    exit 3
}

$config = $jsonResult.data

if ($config -isnot [System.Array]) {
    $report = [PSCustomObject]@{
        valid = $false
        errors = @("Config must be a JSON array of server objects")
        warnings = @()
        server_count = 0
        servers_valid = 0
        servers_invalid = 0
        exit_code = 3
    }
    Write-Output $report
    exit 3
}

$serverCount = $config.Count
$validCount = 0
$invalidCount = 0
$requiredFields = @("name", "folder", "process", "disk_threshold_gb")

foreach ($server in $config) {
    $serverErrors = @()
    $serverName = ""

    if ($null -eq $server -or $server -isnot [PSCustomObject]) {
        $errors += "Server entry is not an object"
        $invalidCount++
        continue
    }

    foreach ($field in $requiredFields) {
        if (-not ($server.PSObject.Properties.Name -contains $field)) {
            $serverErrors += "Missing required field: '$field'"
        }
    }

    if ($server.PSObject.Properties.Name -contains "name") {
        $serverName = [string]$server.name
    } else {
        $serverName = "(unnamed)"
    }

    if ($server.PSObject.Properties.Name -contains "disk_threshold_gb") {
        $dt = $server.disk_threshold_gb
        if ($dt -isnot [int] -and $dt -isnot [double]) {
            $serverErrors += "'disk_threshold_gb' must be a number (got $($dt.GetType().Name))"
        } elseif ($dt -lt 0) {
            $serverErrors += "'disk_threshold_gb' must be >= 0 (got $dt)"
        }
    }

    if ($server.PSObject.Properties.Name -contains "folder") {
        if ([string]::IsNullOrEmpty("$($server.folder)")) {
            $serverErrors += "'folder' must be a non-empty string"
        }
    }

    if ($server.PSObject.Properties.Name -contains "process") {
        if ([string]::IsNullOrEmpty("$($server.process)")) {
            $serverErrors += "'process' must be a non-empty string"
        }
    }

    if ($server.PSObject.Properties.Name -contains "network_checks") {
        $nc = $server.network_checks
        if ($nc -isnot [System.Array]) {
            $serverErrors += "'network_checks' must be an array"
        } else {
            foreach ($check in $nc) {
                $checkName = ""
                if ($check.PSObject.Properties.Name -contains "name" -and -not [string]::IsNullOrEmpty("$($check.name)")) {
                    $checkName = " '$($check.name)'"
                }
                if (-not ($check.PSObject.Properties.Name -contains "name") -or [string]::IsNullOrEmpty("$($check.name)")) {
                    $serverErrors += "network_checks entry missing 'name'"
                }
                if (-not ($check.PSObject.Properties.Name -contains "host") -or [string]::IsNullOrEmpty("$($check.host)")) {
                    $serverErrors += "network_checks entry$checkName missing 'host'"
                }
                if ($check.PSObject.Properties.Name -contains "port") {
                    $p = $check.port
                    if ($p -isnot [int]) {
                        $serverErrors += "network_checks entry$checkName 'port' must be an integer (got $($p.GetType().Name))"
                    } elseif ($p -lt 1 -or $p -gt 65535) {
                        $serverErrors += "network_checks entry$checkName 'port' must be 1-65535 (got $p)"
                    }
                } else {
                    $serverErrors += "network_checks entry$checkName missing 'port'"
                }
                if ($check.PSObject.Properties.Name -contains "timeout_ms") {
                    $t = $check.timeout_ms
                    if ($t -isnot [int]) {
                        $serverErrors += "network_checks entry$checkName 'timeout_ms' must be an integer (got $($t.GetType().Name))"
                    } elseif ($t -le 0) {
                        $serverErrors += "network_checks entry$checkName 'timeout_ms' must be > 0 (got $t)"
                    }
                }
            }
        }
    }

    if ($server.PSObject.Properties.Name -contains "log_checks") {
        $lc = $server.log_checks
        if ($lc -isnot [System.Array]) {
            $serverErrors += "'log_checks' must be an array"
        } else {
            foreach ($check in $lc) {
                $checkName = ""
                if ($check.PSObject.Properties.Name -contains "name" -and -not [string]::IsNullOrEmpty("$($check.name)")) {
                    $checkName = " '$($check.name)'"
                }
                if (-not ($check.PSObject.Properties.Name -contains "name") -or [string]::IsNullOrEmpty("$($check.name)")) {
                    $serverErrors += "log_checks entry missing 'name'"
                }
                if (-not ($check.PSObject.Properties.Name -contains "path") -or [string]::IsNullOrEmpty("$($check.path)")) {
                    $serverErrors += "log_checks entry$checkName missing 'path'"
                }
                if ($check.PSObject.Properties.Name -contains "max_age_minutes") {
                    $a = $check.max_age_minutes
                    if ($a -isnot [int]) {
                        $serverErrors += "log_checks entry$checkName 'max_age_minutes' must be an integer (got $($a.GetType().Name))"
                    } elseif ($a -le 0) {
                        $serverErrors += "log_checks entry$checkName 'max_age_minutes' must be > 0 (got $a)"
                    }
                } else {
                    $serverErrors += "log_checks entry$checkName missing 'max_age_minutes'"
                }
            }
        }
    }

    if ($server.PSObject.Properties.Name -contains "resource_checks") {
        $rc = $server.resource_checks
        if ($rc -isnot [System.Array]) {
            $serverErrors += "'resource_checks' must be an array"
        } else {
            foreach ($check in $rc) {
                $checkName = ""
                if ($check.PSObject.Properties.Name -contains "name" -and -not [string]::IsNullOrEmpty("$($check.name)")) {
                    $checkName = " '$($check.name)'"
                }
                if (-not ($check.PSObject.Properties.Name -contains "name") -or [string]::IsNullOrEmpty("$($check.name)")) {
                    $serverErrors += "resource_checks entry missing 'name'"
                }
                if (-not ($check.PSObject.Properties.Name -contains "process") -or [string]::IsNullOrEmpty("$($check.process)")) {
                    $serverErrors += "resource_checks entry$checkName missing 'process'"
                }
                if ($check.PSObject.Properties.Name -contains "max_memory_mb") {
                    $m = $check.max_memory_mb
                    if ($m -isnot [int] -and $m -isnot [double]) {
                        $serverErrors += "resource_checks entry$checkName 'max_memory_mb' must be a number (got $($m.GetType().Name))"
                    } elseif ($m -lt 0) {
                        $serverErrors += "resource_checks entry$checkName 'max_memory_mb' must be >= 0 (got $m)"
                    }
                }
                if ($check.PSObject.Properties.Name -contains "max_cpu_percent") {
                    $c = $check.max_cpu_percent
                    if ($c -isnot [int] -and $c -isnot [double]) {
                        $serverErrors += "resource_checks entry$checkName 'max_cpu_percent' must be a number (got $($c.GetType().Name))"
                    } elseif ($c -lt 0) {
                        $serverErrors += "resource_checks entry$checkName 'max_cpu_percent' must be >= 0 (got $c)"
                    }
                }
                if ($check.PSObject.Properties.Name -contains "sample_ms") {
                    $s = $check.sample_ms
                    if ($s -isnot [int]) {
                        $serverErrors += "resource_checks entry$checkName 'sample_ms' must be an integer (got $($s.GetType().Name))"
                    } elseif ($s -le 0) {
                        $serverErrors += "resource_checks entry$checkName 'sample_ms' must be > 0 (got $s)"
                    }
                }
            }
        }
    }

    if ($serverErrors.Count -gt 0) {
        $errors += "[$serverName] $($serverErrors -join '; ')"
        $invalidCount++
    } else {
        $validCount++
    }
}

$report = [PSCustomObject]@{
    valid = ($errors.Count -eq 0)
    errors = $errors
    warnings = $warnings
    server_count = $serverCount
    servers_valid = $validCount
    servers_invalid = $invalidCount
    exit_code = 0
}

Write-Output $report
if ($invalidCount -gt 0) { exit 3 }
exit 0
