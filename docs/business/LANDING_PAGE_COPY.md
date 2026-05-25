# QuestOps Watchdog — Landing Page Copy

Draft copy for a commercial landing page or service announcement.

---

## Headline options

**Option A (direct):**
> Know your game servers are healthy — before your players tell you.

**Option B (technical):**
> Automated health monitoring for self-hosted game servers on Windows.

**Option C (pain-point):**
> Never discover a crashed server from a Discord complaint again.

## Subheadline

QuestOps Watchdog checks folder existence, disk space, process health, network reachability, log freshness, and resource usage — then alerts you on Discord if something is wrong.

## Key benefits

| Benefit | Detail |
|---------|--------|
| No dependencies | PowerShell 5.1 only — no Node, Python, or databases. Runs on any Windows machine. |
| Lightning setup | Download, edit a JSON config, run. Takes 5 minutes. |
| Discord alerts | Get pinged the moment a server goes down or a disk fills up. |
| Client-ready | Export a clean package for clients. Export HTML reports. Bundle results for audit. |
| No cloud required | Everything runs locally. Your servers, your data, your control. |

## Call to action

> **[Download the latest release](https://github.com/your-org/questops-watchdog/releases)** — free and open-source.
>
> Need a deeper analysis? **[Order a paid audit](PAID_AUDIT_OFFER.md)** — from €49.

## Social proof / positioning

> "QuestOps Watchdog caught a disk filling up at 3 AM. The alert woke me, I cleared space before any downtime." — *Beta user*

## Feature highlights (for the "How it works" section)

1. **Run a scan** — `powershell -File scripts\questops_scan.ps1`
2. **Get alerted** — Discord webhook sends failed-server details with per-category breakdown
3. **Export reports** — HTML audit reports with inline CSS, no JavaScript, safe for print-to-PDF
4. **Schedule it** — Windows Task Scheduler installer runs scans automatically every 15 minutes
5. **Package for clients** — Clean zip with safety scan, ready to send to server owners
6. **Bundle results** — Package outputs (JSON + HTML + manifest) for paid audit review

## Pricing mention

| Service | Price |
|---------|-------|
| Free tool | €0 — full-featured, no limits, no trial |
| Quick Scan audit | €49 — single server config + report review |
| Standard Audit | €149 — 1–3 servers, full review + recommendations |
| Comprehensive Audit | €299 — up to 10 servers, includes follow-up call |

## Footer / trust signals

- **Open source** — inspect every line of code, no telemetry, no phone-home
- **No lock-in** — uses plain JSON configs and standard Windows tools
- **Privacy-first** — runs entirely on your machine, no data leaves your network unless you send it
