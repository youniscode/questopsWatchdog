# QuestOps Watchdog — First Beta Audit Workflow

Describes the full process from initial contact through audit delivery. All steps are manual — no automation.

## Boundaries

- **No remote access by default.** The reviewer never connects to the client's machine.
- **No credentials requested.** The reviewer never asks for passwords, tokens, or webhook URLs.
- **Client controls what they send back.** The audit results bundle includes only what the client explicitly packages.
- **Optional config/log only after review.** The client may choose to redact or omit sensitive paths before including their config.

---

## Step 1: Qualify the server owner

Confirm the basics before proceeding:

- They run game servers on **Windows** (required — the tool does not work on Linux)
- They have **PowerShell 5.1** (comes with Windows — no install needed)
- They are comfortable running PowerShell commands
- They have a **specific issue or concern** they want the audit to address

If any of these are missing, the audit is unlikely to be productive.

## Step 2: Explain what the tool does and does not do

Send a brief explanation:

> QuestOps Watchdog checks folder existence, disk space, running processes, TCP port reachability, log freshness, and CPU/memory usage on your Windows game servers. It produces a JSON report and optionally an HTML report.
>
> It does not fix anything automatically. It does not require installation. It does not send data anywhere unless you configure a Discord webhook yourself.
>
> The paid audit is a manual review of your scan outputs, config, and setup. I will look for misconfigurations, threshold issues, missing checks, and security concerns — then give you written recommendations.

## Step 3: Send client-ready audit package

Create the tool package:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_package.ps1 -Force
```

Send the resulting zip from `dist\` along with the client audit guide (`docs/CLIENT_AUDIT_GUIDE.md`).

## Step 4: Client runs safe config validation

Ask the client to validate the demo config first:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1
```

Expected: exits 0, "valid=true".

## Step 5: Client creates local config

Ask the client to:
1. Copy `config\servers.game.example.json` to `config\servers.local.json`
2. Edit the paths to match their actual server setup
3. Validate the local config:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\validate_questops_config.ps1 -ConfigPath config\servers.local.json
   ```

## Step 6: Client runs scan

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\questops_scan.ps1 -ConfigPath config\servers.local.json
```

Ask them to note any warnings or errors in the console output.

## Step 7: Client exports HTML

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_html_report.ps1
```

## Step 8: Client creates audit results bundle

```powershell
# Basic bundle (report + HTML + manifest)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1

# Bundle with config and log (optional)
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\export_questops_audit_results.ps1 -IncludeConfig -IncludeLog
```

Ask the client to send the resulting zip from `dist\`.

## Step 9: Reviewer analyzes bundle

On receiving the bundle:

1. Extract the zip
2. Read `audit-results-manifest.json` — confirm all expected files are present
3. Read `latest-health-report.json` — identify PASS/FAIL per server
4. Review each failed check — determine if it is a real issue or a config problem
5. If config was included: review thresholds, paths, security
6. If log was included: review run history, errors, patterns
7. Document findings using the delivery template (BETA_AUDIT_DELIVERY_TEMPLATE.md)

## Step 10: Reviewer sends audit summary

Use the delivery template (BETA_AUDIT_DELIVERY_TEMPLATE.md) to write and send the audit summary.

Include:
- Thank you
- Scope reviewed
- Overall status (PASS / FAIL / MIXED)
- Top 3 findings
- Priority fixes
- What looks healthy
- What needs follow-up
- Suggested next steps

## Step 11: Optional follow-up support

If the client has questions about the findings, offer a brief Q&A session (text-based or a short call depending on the tier).

## Step 12: Collect testimonial or feedback if appropriate

If the client had a positive experience, ask if they would be willing to provide:
- A short testimonial (anonymous or attributed)
- Feedback via the feedback form (BETA_FEEDBACK_FORM.md)

Do not pressure. Respect their time.
