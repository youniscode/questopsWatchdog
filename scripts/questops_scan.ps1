<#
.SYNOPSIS
  QuestOps Watchdog - local health scan.
.DESCRIPTION
  Reads a JSON config, checks folder existence, free disk space,
  running processes, optional TCP port reachability, optional
  log file freshness, and optional process resource usage,
  then writes a JSON report and emits it to the pipeline.

  Exit codes:
    0 - all checks passed (or warnings only)
    1 - one or more checks failed
    2 - config file missing
    3 - config file contains invalid JSON
    4 - report path invalid
#>

[CmdletBinding()]
param (
  [string]$ConfigPath = "",
  [string]$ReportPath = ""
)

$ScriptDir = Split-Path -Parent -Path $PSCommandPath

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------

function Format-Bytes {
  param([long]$Bytes)
  if ($Bytes -ge 1TB) { return "{0:N2} TB" -f ($Bytes / 1TB) }
  if ($Bytes -ge 1GB) { return "{0:N2} GB" -f ($Bytes / 1GB) }
  if ($Bytes -ge 1MB) { return "{0:N2} MB" -f ($Bytes / 1MB) }
  return "{0:N2} B" -f $Bytes
}

function Resolve-QuestConfigPath {
  param([string]$Path, [string]$ScriptDir)

  if (-not $Path) {
    $Path = Join-Path -Path $ScriptDir -ChildPath "..\config\servers.example.json"
  }

  $resolved = Resolve-Path -LiteralPath $Path -ErrorAction SilentlyContinue
  if (-not $resolved) {
    return [PSCustomObject]@{
      exit_code = 2
      fault     = "MISSING_CONFIG"
      message   = "Config file not found: $Path"
      suggestion = "Place a valid JSON config at the expected path or supply -ConfigPath"
    }
  }

  return $resolved.Path
}

function Resolve-QuestReportPath {
  param([string]$Path, [string]$ScriptDir)

  if (-not $Path) {
    $Path = Join-Path -Path $ScriptDir -ChildPath "..\reports\latest-health-report.json"
  }

  $item = Get-Item -LiteralPath $Path -ErrorAction SilentlyContinue

  if ($item) {
    if ($item.PSIsContainer) {
      $Path = Join-Path -Path $item.FullName -ChildPath "latest-health-report.json"
    } elseif ($item.Extension -ne ".json") {
      return [PSCustomObject]@{
        exit_code  = 4
        fault      = "BAD_REPORT_PATH"
        message    = "Report path exists but is not a folder or .json file: $Path"
        suggestion = "Supply a folder path or a .json file path"
      }
    }
  } else {
    $ext = [System.IO.Path]::GetExtension($Path)
    if ($ext -ne ".json") {
      $Path = Join-Path -Path $Path -ChildPath "latest-health-report.json"
    }
  }

  $parent = Split-Path -Parent -Path $Path
  if (-not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }
  $resolvedParent = Resolve-Path -Path $parent -ErrorAction Stop

  $fileName = Split-Path -Leaf -Path $Path
  return Join-Path -Path $resolvedParent.Path -ChildPath $fileName
}

function Read-QuestJsonConfig {
  param([string]$Path)

  Write-Verbose "Reading config from $Path"

  $raw = ""
  try {
    $raw = Get-Content -Path $Path -Raw -ErrorAction Stop
  } catch {
    return [PSCustomObject]@{
      exit_code  = 3
      fault      = "MALFORMED_CONFIG"
      message    = "Cannot read config file: $Path"
      detail     = $_.Exception.Message
      suggestion = "Check file permissions and encoding"
    }
  }

  $config = $null
  try {
    $config = $raw | ConvertFrom-Json -ErrorAction Stop
  } catch {
    return [PSCustomObject]@{
      exit_code  = 3
      fault      = "MALFORMED_CONFIG"
      message    = "Config file contains invalid JSON: $Path"
      detail     = $_.Exception.Message
      suggestion = "Validate the JSON with a linter before running the scan"
    }
  }

  return $config
}

function Write-QuestJsonBomless {
  param([string]$Path, [object]$InputObject)

  $json = $InputObject | ConvertTo-Json -Depth 5
  $utf8NoBom = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($Path, $json, $utf8NoBom)
}

function Test-QuestFolder {
  param([string]$Path)

  $exists = Test-Path -LiteralPath $Path -PathType Container
  if (-not $exists) {
    Write-Warning "Folder NOT found: $Path"
  } else {
    Write-Verbose "Folder exists: $Path"
  }
  return $exists
}

