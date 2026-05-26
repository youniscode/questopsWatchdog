# QuestOps Watchdog — Screenshot Redaction Guide

All screenshots must be free of real data before being added to this repository or used in any public-facing materials. This guide defines what to redact and how.

## Redaction rules

### 1. File paths

| What | Replace with |
|------|--------------|
| Real `C:\GameServers\...` paths | `C:\GameServers\Demo\...` or `C:\Servers\...` |
| Real user profile paths | `C:\Users\Admin\...` |
| Real temp paths | `C:\Temp\...` |

Keep the folder structure the same; only change the root/host name.

### 2. Discord webhook URLs

| What | Replace with |
|------|--------------|
| Real webhook URL | `https://discord.com/api/webhooks/demo/demo` |
| Webhook ID | `000000000000000000` |
| Webhook token | `demo_token_redacted` |

Never include a real webhook URL in any screenshot, even partially.

### 3. JSON config content

| What | Replace with |
|------|--------------|
| Real server names | `"Demo Server"`, `"Demo Project Zomboid"`, `"Demo Minecraft"` |
| Real IP addresses | `"127.0.0.1"`, `"192.0.2.10"`, `"192.0.2.20"` |
| Real ports | Keep as-is (ports are generic and not sensitive) |
| Real webhook URLs | `"https://discord.com/api/webhooks/demo/demo"` |
| Real process names | Keep as-is (`ProjectZomboid.exe`, `java.exe`) or use fictional |

### 4. PowerShell terminal output

| What | Replace with |
|------|--------------|
| Real server names in output | Keep matching the demo config names |
| Real IPs in output | `192.0.2.x` |
| Real paths in error messages | `C:\GameServers\Demo\...` |
| Real usernames | `Admin` or remove |
| System environment variables | Do not show `$env:...` values that reveal real paths |

### 5. Usernames and player names

| What | Replace with |
|------|--------------|
| Real Windows usernames | `Admin`, `ServerAdmin` |
| Real game player names | `Player1`, `DemoPlayer` |
| Real Discord usernames | `User#0000`, `DemoUser` |

### 6. IP addresses

| What | Replace with |
|------|--------------|
| Public IPs | `192.0.2.x` (documentation prefix per RFC 5737) |
| Private IPs (10.x.x.x, 172.x.x.x, 192.168.x.x) | `192.0.2.x` |
| Localhost | `127.0.0.1` (safe to keep) |

### 7. Timestamps and dates

Real timestamps are generally safe to keep (they don't reveal sensitive information). If you prefer, replace with a consistent fictional date.

### 8. Discord message content

| What | Replace with |
|------|--------------|
| Real server names in embeds | Demo server names |
| Real player counts | Small fictional numbers (1/100, 5/100) |
| Real channel names | `#server-alerts`, `#demo` |

## Redaction methods

| Tool | Method | Notes |
|------|--------|-------|
| Paint 3D | Select area → Fill with solid color | Quick for small sections |
| ShareX | Annotation → Pixelate region | Built-in pixelation tool |
| GIMP | Blur tool or Pixelize filter | Best for complex backgrounds |
| ImageMagick | `-region` + `-blur` | Batch redaction potential |

## Verification

Before adding a screenshot to the repository:

- [ ] No real webhook URLs visible
- [ ] No real IP addresses visible
- [ ] No real server or client names visible
- [ ] No real player or Discord usernames visible
- [ ] No real file paths with user-specific components visible
- [ ] Blur/pixelation is not reversible (use solid color overlay if concerned)
- [ ] Redaction is applied to the full occurrence (every instance in the image)

## Related

- [Capture checklist](SCREENSHOT_CAPTURE_CHECKLIST.md) — what screenshots to take
- [Review checklist](SCREENSHOT_REVIEW_CHECKLIST.md) — what to check before publishing
