# QuestOps Watchdog — Outreach Message Templates

Templates for reaching out to game server owners, hosting providers, and communities.

---

## Template 1: Cold message to a server owner (Discord DM)

> Hey [name]! I saw you run a [game] server — awesome.
>
> I built a lightweight Windows tool called QuestOps Watchdog that checks if your game server is actually healthy (folder, disk space, process, ports, log freshness, CPU/memory) and sends a Discord alert the moment something fails.
>
> It's free, no dependencies, just PowerShell. Takes 5 minutes to set up.
>
> Would you be interested in checking it out? Happy to send over the package and a quick walkthrough.

## Template 2: Community forum post

> **QuestOps Watchdog — Free health monitoring for Windows game servers**
>
> If you self-host game servers on Windows (Project Zomboid, Minecraft, etc.), you might find this useful.
>
> It checks folder existence, disk space, running processes, TCP port reachability, log freshness, and resource usage — then sends a Discord alert on failure.
>
> Features:
> - PowerShell 5.1 only (no Node, Python, DB)
> - Discord alerting with per-server failure details
> - HTML audit report export (inline CSS, print-to-PDF safe)
> - Scheduled scans via Task Scheduler
> - Client-ready audit package
>
> Free and open-source. Details and download: https://github.com/your-org/questops-watchdog
>
> I also offer paid audits (from €49) for deeper config review and recommendations. Happy to answer questions!

## Template 3: Follow-up after a free audit

> Hi [name],
>
> I've completed the quick review of your QuestOps Watchdog results. Key findings:
>
> - [Finding 1]
> - [Finding 2]
>
> The full report is attached. If you'd like a deeper dive (config tuning, security check, recommendations), I offer paid audits starting at €49.
>
> Let me know if you have any questions!

## Template 4: Hosting provider partnership pitch

> Hi [provider name],
>
> I built QuestOps Watchdog — a free, lightweight server health monitoring tool for Windows game servers. It checks folder/disk/process/network/log/resource health and alerts on Discord.
>
> It's PowerShell-only (no deps), exports HTML reports, and produces audit-ready bundles.
>
> I'm looking to partner with hosting providers to offer this to their clients as a value-add. I also offer paid audit services for deeper analysis.
>
> Would you be open to a 15-minute call to discuss?

## Template 5: Social media teaser (short)

> Your game server can crash at 3 AM. QuestOps Watchdog wakes you up.
>
> Free Windows tool. PowerShell only. Discord alerts. HTML reports.
>
> https://github.com/your-org/questops-watchdog
>
> \#gameservers \#devops \#selfhosting \#projectzomboid \#minecraft

## Template 6: Paid audit intro to an existing free user

> Hi [name],
>
> Thanks for using QuestOps Watchdog! If you'd like a professional review of your setup, I now offer paid audits:
>
> - **Quick Scan (€49):** Review your config and latest report
> - **Standard (€149):** Full review + written recommendations for 1–3 servers
> - **Comprehensive (€299):** Up to 10 servers + follow-up call
>
> All you need to send is the audit results bundle from `export_questops_audit_results.ps1`.
>
> Interested? Let me know!