function Test-QuestDisk {
  param([string]$FolderPath, [double]$ThresholdGb)

  $result = [PSCustomObject]@{
    free_gb      = 0
    free_human   = "N/A"
    ok           = $false
  }

  if (-not (Test-Path -LiteralPath $FolderPath)) {
    return $result
  }

  try {
    $driveRoot = (Get-Item -LiteralPath $FolderPath).PSDrive.Root
    $driveName = $driveRoot.TrimEnd(':', '\')
    $drive = Get-PSDrive -Name $driveName -ErrorAction Stop
    $freeGb = [math]::Round($drive.Free / 1GB, 2)
    $result.free_gb = $freeGb
    $result.free_human = "$freeGb GB"
    $result.ok = $freeGb -ge $ThresholdGb

    if ($result.ok) {
      Write-Verbose "Free space: $($result.free_human) (threshold: $ThresholdGb GB)"
    } else {
      Write-Warning "Free space: $($result.free_human) below threshold of $ThresholdGb GB"
    }
  } catch {
    Write-Warning "Could not query drive for $FolderPath"
  }

  return $result
}

function Test-QuestProcess {
  param([string]$ProcessName)

  $result = [PSCustomObject]@{
    name    = $ProcessName
    running = $false
    pid     = $null
  }

  $nameWithoutExt = $ProcessName -replace '\.exe$', ''
  $found = Get-Process -Name $nameWithoutExt -ErrorAction SilentlyContinue

  if ($found) {
    $first = $found | Select-Object -First 1
    $result.running = $true
    $result.pid = $first.Id
    Write-Verbose "Process running: $ProcessName (PID $($first.Id))"
  } else {
    Write-Warning "Process NOT running: $ProcessName"
  }

  return $result
}

function Test-QuestTcpPort {
  param(
    [string]$Name,
    [string]$HostName,
    [int]$Port = 0,
    [int]$TimeoutMs = 2000
  )

  $result = [PSCustomObject]@{
    name       = $Name
    host       = $HostName
    port       = $Port
    timeout_ms = $TimeoutMs
    reachable  = $false
    error      = $null
    passed     = $false
  }

  if (-not $Name -or -not $HostName -or $Port -le 0) {
    $result.error = "invalid parameters: name='$Name', host='$HostName', port=$Port"
    Write-Warning "Network check skipped: $result.error"
    return $result
  }

  try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $connect = $tcpClient.BeginConnect($HostName, $Port, $null, $null)
    $wait = $connect.AsyncWaitHandle.WaitOne($TimeoutMs, $false)

    if ($wait) {
      try {
        $tcpClient.EndConnect($connect)
        $result.reachable = $true
        $result.passed = $true
        Write-Verbose "TCP port reachable: $($HostName):$Port ($Name)"
      } catch {
        $result.error = $_.Exception.Message
        Write-Warning "TCP port unreachable: $($HostName):$Port ($Name) - $($result.error)"
      }
    } else {
      $result.error = "timeout"
      Write-Warning "TCP port timeout: $($HostName):$Port ($Name) after ${TimeoutMs}ms"
    }
  } catch {
    $result.error = $_.Exception.Message
    Write-Warning "TCP port check error: $($HostName):$Port ($Name) - $($result.error)"
  } finally {
    if ($tcpClient) { $tcpClient.Close() }
  }

  return $result
}

function Test-QuestLogFreshness {
  param(
    [string]$Name,
    [string]$Path,
    [int]$MaxAgeMinutes = 0
  )

  $result = [PSCustomObject]@{
    name            = $Name
    path            = $Path
    exists          = $false
    last_write_time = $null
    age_minutes     = $null
    max_age_minutes = $MaxAgeMinutes
    fresh           = $false
    error           = $null
    passed          = $false
  }

  if (-not $Name -or -not $Path) {
    $result.error = "invalid parameters: name='$Name', path='$Path'"
    Write-Warning "Log check skipped: $result.error"
    return $result
  }

  if ($MaxAgeMinutes -le 0) {
    $result.error = "invalid max_age_minutes: $MaxAgeMinutes"
    Write-Warning "Log check skipped: $result.error"
    return $result
  }

  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    $result.error = "file not found: $Path"
    Write-Warning "Log file not found: $Path ($Name)"
    return $result
  }

  $result.exists = $true

  try {
    $item = Get-Item -LiteralPath $Path -ErrorAction Stop
    $result.last_write_time = $item.LastWriteTime.ToString("o")
    $ageMinutes = [math]::Round(((Get-Date) - $item.LastWriteTime).TotalMinutes, 2)
    $result.age_minutes = $ageMinutes
    $result.fresh = $ageMinutes -le $MaxAgeMinutes

    if ($result.fresh) {
      $result.passed = $true
      Write-Verbose "Log file fresh: $Path ($Name) - $ageMinutes min old (max: $MaxAgeMinutes)"
    } else {
      $result.error = "log age $ageMinutes min exceeds max $MaxAgeMinutes min"
      Write-Warning "Log file stale: $Path ($Name) - $ageMinutes min old (max: $MaxAgeMinutes)"
    }
  } catch {
    $result.error = $_.Exception.Message
    Write-Warning "Log check error: $Path ($Name) - $($result.error)"
  }

  return $result
}

