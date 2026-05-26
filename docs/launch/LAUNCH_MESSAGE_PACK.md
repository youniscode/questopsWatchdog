# QuestOps Watchdog — Launch Message Pack

Refined message templates for the beta launch. Tone: helpful, calm, non-pushy, transparent that this is early.

---

## 1. Short Discord DM (cold outreach)

> Hey [name] — I saw you run a [game] server on Windows. I built a lightweight tool that checks server health (folder, disk, process, ports, logs, resources) and alerts on Discord when something fails.
>
> It's free, no dependencies, just PowerShell. I'm looking for a few beta users to test it and give feedback.
>
> Would you be interested in trying it? Happy to send the tool package and walk through the setup.

## 2. Community forum post

> **QuestOps Watchdog — free health checks for Windows game servers**
>
> If you self-host game servers on Windows (Project Zomboid, Minecraft, Valheim, etc.), you might find this useful.
>
> It checks:
> - Folder existence, disk space, process running
> - TCP port reachability (optional per server)
> - Log file freshness (optional per server)
> - Process CPU and memory usage (optional per server)
>
> Outputs a JSON report and optionally an HTML report (printable, no JS). Discord alerts on failure. Scheduled scans via Task Scheduler.
>
> PowerShell 5.1 only — no install, no dependencies, no cloud.
>
> I am also offering free beta audits: send me your scan outputs and I will review your config and give recommendations.
>
> Details: [link to GitHub repo]

## 3. Reddit/forum reply (to someone with lag or crash issues)

> I built a tool called QuestOps Watchdog that might help you diagnose this. It scans your Windows game server and checks folder, disk, process, ports, logs, and resource usage — then outputs a structured report.
>
> If you run the scan and share the report (no credentials, no personal data), I can review it for free as part of a beta audit and give recommendations.
>
> It is PowerShell-only, no install needed. Let me know if you want the tool package.

## 4. Follow-up after no response (5–7 days later)

> Hi [name] — just a gentle follow-up. I know you are busy, so no worries if the timing is not right. If you ever want to try the tool or have questions, feel free to reach out.

## 5. Message after someone expresses interest

> Great, glad you are interested! Here is what happens next:
>
> 1. I will send you the tool package (a clean zip with everything you need)
> 2. You validate the demo config, then create a local config for your servers
> 3. Run a scan and export the HTML report
> 4. Optionally create an audit results bundle and send it to me
>
> I will review the outputs and send you a summary with findings and recommendations. No charge, no obligation.
>
> Sound good?

## 6. Message when sending the audit package

> Here is the QuestOps Watchdog tool package. It includes:
> - All scripts and config templates
> - A client audit guide with step-by-step instructions
> - Documentation and demo examples
>
> Steps to get started:
> 1. Extract the zip anywhere on your Windows machine
> 2. Open PowerShell in the extracted folder
> 3. Run `.\validate_questops_config.ps1` to check the demo config
> 4. Copy `config\servers.game.example.json` to `config\servers.local.json`
> 5. Edit the paths in `servers.local.json` to match your servers
> 6. Run `.\questops_scan.ps1 -ConfigPath config\servers.local.json`
> 7. Run `.\export_questops_html_report.ps1` to generate the HTML report
>
> Let me know if you hit any issues!

## 7. Message when asking for the audit results bundle

> Thanks for running the scan! Could you send me the audit results bundle? Here is the command:
>
> ```powershell
> .\export_questops_audit_results.ps1
> ```
>
> This creates a zip in the `dist\` folder with your JSON report, HTML report, and a manifest. If you are comfortable, you can also include your config and log:
>
> ```powershell
> .\export_questops_audit_results.ps1 -IncludeConfig -IncludeLog
> ```
>
> Please review the contents before sending — no passwords, webhook URLs, or personal data needed. I only need the scan results to do the review.

## 8. Message after delivering the audit

> Your audit summary is ready! Here is what I found:
>
> - **Overall status:** [PASS / FAIL / MIXED]
> - **Top finding:** [Brief description]
> - **Quick fix:** [Brief description]
>
> The full summary is attached. Let me know if you have any questions about the findings.
>
> If you found this helpful, I would appreciate any feedback (takes 2 minutes): [optional link or ask them to reply with their thoughts]

## Tone notes

- Use "I built" not "we built" — keeps it personal and approachable
- Use "free" not "free tier" or "limited free" — the tool is fully free
- Offer the paid audit as a secondary option, never as the primary ask
- If someone asks for a feature that does not exist, say "not yet — good idea" rather than promising a timeline
- Never say "enterprise-grade" or "battle-tested" — this is an early tool
