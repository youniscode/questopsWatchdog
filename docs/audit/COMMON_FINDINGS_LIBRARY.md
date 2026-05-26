# QuestOps Watchdog — Common Findings Library

Reusable finding blocks for beta audit reports. Each entry includes symptom, why it matters, recommended fix, severity suggestion, and client-friendly wording.

---

## 1. Server folder path wrong

| Field | Value |
|-------|-------|
| **Symptom** | `folder_exists: false` for a server in the JSON report. |
| **Why it matters** | The tool cannot verify the server installation exists. All other checks for this server depend on the folder path being correct. |
| **Recommended fix** | Update the `folder` field in the config to match the actual server installation path. |
| **Severity suggestion** | High — the server cannot be properly monitored until the path is correct. |
| **Client-friendly wording** | "The scan could not find the server folder at the path specified in the config. Check that the `folder` field points to the correct directory. If the server was recently moved or reinstalled, update the path and run the scan again." |

## 2. Process name mismatch

| Field | Value |
|-------|-------|
| **Symptom** | `process_running: false` for a server, but the server is actually running. |
| **Why it matters** | The tool checks for an exact process name match. If the process name in the config does not match the actual running process, the tool will report a failure. |
| **Recommended fix** | Verify the exact process name in Task Manager and update the `process` field in the config. |
| **Severity suggestion** | High — the tool cannot detect server crashes if the process name is wrong. |
| **Client-friendly wording** | "The scan reports that the server process is not running, but you confirmed it is. This usually means the process name in the config does not match the actual process name. Open Task Manager, find the correct executable name, and update the `process` field in the config." |

## 3. Disk threshold too high/low

| Field | Value |
|-------|-------|
| **Symptom** | `disk_ok: false` with plenty of free space, or `disk_ok: true` with very little free space. |
| **Why it matters** | An incorrect threshold means the tool either cries wolf (false positives) or stays silent when the disk is nearly full (false negatives). |
| **Recommended fix** | Set `disk_threshold_gb` to a realistic value for each server. A common starting point is 10–20 GB. |
| **Severity suggestion** | Medium (too high: false warnings). High (too low: no warning before disk full). |
| **Client-friendly wording** | "The disk threshold is set to [X] GB but the server drive has [Y] GB free. [If too low: This means the tool will not warn you until the disk is nearly full. Consider increasing the threshold to give yourself time to act.] [If too high: This means the tool will flag the disk as failing even though there is plenty of space. Consider lowering the threshold to match your actual needs.]" |

## 4. Low disk free space

| Field | Value |
|-------|-------|
| **Symptom** | `disk_ok: false` and `disk_free_gb` is actually low. |
| **Why it matters** | A full disk can cause the server to crash, fail to write logs, or become unresponsive. |
| **Recommended fix** | Free up space (remove old backups, logs, or unused files). Increase the server drive capacity if needed. |
| **Severity suggestion** | High — risk of server crash if disk fills completely. |
| **Client-friendly wording** | "The server drive is running low on free space ([X] GB free). If the disk fills up, the server may crash or fail to write logs. Consider cleaning up old files or increasing the drive capacity." |

## 5. Game port unreachable

| Field | Value |
|-------|-------|
| **Symptom** | `network_ok: false` with one or more TCP ports marked as unreachable. |
| **Why it matters** | If the game port is unreachable, players cannot connect even though the server process may be running. This can happen due to firewall rules, port conflicts, or the server not binding to the expected address. |
| **Recommended fix** | Check the firewall, server bind address, port configuration, and whether another process is using the port. |
| **Severity suggestion** | High — directly affects player connectivity. |
| **Client-friendly wording** | "The scan could not reach the game port ([host:port]). This means players may not be able to connect. Common causes: the server is bound to a different port, a firewall is blocking the port, or another application is using it. Check your server config and firewall settings." |

## 6. Log file missing

| Field | Value |
|-------|-------|
| **Symptom** | Log check reports `exists: false`. The configured log file does not exist at the specified path. |
| **Why it matters** | If the log path is wrong, the tool cannot verify the server is actively writing logs. A missing log file could also indicate a server configuration issue. |
| **Recommended fix** | Update the log `path` in the config to point to the correct log file location. |
| **Severity suggestion** | Medium — stale log detection will not work until the path is corrected. |
| **Client-friendly wording** | "The log file at the configured path was not found. Check that the path is correct and that the server is configured to write logs to that location. Update the `path` field in the config and run the scan again." |

## 7. Log file stale