function Test-QuestProcessResources {
  param(
    [string]$Name,
    [string]$ProcessName,
    [double]$MaxMemoryMb = 0,
    [double]$MaxCpuPercent = 0,
    [int]$SampleMs = 1000
  )

  $result = [PSCustomObject]@{
    name              = $Name
    process           = $ProcessName
    process_count     = 0
    pids              = @()
    total_memory_mb   = 0
    max_memory_mb     = $MaxMemoryMb
    memory_ok         = $true
    total_cpu_percent = 0
    max_cpu_percent   = $MaxCpuPercent
    cpu_ok            = $true
    sample_ms         = $SampleMs
    error             = $null
    passed            = $true
  }

  if (-not $Name -or -not $ProcessName) {
    $result.error = "invalid parameters: name='$Name', process='$ProcessName'"
    $result.memory_ok = $false
    $result.cpu_ok = $false
    $result.passed = $false
    Write-Warning "Resource check skipped: $result.error"
    return $result
  }

  if ($SampleMs -le 0) { $SampleMs = 1000 }

  $nameWithoutExt = $ProcessName -replace '\.exe$', ''
  $procs = @(Get-Process -Name $nameWithoutExt -ErrorAction SilentlyContinue)

  if ($procs.Count -eq 0) {
    $result.error = "process not running: $ProcessName"
    $result.memory_ok = $false
    $result.cpu_ok = $false
    $result.passed = $false
    Write-Warning "Resource check: process not running: $ProcessName ($Name)"
    return $result
  }

  $result.process_count = $procs.Count
  $result.pids = $procs | ForEach-Object { $_.Id }

  # Memory (sum of WorkingSet64 across all matching processes)
  $totalMemoryBytes = ($procs | Measure-Object -Property WorkingSet64 -Sum).Sum
  $totalMemoryMb = [math]::Round($totalMemoryBytes / 1MB, 2)
  $result.total_memory_mb = $totalMemoryMb

  if ($MaxMemoryMb -gt 0) {
    $result.memory_ok = $totalMemoryMb -le $MaxMemoryMb
    if (-not $result.memory_ok) {
      $result.error = "memory $totalMemoryMb MB exceeds max $MaxMemoryMb MB"
      Write-Warning "Resource check: $ProcessName ($Name) memory $totalMemoryMb MB exceeds max $MaxMemoryMb MB"
    } else {
      Write-Verbose "Resource check: $ProcessName ($Name) memory $totalMemoryMb MB (max: $MaxMemoryMb MB)"
    }
  }

  # CPU (sampled TotalProcessorTime)
  if ($MaxCpuPercent -gt 0) {
    Start-Sleep -Milliseconds $SampleMs

    $totalCpuSeconds = 0
    $cpuError = $false
    foreach ($p in $procs) {
      try {
        $afterProc = Get-Process -Id $p.Id -ErrorAction Stop
        $diff = ($afterProc.TotalProcessorTime - $p.TotalProcessorTime).TotalSeconds
        if ($diff -lt 0) { $diff = 0 }
        $totalCpuSeconds += $diff
      } catch {
        $cpuError = $true
        break
      }
    }

    if (-not $cpuError) {
      $sampleSeconds = $SampleMs / 1000.0
      $logicalCpus = [Environment]::ProcessorCount
      if ($logicalCpus -le 0) { $logicalCpus = 1 }
      $cpuPercent = [math]::Round(($totalCpuSeconds / $sampleSeconds / $logicalCpus) * 100, 2)
      if ($cpuPercent -lt 0) { $cpuPercent = 0 }
      $result.total_cpu_percent = $cpuPercent
      $result.cpu_ok = $cpuPercent -le $MaxCpuPercent
      if (-not $result.cpu_ok) {
        $errMsg = "CPU $cpuPercent% exceeds max $MaxCpuPercent%"
        if ($result.error) { $result.error += "; $errMsg" } else { $result.error = $errMsg }
        Write-Warning "Resource check: $ProcessName ($Name) CPU $cpuPercent% exceeds max $MaxCpuPercent%"
      } else {
        Write-Verbose "Resource check: $ProcessName ($Name) CPU $cpuPercent% (max: $MaxCpuPercent%)"
      }
    }
  }

  $result.passed = $result.memory_ok -and $result.cpu_ok
  return $result
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

# 1. Resolve config path
Write-Verbose "Resolving config path..."
$configResult = Resolve-QuestConfigPath -Path $ConfigPath -ScriptDir $ScriptDir
if ($configResult.GetType().Name -eq "PSCustomObject" -and $configResult.exit_code) {
  $configResult
  exit $configResult.exit_code
}
$ConfigPath = $configResult

# 2. Read config
Write-Verbose "Loading config..."
$servers = Read-QuestJsonConfig -Path $ConfigPath
if ($servers.GetType().Name -eq "PSCustomObject" -and $servers.exit_code) {
  $servers
  exit $servers.exit_code
}
if ($servers -isnot [System.Array]) { $servers = @($servers) }

# 3. Run checks
$results = @()
$overallPass = $true
$scanTime = (Get-Date).ToUniversalTime()

foreach ($svr in $servers) {
  Write-Verbose "=== Checking: $($svr.name) ==="

  $folderOk = Test-QuestFolder -Path $svr.folder

  $diskResult = Test-QuestDisk -FolderPath $svr.folder -ThresholdGb $svr.disk_threshold_gb

  $procResult = Test-QuestProcess -ProcessName $svr.process

  $networkResults = @()
  $networkOk = $true
  if ($svr.network_checks -and @($svr.network_checks).Count -gt 0) {
    foreach ($nc in $svr.network_checks) {
      $netResult = Test-QuestTcpPort -Name $nc.name -HostName $nc.host -Port $nc.port -TimeoutMs $nc.timeout_ms
      $networkResults += $netResult
      if (-not $netResult.passed) { $networkOk = $false }
    }
  }

  $logResults = @()
  $logsOk = $true
  if ($svr.log_checks -and @($svr.log_checks).Count -gt 0) {
    foreach ($lc in $svr.log_checks) {
      $logResult = Test-QuestLogFreshness -Name $lc.name -Path $lc.path -MaxAgeMinutes $lc.max_age_minutes
      $logResults += $logResult
      if (-not $logResult.passed) { $logsOk = $false }
    }
  }

  $resourceResults = @()
  $resourcesOk = $true
  if ($svr.resource_checks -and @($svr.resource_checks).Count -gt 0) {
    foreach ($rc in $svr.resource_checks) {
      $resourceResult = Test-QuestProcessResources -Name $rc.name -ProcessName $rc.process -MaxMemoryMb $rc.max_memory_mb -MaxCpuPercent $rc.max_cpu_percent -SampleMs $rc.sample_ms
      $resourceResults += $resourceResult
      if (-not $resourceResult.passed) { $resourcesOk = $false }
    }
  }

  $checkPass = $folderOk -and $diskResult.ok -and $procResult.running -and $networkOk -and $logsOk -and $resourcesOk
  if (-not $checkPass) { $overallPass = $false }

  $results += [PSCustomObject]@{
    server_name      = $svr.name
    folder           = $svr.folder
    process          = $procResult.name
    folder_exists    = $folderOk
    disk_free_gb     = $diskResult.free_gb
    disk_free_human  = $diskResult.free_human
    disk_threshold   = $svr.disk_threshold_gb
    disk_ok          = $diskResult.ok
    process_running  = $procResult.running
    process_pid      = $procResult.pid
    network_checks   = $networkResults
    network_ok       = $networkOk
    log_checks       = $logResults
    logs_ok          = $logsOk
    resource_checks  = $resourceResults
    resources_ok     = $resourcesOk
    passed           = $checkPass
  }
}

# 4. Build report
$report = [PSCustomObject]@{
  scan_timestamp_utc = $scanTime.ToString("o")
  overall_pass       = $overallPass
  total_servers      = $servers.Count
  passed_checks      = @($results | Where-Object { $_.passed }).Count
  failed_checks      = @($results | Where-Object { -not $_.passed }).Count
  results            = $results
}

# 5. Resolve report path
Write-Verbose "Resolving report path..."
$reportPathResult = Resolve-QuestReportPath -Path $ReportPath -ScriptDir $ScriptDir
if ($reportPathResult.GetType().Name -eq "PSCustomObject" -and $reportPathResult.exit_code) {
  $reportPathResult
  exit $reportPathResult.exit_code
}
$ReportPath = $reportPathResult

# 6. Write report to disk (BOM-less UTF-8)
Write-Verbose "Writing report to $ReportPath"
Write-QuestJsonBomless -Path $ReportPath -InputObject $report

# 7. Emit report object to pipeline for downstream use
$report

# Exit with code 1 if any check failed, 0 otherwise
if ($overallPass) { exit 0 } else { exit 1 }
