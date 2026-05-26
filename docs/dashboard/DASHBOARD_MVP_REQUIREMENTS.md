# QuestOps Watchdog — Dashboard MVP Requirements

## Loading

- [ ] Load `reports/latest-health-report.json` from the local filesystem
- [ ] If the file does not exist, show a clear message: "No report found. Run a scan first."
- [ ] If the file exists but is malformed JSON, show: "Report file is malformed. Run a fresh scan."
- [ ] If the file exists but is missing required fields, show which fields are missing

## Overall status

- [ ] Show overall pass/fail badge (green PASS / red FAIL)
- [ ] Show scan timestamp (`scan_timestamp_utc`)
- [ ] Show server count, passed count, failed count
- [ ] Show config path if present in the report

## Server cards

- [ ] Each server is displayed as a card
- [ ] Server name is prominently displayed
- [ ] Card shows PASS or FAIL badge
- [ ] Card shows basic check statuses: folder_exists, disk_ok, process_running
- [ ] Basic checks show ✓ or ✗ icons
- [ ] Card background or border reflects pass/fail status (green/red)

## Failed categories

- [ ] If a server failed, show which categories failed
- [ ] Show the failure reason for each failed category (e.g. error message)
- [ ] Failed categories are visually distinct from passing ones

## Network check details

- [ ] If the server has `network_checks`, show a table or list
- [ ] Each entry shows: name, host, port, reachable, ok
- [ ] Failed entries are highlighted
- [ ] If no network_checks, show nothing or "No network checks configured"

## Log check details

- [ ] If the server has `log_checks`, show a table or list
- [ ] Each entry shows: name, path, age, max_age, ok
- [ ] Stale/missing entries are highlighted
- [ ] If no log_checks, show nothing

## Resource check details

- [ ] If the server has `resource_checks`, show a table or list
- [ ] Each entry shows: name, memory (current/max), CPU (current/max), ok
- [ ] Over-threshold entries are highlighted
- [ ] If no resource_checks, show nothing

## Timestamp

- [ ] Show `scan_timestamp_utc` at the top of the dashboard
- [ ] Show "Generated:" timestamp for the dashboard itself

## Filtering

- [ ] Show all servers by default
- [ ] Provide a toggle or filter to show only passing servers
- [ ] Provide a toggle or filter to show only failed servers
- [ ] Provide a toggle or filter to reset to show all servers
- [ ] Filters update the display immediately (CSS-only or minimal JS)

## Print-friendly

- [ ] Print stylesheet removes interactive elements (filters)
- [ ] Print output shows all servers with full details
- [ ] Print output includes the scan timestamp and dashboard generation timestamp
- [ ] Print output is monochrome-friendly (uses patterns/icons, not just colours)

## No external CDN

- [ ] All CSS is inline
- [ ] All JS (if any) is inline and minimal
- [ ] No external fonts, icons, or libraries
- [ ] The dashboard works fully offline

## No secrets displayed

- [ ] Webhook URLs are never shown
- [ ] Environment variables are never shown
- [ ] File paths are shown but clearly marked as informational

## Graceful handling

- [ ] Missing report → "No report found" message
- [ ] Malformed JSON → "Report file is malformed" message
- [ ] Empty results array → "No servers configured" message
- [ ] Missing optional fields → graceful fallback with "-" or "N/A"
- [ ] Very long server names → truncation or wrapping
- [ ] Many servers (10+) → scrollable layout
