# QuestOps Watchdog — Homepage Wireframe

Simple text wireframe of the proposed homepage layout.

```
┌─────────────────────────────────────────────────────────────────┐
│  [Logo] QuestOps Watchdog          [GitHub] [Docs] [Download]   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                                                           │  │
│  │  Know your game servers are healthy                      │  │
│  │  — before your players tell you.                         │  │
│  │                                                           │  │
│  │  A lightweight, zero-dependency health monitor for         │  │
│  │  Windows game servers. Checks folders, disks, processes,   │  │
│  │  ports, logs, and resource usage — then alerts you on      │  │
│  │  Discord when something fails.                             │  │
│  │                                                           │  │
│  │  [Download the tool — free]   [See how it works ↓]        │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                  │
├─ Trust / Security Strip ────────────────────────────────────────┤
│                                                                  │
│  [No cloud]    [No telemetry]    [No install]    [Open source]   │
│                                                                  │
├─ Feature Cards ─────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌──────────┐  │
│  │ 6 Checks   │  │ Discord    │  │ HTML       │  │ Scheduled│  │
│  │ folder     │  │ Alert      │  │ Report     │  │ Scans    │  │
│  │ disk       │  │ plain-text │  │ print-to-  │  │ Task     │  │
│  │ process    │  │ per-server │  │ PDF safe   │  │ Sched.   │  │
│  │ network    │  │ breakdown  │  │ no JS/CDN  │  │ every N  │  │
│  │ logs       │  │            │  │            │  │ minutes  │  │
│  │ resources  │  │            │  │            │  │          │  │
│  └────────────┘  └────────────┘  └────────────┘  └──────────┘  │
│                                                                  │
├─ Demo Preview Block ────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  See what QuestOps Watchdog produces                     │   │
│  │                                                          │   │
│  │  [Sample JSON] [Sample HTML] [Sample Discord] [Before/   │   │
│  │   Report       Preview       Alert         After Story]  │   │
│  │                                                          │   │
│  │  All examples use fictional servers and data.            │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
├─ Pricing Cards ─────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────┐ │
│  │ Quick Scan   │  │ Standard     │  │ Deep Audit   │  │Custom│ │
│  │ €49          │  │ Audit €149   │  │ €299         │  │€499+ │ │
│  │ 1 server     │  │ 1-3 servers  │  │ 4-10 servers │  │10+   │ │
│  │ config+report│  │ full review  │  │ full + call  │  │priority│ │
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────┘ │
│                                                                  │
├─ How It Works Timeline ─────────────────────────────────────────┤
│                                                                  │
│  1. Download  ──→  2. Validate  ──→  3. Scan  ──→  4. Export    │
│  tool package      config             servers    HTML report     │
│                                          │                       │
│                                          └──→  5. Audit bundle   │
│                                                  (optional)      │
│                                                                  │
├─ FAQ Section ───────────────────────────────────────────────────┤
│                                                                  │
│  Q: Does this require installing anything?                       │
│  A: No. PowerShell 5.1 is built into Windows.                   │
│                                                                  │
│  Q: Does it work on Linux?                                       │
│  A: No. Windows only.                                            │
│                                                                  │
│  Q: Can I use it without a paid audit?                           │
│  A: Yes — the full tool is free.                                 │
│                                                                  │
│  ... (more FAQ items)                                            │
│                                                                  │
├─ Footer ────────────────────────────────────────────────────────┤
│                                                                  │
│  QuestOps Watchdog — MIT ? No license yet. See LICENSE-NOTE.md   │
│  [GitHub] [Security] [Contributing] [Paid audit details]         │
│                                                                  │
│  "Know your game servers are healthy — before your players       │
│   tell you."                                                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Notes

- The wireframe is a layout guide, not a design specification.
- Actual spacing, colors, fonts, and responsive breakpoints would be determined during implementation.
- The trust/security strip should use icons or small badges for visual clarity.
- Feature cards could include small icons (shield, bell, file, clock).
- Pricing cards should have a clear visual hierarchy — recommended tier highlighted.
- The "See how it works" CTA could scroll to the How It Works section or open a demo modal.
