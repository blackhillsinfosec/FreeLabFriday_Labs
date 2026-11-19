# Telemetry Searching

## Overview

**Telemetry** is the raw data your tools collect: every process start, network connection, DNS lookup, and logon. **Alerts** are only the small slice of telemetry that matched a rule. To confirm an alert, scope an incident, or hunt for threats that never triggered an alert, analysts need to search the telemetry directly.

Searching telemetry helps you:

- **Confirm** what an alert is telling you
- **Scope** an incident by finding every affected host, user, and indicator
- **Pivot** from one clue to related activity
- **Hunt** for attacker behavior that no rule caught

<hr>

## Query Languages You'll See

| Language | Used In | Example |
|---|---|---|
| **KQL (Kibana Query Language)** | Elastic / Kibana search bar | `process.name: "powershell.exe"` |
| **Lucene** | Elastic, many other tools | `process.name:powershell.exe` |
| **EQL (Event Query Language)** | Elastic sequence and correlation rules | `process where process.name == "powershell.exe"` |
| **ES\|QL** | Elastic piped queries | `FROM logs-* \| WHERE process.name == "powershell.exe"` |
| **SPL** | Splunk | `index=windows process_name=powershell.exe` |
| **LCQL** | LimaCharlie | `-24h \| plat == windows \| NEW_PROCESS \| event/FILE_PATH contains "powershell"` |

> **Note:** Microsoft Sentinel and Defender use a different "KQL" (Kusto Query Language). It shares the abbreviation with Kibana's KQL but is a completely different language.

<hr>

## KQL Basics (Elastic)

| Goal | Syntax | Example |
|---|---|---|
| Field equals value | `field: value` | `host.name: "WS-FINANCE-07"` |
| Any of several values | `field: (a or b)` | `process.name: ("powershell.exe" or "pwsh.exe")` |
| Wildcard | `*` | `process.command_line: *Invoke-WebRequest*` |
| Combine conditions | `and`, `or` | `event.code: 4625 and source.ip: "203.0.113.50"` |
| Exclude | `not` | `not user.name: "svc_backup"` |
| Range | `>`, `>=`, `<`, `<=` | `destination.port >= 1024` |
| Field exists | `field: *` | `dns.question.name: *` |
| Group logic | `( )` | `(event.code: 4624 or event.code: 4625) and user.name: "jsmith"` |

> **Tip:** Set the **time range** with the time picker first. A good query over the wrong 15 minutes still returns nothing.

<hr>

## Common Fields (Elastic Common Schema)

Elastic normalizes data into the **Elastic Common Schema (ECS)**, so the same field names work across many log sources.

| Field | What It Contains |
|---|---|
| `@timestamp` | When the event happened |
| `host.name` | The machine name |
| `user.name` | The account involved |
| `event.code` | The original event ID (for example, `4625` or Sysmon `1`) |
| `event.category` / `event.outcome` | The type of event (process, network, authentication) and whether it succeeded or failed |
| `process.name` / `process.command_line` | The process and its full arguments |
| `process.parent.name` | The process that launched it |
| `source.ip` / `destination.ip` / `destination.port` | Network connection details |
| `dns.question.name` | The domain that was looked up |
| `url.full` | The full URL that was requested |
| `winlog.event_data.*` | Raw Windows event fields that aren't mapped to ECS |

<hr>

## Pivoting

**Pivoting** means using one piece of evidence to find related evidence. Each search answers a question and raises the next one.

```
Alert: suspicious IP 203.0.113.50 connected to WS-FINANCE-07
  → Which process made the connection?        process.name: "rundll32.exe"
    → What launched that process?             process.parent.name: "WINWORD.EXE"
      → Which user was logged on?             user.name: "jsmith"
        → Did other hosts contact that IP?    destination.ip: "203.0.113.50"
          → Did anyone resolve its domain?    dns.question.name: "update-cdn[.]net"
```

### Common Pivot Points

| Start With | Pivot To |
|---|---|
| **IP address** | Hosts that connected to it, processes that made the connection, DNS names that resolved to it |
| **Domain** | Hosts that queried it, proxy requests to it, related IPs |
| **Process** | Parent process, child processes, network connections, files written |
| **User** | Logons, hosts accessed, processes run, recent password changes |
| **File hash** | Every host where the file exists or ran |

<hr>

## Filtering

Good filtering turns millions of events into a handful you can actually read.

| Filter | Why |
|---|---|
| **Time range** | Start narrow around the alert, then widen to find the beginning of the activity |
| **Host** | Focus on the affected machine first |
| **Event type** | Look only at process, network, or authentication events as needed |
| **Exclude known noise** | Remove known-good service accounts or management tools with `not` |

<hr>

## Common Use Cases

### 1. "Show all PowerShell executions on this host in the last 24 hours"

Set the time picker to **Last 24 hours**, then:

```
host.name: "WS-FINANCE-07" and event.category: "process" and process.name: ("powershell.exe" or "pwsh.exe")
```

Add `process.command_line` and `process.parent.name` as columns so you can quickly spot unusual arguments or parents.

### 2. "List all logon events from a suspicious IP"

```
event.code: (4624 or 4625) and source.ip: "203.0.113.50"
```

Add `user.name`, `host.name`, `event.outcome`, and `winlog.event_data.LogonType` as columns. Failures followed by a success is a classic sign of a password attack.

### 3. "Search for DLL side-loading activity using Sysmon logs"

DLL side-loading tricks a legitimate program into loading a malicious DLL. Sysmon **Event ID 7 (Image Loaded)** records every DLL a process loads.

```
event.code: "7" and winlog.event_data.Signed: "false"
```

Look for **unsigned DLLs** loaded by **signed, legitimate programs** from **unusual paths** like `AppData`, `Temp`, `ProgramData`, or `Users\Public`.

> **Note:** Sysmon Event ID 7 is very high volume and is often disabled or heavily filtered in Sysmon configs. If you get no results, check whether your environment collects it.

<hr>

## Searching in LimaCharlie

LimaCharlie offers two main ways to search telemetry:

- **Timeline:** browse every event for a single sensor in time order. Great for seeing exactly what happened on one host.
- **Query (LCQL):** search across sensors with a piped query.

LCQL queries follow the pattern `time range | sensor selector | event types | filter`:

```
-24h | plat == windows | NEW_PROCESS | event/COMMAND_LINE contains "powershell"
```

<hr>

## Search Tips

| Tip | Why It Matters |
|---|---|
| **Normalize to UTC** | Different tools display times in different zones |
| **Start broad, then narrow** | Make sure data exists before adding filters |
| **Save useful queries** | Reuse them during the next incident |
| **Record every query you run** | Your notes become the investigation timeline |
| **Check data coverage** | "No results" can mean "no attack" **or** "no logs" |

<hr>

## Check Your Understanding

1. What is the difference between an alert and telemetry?
2. Write a KQL query that finds failed logons for the user `jsmith`.
3. You find a suspicious IP. Name three things you could pivot to.
4. Your DLL side-loading search returns nothing. What are two possible reasons?

<details>
<summary>Answers</summary>

1. Telemetry is all the raw data that's collected. Alerts are the small subset of telemetry that matched a detection rule.
2. `event.code: 4625 and user.name: "jsmith"`
3. Any three of: hosts that connected to it, the processes that made the connections, DNS names that resolved to it, or other IPs in the same range or ASN.
4. There may be no side-loading activity, **or** Sysmon Event ID 7 may not be collected in your environment.

</details>
