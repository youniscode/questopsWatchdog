# QuestOps Watchdog — Security Policy

## Supported versions

| Version | Supported |
|---------|-----------|
| v0.4.9+ | Yes — report security issues for the latest release |
| Older versions | No — upgrade to the latest release first |

## Reporting a security issue

If you discover a security vulnerability in QuestOps Watchdog, please report it privately:

- **Email:** (TBD — open a GitHub issue with `[security]` in the title as a fallback)
- **Do not** open a public GitHub issue for security vulnerabilities that could expose users (e.g. hardcoded credentials, webhook URL leaks).

Reports should include:
- Type of vulnerability
- Steps to reproduce
- Affected version(s)
- Any suggested fix (optional)

You should receive a response within 5 business days.

## Do not open public issues for:

- Leaked Discord webhook URLs or API tokens — rotate them immediately, then report privately
- Secrets found in your own config — the tool cannot prevent you from committing your own secrets
- Questions about secret management — see SECRET-HANDLING RULES in PROJECTMAP.md

## Secret handling policy

QuestOps Watchdog follows these rules:
- Never hardcode webhook URLs, passwords, tokens, or connection strings.
- Secrets come from environment variables (e.g. `$env:QUESTOPS_DISCORD_WEBHOOK_URL`) or gitignored local config files only.
- The export script runs a preflight safety scan to detect hardcoded Discord webhook URLs in included files.
- The scan script never writes secrets to reports or logs.
- If a secret is required, the script fails with a clear message if it is not set.

## Local-only / no telemetry

QuestOps Watchdog runs entirely on your machine. It does not:
- Phone home
- Collect telemetry or usage data
- Send data anywhere unless you explicitly configure a Discord webhook for alerts
- Store or transmit any information about your servers, config, or reports

All data stays local. You choose what to share (audit results bundle, config, logs) during a paid audit.
