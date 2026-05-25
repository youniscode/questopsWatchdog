<#
.SYNOPSIS
  QuestOps Watchdog - uninstall scheduled task.
.DESCRIPTION
  Removes the Windows Scheduled Task created by install_questops_task.ps1.

  Exit codes:
    0 - task unregistered successfully or did not exist
    1 - task operation failed
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (
  [string]$TaskName = "QuestOps Watchdog",
  [switch]$Force
)

# Check if task exists
$existing = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue

if (-not $existing) {
  Write-Host "Task '$TaskName' does not exist. Nothing to do."
  exit 0
}

if ($Force -or $PSCmdlet.ShouldProcess($TaskName, "Unregister scheduled task")) {
  try {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction Stop | Out-Null
    Write-Host "Task '$TaskName' unregistered successfully."
    exit 0
  } catch {
    Write-Error "Failed to unregister task: $_"
    exit 1
  }
}
