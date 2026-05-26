# QuestOps Watchdog — Website Landing Page Draft

Complete draft for a public-facing landing page. This is copy/documentation only — no build tools, no framework.

---

## Hero section

**Headline:** Know your game servers are healthy — before your players tell you.

**Subheadline:** A lightweight, zero-dependency health monitor for Windows game servers. Checks folders, disks, processes, ports, logs, and resource usage — then alerts you on Discord when something fails.

**Primary CTA:** Download the tool — free

**Secondary CTA:** See how it works

---

## Problem section

### Server owners are flying blind

**Server crashes happen.** Processes hang, ports become unreachable, disks fill up, log files go silent. The problem isn't that failures happen — it's that you find out too late.

**Players know before you do.** Someone messages on Discord: "Is the server down?". You Remote Desktop in, check Task Manager, scroll through logs, and guess what went wrong. By the time you act, players have been waiting 30–90 minutes.

**No simple evidence.** When a server crashes overnight, you have no record. Was the process running? Was the port responding? Was memory spiking? Without data, every fix is a guess.

**Unclear state.** You manage multiple servers on one Windows machine. Each has its own folder, process, ports, logs, and resource needs. Keeping a mental map of all of them is exhausting.

---

## Solution section

### QuestOps Watchdog — local, automated, actionable

A PowerShell-based tool that runs entirely on your Windows machine. No cloud, no telemetry, no setup beyond editing a JSON file.

**JSON report** — every scan writes a structured report with per-server pass/fail for folder, disk, process, network, logs, and resources.

**HTML report** — export the scan result as a standalone, printable HTML file with summary cards, PASS/FAIL badges, and per-server detail tables. No JavaScript, no CDN, safe for print-to-PDF.

**Discord alert** — when a scan detects failures, a plain-text alert is sent to your Discord channel. Lists failed servers, failed categories, and specific check details.

**Scheduled scans** — use the built-in Task Scheduler installer to run scans automatically every 15 minutes (or any interval). No need to remember to run it manually.

**Audit results bundle** — package the JSON report, HTML report, and optionally the config and run log into a single zip. Ready to send for a paid manual audit or to keep as evidence.

---

## Who it is for

- **Project Zomboid server owners** running dedicated servers on Windows
- **Minecraft self-hosters** who manage their own Java servers
- **Valheim / ICARUS / survival game communities** with Windows-based hosting
- **Small Discord gaming communities** where the server admin also handles hosting
- **Server owners managing multiple game servers** on a single Windows machine who need a lightweight monitoring layer

If you run game servers on Windows and want automated health checks without installing a monitoring stack, this is for you.

---

## What it checks

| Check | What it does |
|-------|-------------|
| Folder exists | Confirms the server installation folder is present |
| Free disk space | Checks available space against a configurable threshold |
| Process running | Verifies the server process (e.g. ProjectZomboid64.exe, java.exe) is active |
| TCP ports | Tests game port reachability with configurable timeout |
| Log freshness | Checks that log files have been written to within a configurable age limit |
| CPU / memory | Monitors process resource usage against configurable thresholds |

All optional checks gracefully degrade — if not configured, they are skipped and do not affect the pass/fail result.

---

## How it works

```
1. Download the tool package
   └─ Extract the zip anywhere on your Windows machine

2. Validate the config
   └─ Run the config validator to check JSON structure

3. Run a scan
   └─ Executes all configured checks, writes JSON report

4. Export the HTML report (optional)
   └─ Generate a standalone printable HTML file

5. Send audit results bundle (optional, for paid review)
   └─ Package JSON + HTML + config + log into one zip
```

Each step is a single PowerShell command. No installers, no dependencies, no background services.

---

## Paid audit offer

Need a deeper analysis? I offer manual audits of your scan outputs, config, and setup.

