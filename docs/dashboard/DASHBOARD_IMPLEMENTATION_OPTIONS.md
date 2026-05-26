# QuestOps Watchdog — Dashboard Implementation Options

## Option 1: Extend the existing HTML export script (recommended for v0.5)

Modify `scripts/export_questops_html_report.ps1` to produce a dashboard-like layout.

**How it works:**
- PowerShell reads the JSON report
- Generates a standalone HTML file with inline CSS
- Adds server cards, pass/fail badges, filtering (CSS-only or minimal inline JS)
- Writes to `reports/latest-health-report.html` or a new filename

**Pros:**
- No new scripts needed
- Leverages existing, tested export infrastructure
- Safe — no file system watchers, no servers
- Works fully offline
- Easy to print to PDF
- Same security model as the existing HTML report (no secrets, no JS from untrusted sources)

**Cons:**
- Requires re-running the export after each scan (no auto-refresh)
- HTML file regenerated each time (no persistence layer)
- Limited interactivity (no live filtering without JS)

**Security:**
- No network access
- No local file reads at runtime (data is baked into the HTML)
- No external dependencies

## Option 2: Standalone local HTML viewer (alternative)

Create a static HTML file that reads the JSON report from the filesystem using JavaScript.

**How it works:**
- A pre-built `dashboard.html` file is placed in the project root or `reports/`
- When opened in a browser, it uses `fetch()` or `XMLHttpRequest` to load `reports/latest-health-report.json`
- Renders the dashboard dynamically

**Pros:**
- No need to re-export after each scan — just refresh the browser
- More interactive (filtering, sorting without regeneration)

**Cons:**
- Browser CORS policies may block local file reads (`fetch` from `file://` protocol)
- Requires JavaScript to be enabled
- More complex security review needed

**Security:**
- No network access if the page is opened from `file://`
- If opened from a local server, there is a risk of data exposure — explicitly warn against this
- Must sanitize report content before rendering to avoid XSS

## Option 3: Small local web app (not recommended for v0.5)

Create a minimal local web server (Node.js, Python, or .NET) that serves the dashboard.

**Pros:**
- No CORS issues
- Can watch for file changes and auto-refresh
- More powerful interactivity

**Cons:**
- Adds dependencies (Node.js, Python, or .NET runtime)
- Increases complexity
- Requires running a background process
- Security surface area increases
- Contradicts the "no dependencies" principle

**Security:**
- Must bind to `127.0.0.1` only (not `0.0.0.0`)
- Must not expose the dashboard to the network
- Must not serve the JSON report to any other endpoint
- Adds a local HTTP server vulnerability

## Option 4: Keep the dashboard as export-only (fallback)

The current HTML report export already provides a basic visual representation. The dashboard could remain an evolution of this export rather than a separate component.

**Pros:**
- Minimum effort
- No new security concerns
- Existing workflow unchanged

**Cons:**
- Does not solve the "refresh after every scan" friction
- No filtering capability in the current export
- No per-server card layout

## Recommendation for v0.5

**Start with Option 1 — extend the existing HTML export script toward a dashboard-like layout.**

Rationale:
- Zero new dependencies
- Existing security model proven safe
- Fastest path to an MVP
- Can add filtering (CSS-only or minimal inline JS) without introducing risk
- Print-to-PDF works today
- If users request dynamic refresh, Option 2 (standalone viewer) can be added later as a separate file without breaking the export

Option 2 should be explored as a **v0.5.x enhancement** if there is demand for browser-refresh capability. Options 3 and 4 are not recommended for the initial v0.5 release.

**Avoid a full web app (Option 3) until there is clear evidence that a static HTML dashboard is insufficient.**
