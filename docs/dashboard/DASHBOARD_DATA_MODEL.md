# QuestOps Watchdog — Dashboard Data Model

The dashboard reads the JSON scan report from `reports/latest-health-report.json`. Below is the current expected schema.

## Top-level fields

| Field | Type | Always present | Description |
|-------|------|----------------|-------------|
| `scan_timestamp_utc` | string | yes | ISO 8601 UTC timestamp of the scan |
| `overall_pass` | boolean | yes | `true` if every server passed every check |
| `server_count` | integer | yes | Total number of servers in the report |
| `passed_count` | integer | yes | Number of servers that passed all checks |
| `failed_count` | integer | yes | Number of servers that failed at least one check |
| `results` | array | yes | Array of per-server result objects |

## Per-server result object (`results[]`)

| Field | Type | Always present | Description |
|-------|------|----------------|-------------|
| `server_name` | string | yes | Display name of the server |
| `passed` | boolean | yes | `true` if all checks passed for this server |
| `folder` | string | yes | Absolute path to the server folder |
| `folder_exists` | boolean | yes | Whether the folder exists |
| `disk_threshold_gb` | number | yes | Minimum free space threshold in GB |
| `disk_free_gb` | number | yes | Actual free space in GB |
| `disk_free_human` | string | no | Human-readable free space (e.g. "124.5 GB") |
| `disk_ok` | boolean | yes | `true` if free space is above threshold |
| `process` | string | yes | Process name being checked (e.g. `java.exe`) |
| `process_running` | boolean | yes | Whether the process is running |
| `process_pid` | integer | no | Process ID of the running process |
| `notes` | string | no | Optional informational note |
| `network_checks` | array | no | Array of TCP port check results |
| `network_ok` | boolean | no | `true` if all TCP ports are reachable |
| `log_checks` | array | no | Array of log freshness check results |
| `logs_ok` | boolean | no | `true` if all logs are fresh |
| `resource_checks` | array | no | Array of process resource check results |
| `resources_ok` | boolean | no | `true` if all resource checks pass |

## Network check object (`results[].network_checks[]`)

| Field | Type | Always present | Description |
|-------|------|----------------|-------------|
| `name` | string | yes | Label for this check |
| `host` | string | yes | Hostname or IP address |
| `port` | integer | yes | TCP port number |
| `timeout_ms` | integer | yes | Connection timeout in milliseconds |
| `reachable` | boolean | yes | Whether the port was reachable |
| `ok` | boolean | yes | Same as reachable |
| `error` | string | no | Error message if unreachable |

## Log check object (`results[].log_checks[]`)

| Field | Type | Always present | Description |
|-------|------|----------------|-------------|
| `name` | string | yes | Label for this check |
| `path` | string | yes | Absolute path to the log file |
| `max_age_minutes` | integer | yes | Maximum allowed age in minutes |
| `last_write_time_utc` | string | yes | ISO 8601 UTC timestamp of last write |
| `age_minutes` | number | yes | Actual age in minutes |
| `exists` | boolean | yes | Whether the log file exists |
| `ok` | boolean | yes | `true` if log is fresh |
| `error` | string | no | Error message if stale or missing |

## Resource check object (`results[].resource_checks[]`)

| Field | Type | Always present | Description |
|-------|------|----------------|-------------|
| `name` | string | yes | Label for this check |
| `process` | string | yes | Process name being monitored |
| `max_memory_mb` | integer | yes | Maximum allowed working set in MB (may be 0 for no limit) |
| `memory_mb` | number | yes | Current working set in MB |
| `memory_ok` | boolean | yes | `true` if memory is within limit |
| `max_cpu_percent` | integer | yes | Maximum allowed CPU % (may be 0 for no limit) |
| `cpu_percent` | number | yes | Current CPU % |
| `cpu_ok` | boolean | yes | `true` if CPU is within limit |
| `sample_ms` | integer | yes | CPU sampling window in milliseconds |
| `ok` | boolean | yes | `true` if both memory and CPU are within limits |
| `error` | string | no | Error message if over threshold |

## Optional field handling

The dashboard must handle the following fields being absent:

| Missing field | Dashboard behaviour |
|---------------|---------------------|
| `disk_free_human` | Calculate from `disk_free_gb` or show GB value |
| `process_pid` | Show "-" or "N/A" |
| `notes` | Show nothing |
| `network_checks` / `network_ok` | Show "No network checks configured" |
| `log_checks` / `logs_ok` | Show "No log checks configured" |
| `resource_checks` / `resources_ok` | Show "No resource checks configured" |
| `passed_count` / `failed_count` | Calculate from `results` array |
| Any `error` field | Show error message in red |
| Any `ok` / `*_ok` field | Default to `true` if absent (backward compatibility) |

## Version compatibility

The report format has been stable since v0.4. The dashboard should be compatible with reports generated by v0.4.5 and later. Reports from earlier versions may lack optional check fields.
