# QuestOps Watchdog — Beta Audit Intake Form

Copy and paste these questions when a server owner expresses interest in a beta audit. Edit or omit questions as needed for the conversation flow.

No invasive questions. No credentials. No passwords. No webhook URLs.

---

## Intake questions

### 1. Server game type

What game(s) are you hosting? (e.g. Project Zomboid, Minecraft, Valheim, ICARUS, other)

### 2. Windows version

What version of Windows are you running? (Run `[Environment]::OSVersion` in PowerShell)

### 3. PowerShell version

What PowerShell version do you have? (Run `$PSVersionTable.PSVersion` — only needed if you are unsure whether you have PowerShell 5.1)

### 4. Number of servers

How many game servers do you run on this machine?

### 5. Hosting machine specs

What are the specs of the machine? (CPU, RAM, storage type, dedicated or shared)

### 6. Main symptoms

What symptoms or issues are you seeing? (e.g. lag, crashes, players cannot connect, high memory, disk full)

### 7. Recent crashes or lag

Have you had any crashes, freezes, or lag spikes in the last 7 days? If yes, describe what happened.

### 8. Player count

Approximately how many players connect across all your servers?

### 9. Mods/plugins count

Do you use mods or plugins? Approximately how many?

### 10. Current monitoring tools

Do you currently use any monitoring or alerting tools? If yes, what?

### 11. What they want help with

What would you like the audit to focus on? (e.g. general health check, specific failure, security review, performance tuning)

### 12. Audit results bundle

Would you be comfortable running the scan and sharing the audit results bundle (JSON report, HTML report, optionally the config and log)?

> The bundle contains only your scan outputs. You can review what is included before sending it. No credentials, no webhook URLs, and no private data are collected by the tool.

### 13. Consent (copy/paste this paragraph)

> By sharing your audit results bundle, config file, or run log with me, you agree that I may review these files for the purpose of providing operational guidance and recommendations. You confirm that you have redacted or omitted any sensitive information (passwords, tokens, webhook URLs, personal data) before sharing. I will not store your files beyond the audit period unless you give explicit permission. I will not share your data with third parties.
>
> **Yes, I agree** / **No, I am not comfortable**

---

## After the intake

If the server owner is comfortable proceeding:
1. Send them the client-ready audit package (see FIRST_BETA_AUDIT_WORKFLOW.md, Step 3)
2. Walk them through the steps to run a scan and create the audit results bundle
3. Once you receive the bundle, analyze it and use the delivery template to write the audit summary
