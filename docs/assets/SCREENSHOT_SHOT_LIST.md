# QuestOps Watchdog — Screenshot Shot List

Planned screenshots for documentation and marketing. Each entry is one image capture.

## Screenshots

| # | ID | Description | Feature | Priority | Status |
|---|----|-------------|---------|----------|--------|
| 1 | `shot-healthy-scan` | Full console: both servers PASS all checks | Core scan | P1 | Planned |
| 2 | `shot-tcp-fail` | Console: one server has TCP port failure | TCP check | P1 | Planned |
| 3 | `shot-stale-log` | Console: server with stale log detection | Log check | P1 | Planned |
| 4 | `shot-high-cpu` | Console: server exceeding CPU threshold | Resource check | P1 | Planned |
| 5 | `shot-mixed-scan` | Console: multiple servers, mixed PASS/FAIL | Core scan | P1 | Planned |
| 6 | `shot-discord-alert` | Discord embed: failing server alert | Discord alerts | P1 | Planned |
| 7 | `shot-html-report` | Browser: HTML report with summary cards | HTML report | P2 | Planned |
| 8 | `shot-json-report` | Editor: health report JSON file | JSON report | P2 | Planned |
| 9 | `shot-config-file` | Editor: `servers.example.json` open | Configuration | P2 | Planned |
| 10 | `shot-help-output` | Console: `-help` parameter listing | CLI | P3 | Planned |
| 11 | `shot-force-alert` | Console or Discord: `-ForceAlert` override | Manual alert | P2 | Planned |
| 12 | `shot-before-after` | Side-by-side: unhealthy vs fixed server | Comparison | P3 | Planned |

## Priority definitions

| Priority | Meaning |
|----------|---------|
| P1 | Needed for core README and landing page |
| P2 | Needed for detailed feature documentation |
| P3 | Nice-to-have, adds depth |

## Naming

Files should be named as `screenshot-{id}-v{version}.png` (e.g. `screenshot-shot-healthy-scan-v0.4.9.png`).

See [README.md](README.md) for the full naming convention.