| Tier | Price | What's included |
|------|-------|-----------------|
| **Quick Scan** | €49 | Single server, config + report review, written recommendations |
| **Standard Audit** | €149 | 1–3 servers, full review, security check, prioritised recommendations |
| **Deep Audit** | €299 | 4–10 servers, full review, security check, recommendations, 30-min call |
| **Custom Ops Setup** | €499+ | 10+ servers, priority turnaround, dedicated support, custom config |

Prices are adjustable based on scope, urgency, and server count. The free tool is fully functional without a paid audit.

→ [Full audit details](docs/business/PAID_AUDIT_OFFER.md) · [Sample audit summary](docs/business/SAMPLE_AUDIT_SUMMARY.md)

---

## Demo examples

See what QuestOps Watchdog produces without running it yourself. All examples use fictional data.

- [Sample health report JSON](docs/demo/SAMPLE_HEALTH_REPORT_JSON.md) — one passing server, one failing server
- [Sample HTML report preview](docs/demo/SAMPLE_HTML_REPORT_PREVIEW.md) — layout and content of the HTML audit report
- [Sample Discord alert](docs/demo/SAMPLE_DISCORD_ALERT.md) — what alerts look like for various failure scenarios
- [Sample client before/after](docs/demo/SAMPLE_CLIENT_BEFORE_AFTER.md) — fictional transformation story

---

## Security / privacy

- **No cloud.** The tool runs entirely on your Windows machine. No data is sent anywhere unless you explicitly configure a Discord webhook.
- **No telemetry.** No usage tracking, no analytics, no phone-home. The tool does not make network requests except to send Discord alerts (if configured).
- **No webhook URL stored in files.** The Discord webhook URL comes from an environment variable (`$env:QUESTOPS_DISCORD_WEBHOOK_URL`). It is never written to disk by the tool.
- **Local-only execution.** All scan output stays on your machine until you decide to share it (e.g. send a results bundle for a paid audit).
- **Client controls the data.** When requesting a paid audit, you choose what to send. The audit results bundle includes only what you explicitly include.

---

## FAQ

### Does this require installing anything?

No. QuestOps Watchdog is a set of PowerShell scripts. If you have Windows, you have PowerShell 5.1 — no extra installation needed. Download the zip, extract it, edit a JSON config, and run.

### Does it work on Linux?

No. The tool uses Windows-specific features (`Get-PSDrive`, `Get-Process`, .NET `TcpClient`) and PowerShell 5.1 cmdlets. It does not run on Linux or macOS.

### Can it monitor multiple servers?

Yes. The config file accepts an array of server objects. You can monitor any number of servers with different folders, processes, ports, log paths, and resource thresholds — all from a single scan.

### Does it replace an admin?

No. The tool detects problems (failed folders, unreachable ports, stale logs, high resource usage) but does not fix them automatically. It provides actionable data so an admin can make informed decisions. Scheduled scans and Discord alerts reduce detection time from hours to minutes.

### Can I use it without a paid audit?

Absolutely. The full tool is free — all scripts, all features, no trial, no limits. The paid audit is an optional service for server owners who want an expert review of their setup. The tool works identically whether or not you ever request a paid audit.

### What do I send for a paid review?

Run the audit results bundle script:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1
```

This packages the JSON report, HTML report, and a manifest into a single zip. Optionally include your config and run log with `-IncludeConfig -IncludeLog`. Send the resulting zip along with a brief description of your setup and any specific concerns.

### Is my Discord webhook safe?

The webhook URL is stored in an environment variable (`$env:QUESTOPS_DISCORD_WEBHOOK_URL`). The tool never writes it to a file, never logs it, and never includes it in any generated output. If you use the scheduled task feature, the webhook must be set as a persistent environment variable for your Windows user account. See the [SECURITY.md](../SECURITY.md) for details.

---

## Final CTA

- **Download the tool** — free, no signup, no email required
- **Run a scan** — see your server health in 30 seconds
- **Request a paid audit** — expert review of your setup
- **Send an audit bundle** — one command packages everything for review

---

*This is a draft. All pricing is suggested and may be adjusted. The tool is provided as-is with no uptime guarantees.*
