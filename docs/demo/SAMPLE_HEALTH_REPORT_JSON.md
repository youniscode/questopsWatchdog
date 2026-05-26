# QuestOps Watchdog — Sample Health Report JSON

A fictional scan report showing one passing and one failing server. This is the format written to `reports/latest-health-report.json`.

```json
{
  "scan_timestamp_utc": "2026-05-25T14:30:00Z",
  "overall_pass": false,
  "server_count": 2,
  "passed_count": 1,
  "failed_count": 1,
  "results": [
    {
      "server_name": "Demo Project Zomboid Server",
      "passed": true,
      "folder": "C:\\GameServers\\ProjectZomboid",
      "folder_exists": true,
      "disk_threshold_gb": 10,
      "disk_free_gb": 124.5,
      "disk_ok": true,
      "process": "ProjectZomboid64.exe",
      "process_running": true,
      "network_checks": [
        {
          "name": "PZ Game Port",
          "host": "127.0.0.1",
          "port": 16261,
          "timeout_ms": 2000,
          "reachable": true,
          "ok": true
        },
        {
          "name": "PZ Steam Query",
          "host": "127.0.0.1",
          "port": 16262,
          "timeout_ms": 2000,
          "reachable": true,
          "ok": true
        }
      ],
      "network_ok": true,
      "log_checks": [
        {
          "name": "PZ console log",
          "path": "C:\\GameServers\\ProjectZomboid\\Logs\\console.txt",
          "max_age_minutes": 30,
          "last_write_time_utc": "2026-05-25T14:28:15Z",
          "age_minutes": 1.75,
          "exists": true,
          "ok": true
        }
      ],
      "logs_ok": true,
      "resource_checks": [
        {
          "name": "PZ process resources",
          "process": "ProjectZomboid64.exe",
          "max_memory_mb": 8192,
          "memory_mb": 2450.3,
          "memory_ok": true,
          "max_cpu_percent": 95,
          "cpu_percent": 12.4,
          "cpu_ok": true,
          "sample_ms": 1000,
          "ok": true
        }
      ],
      "resources_ok": true,
      "notes": "All checks passed."
    },
    {
      "server_name": "Demo Minecraft Server",
      "passed": false,
      "folder": "C:\\GameServers\\Minecraft",
      "folder_exists": true,
      "disk_threshold_gb": 20,
      "disk_free_gb": 47.2,
      "disk_ok": true,
      "process": "java.exe",
      "process_running": true,
      "network_checks": [
        {
          "name": "MC Game Port",
          "host": "127.0.0.1",
          "port": 25565,
          "timeout_ms": 3000,
          "reachable": false,
          "ok": false,
          "error": "Connection timeout after 3000ms"
        }
      ],
      "network_ok": false,
      "log_checks": [
        {
          "name": "MC latest log",
          "path": "C:\\GameServers\\Minecraft\\logs\\latest.log",
          "max_age_minutes": 15,
          "last_write_time_utc": "2026-05-24T22:10:00Z",
          "age_minutes": 980.0,
          "exists": true,
          "ok": false,
          "error": "Log is 980 minutes old, exceeds max_age_minutes of 15"
        }
      ],
      "logs_ok": false,
      "resource_checks": [
        {
          "name": "MC process resources",
          "process": "java.exe",
          "max_memory_mb": 4096,
          "memory_mb": 5120.8,
          "memory_ok": false,
          "max_cpu_percent": 90,
          "cpu_percent": 15.2,
          "cpu_ok": true,
          "sample_ms": 1000,
          "ok": false,
          "error": "Memory 5120.8 MB exceeds max_memory_mb 4096"
        }
      ],
      "resources_ok": false,
      "notes": "Multiple failures detected: port unreachable, stale log, memory over threshold."
    }
  ]
}
```

## Fields explained

| Field | Purpose |
|-------|---------|
| `scan_timestamp_utc` | When the scan ran (UTC) |
| `overall_pass` | `true` only if every server passed every check |
| `results[].passed` | Per-server pass/fail |
| `network_checks` | Optional TCP port reachability array |
| `log_checks` | Optional log freshness array |
| `resource_checks` | Optional CPU/memory array |

## Notes

- All servers, paths, IPs, and data shown are **fictional**.
- Real reports use real machine paths and may contain additional fields.
- The report is written as BOM-less UTF-8 JSON.