| Field | Value |
|-------|-------|
| **Symptom** | Log check reports `ok: false` with `age_minutes` exceeding `max_age_minutes`. |
| **Why it matters** | A stale log file can indicate that the server is hung, crashed, or no longer writing output. The server process may appear to be running but is not functioning. |
| **Recommended fix** | Investigate why the log stopped updating. Restart the server if needed. Adjust `max_age_minutes` if the threshold is too tight for the server's typical log behaviour. |
| **Severity suggestion** | High — strongly suggests the server is not operating normally. |
| **Client-friendly wording** | "The server log has not been updated in [X] minutes (threshold: [Y] minutes). This often means the server process is hung or crashed even though it appears to be running. Restart the server and check if logs resume updating normally." |

## 8. Process over memory threshold

| Field | Value |
|-------|-------|
| **Symptom** | `memory_ok: false` with `memory_mb` exceeding `max_memory_mb`. |
| **Why it matters** | A process using more memory than expected may indicate a memory leak, excessive player count, or misconfiguration. If memory keeps growing, the server may crash. |
| **Recommended fix** | Increase `max_memory_mb` if the usage is normal for the server's load. Investigate memory usage patterns if the growth seems abnormal. |
| **Severity suggestion** | High (if close to system limits). Medium (if threshold is just too tight). |
| **Client-friendly wording** | "The server process is using [X] MB of memory, which exceeds the configured threshold of [Y] MB. If this is normal for your server's player count, simply increase the threshold. If memory usage is growing over time, monitor it — it could indicate a memory leak." |

## 9. CPU threshold warning

| Field | Value |
|-------|-------|
| **Symptom** | `cpu_ok: false` with `cpu_percent` exceeding `max_cpu_percent`. |
| **Why it matters** | High CPU usage can cause lag, crashes, or other performance issues. If it persists, the server may become unresponsive. |
| **Recommended fix** | Increase `max_cpu_percent` if the usage is normal for the server's load. Investigate if the CPU spike is abnormal. |
| **Severity suggestion** | Medium — depends on duration and impact on gameplay. |
| **Client-friendly wording** | "The server process is using [X]% CPU, which exceeds the threshold of [Y]%. If this is normal during peak hours, consider raising the threshold. If it is unusual, check for mod conflicts, background processes, or other factors causing high CPU usage." |

## 10. Config uses placeholder paths

| Field | Value |
|-------|-------|
| **Symptom** | The config file contains paths from the example template (e.g. `C:\GameServers\...`). |
| **Why it matters** | Placeholder paths will cause all checks to fail because the actual server files are not at those locations. |
| **Recommended fix** | Edit the config to replace all placeholder paths with the actual server paths. |
| **Severity suggestion** | High — no checks will pass until paths are corrected. |
| **Client-friendly wording** | "The config file still contains placeholder paths from the example template. Replace these with the actual paths to your server folders, processes, and log files. See `config/servers.game.example.json` for reference fields." |

## 11. Discord webhook not configured

| Field | Value |
|-------|-------|
| **Symptom** | No Discord alerting set up. The tool reports scan results but does not send notifications. |
| **Why it matters** | Without alerting, you must manually check the scan results. Issues may go undetected for hours. |
| **Recommended fix** | Set `$env:QUESTOPS_DISCORD_WEBHOOK_URL` and use `questops_run.ps1` for automatic alerts on failure. |
| **Severity suggestion** | Informational — the tool works without alerting. |
| **Client-friendly wording** | "Discord alerting is not configured. The tool will still run scans and produce reports, but you will not receive notifications when a check fails. To enable alerts, set the webhook URL as an environment variable and use `questops_run.ps1` instead of `questops_scan.ps1`." |

## 12. Scheduled task not installed

| Field | Value |
|-------|-------|
| **Symptom** | Scans are run manually only. No automated recurring scans. |
| **Why it matters** | Manual scanning means issues may be detected hours or days late, especially if the server crashes overnight. |
| **Recommended fix** | Install the scheduled task with `install_questops_task.ps1`. |
| **Severity suggestion** | Medium — improves detection time significantly. |
| **Client-friendly wording** | "The scheduled task is not installed, so scans only run when you run them manually. This means a server crash could go unnoticed for hours. Consider installing the scheduled task with `install_questops_task.ps1 -NoAlert -Force` (or include alerting if you set up the webhook)." |

## 13. Audit bundle missing optional config/log

| Field | Value |
|-------|-------|
| **Symptom** | The audit results bundle contains only the JSON report, HTML report, and manifest. No config or run log. |
| **Why it matters** | Without the config, the reviewer cannot verify thresholds, paths, or optional check configurations. Without the run log, the reviewer cannot see scan history or error patterns. |
| **Recommended fix** | If comfortable, re-export the bundle with `-IncludeConfig -IncludeLog`. Review contents before sending. |
| **Severity suggestion** | Informational — the bundle is still usable for basic review. |
| **Client-friendly wording** | "The audit bundle did not include the config file or run log. The basic report and HTML were reviewed, but including the config and log would allow a more thorough analysis. If you are comfortable sharing them, you can re-export with `-IncludeConfig -IncludeLog`." |
