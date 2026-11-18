![image](/FilesForLabs/images/blueantisyphon.png)

# Security Tools & Foundational Platforms

> **Hands-On Labs:** [LimaCharlie Lab](/SocAnalystLabs/courseFiles/Section_02-toolsAndPlatforms/lima_charlie_lab_part1.md) · [Elastic Cloud Lab](/SocAnalystLabs/courseFiles/Section_02-toolsAndPlatforms/elasticLabCloud.md) · [Elastic Local Lab](/SocAnalystLabs/courseFiles/Section_02-toolsAndPlatforms/elasticLabLocal.md)

<hr>

## Overview

**Security tools and foundational platforms** are the core technologies used to detect, investigate, and respond to cyber threats. These include tools that collect and analyze data from endpoints, networks, and systems to provide visibility into suspicious activity.

### Categories of Security Tools

| Category | What It Does | Examples |
|---|---|---|
| **Endpoint Detection and Response (EDR)** | Monitors activity on endpoints (workstations and servers), collects telemetry, and enforces detection logic in real time | LimaCharlie |
| **Security Information and Event Management (SIEM)** | Aggregates logs from across the infrastructure and provides detection rules, dashboards, and analytics | Elastic SIEM |
| **Network Monitoring Tools** | Inspect raw network traffic to identify anomalies or known malicious behavior | Zeek, Wireshark |

This page introduces interns to the **foundational tools and platforms** used daily in a SOC environment. Understanding how data flows from endpoints to security platforms — and how to investigate, triage, and act — is key to being an effective SOC analyst.

<hr>

## LimaCharlie Hands-On

**LimaCharlie** is a cybersecurity operations and infrastructure platform built to help security teams identify, address, and manage threats at scale. Designed for security engineers and SOC analysts, it provides an adaptable, API-driven alternative to conventional Endpoint Detection and Response (EDR) systems.

> **Hands-On Lab:** Try the two-part [LimaCharlie Lab](/SocAnalystLabs/courseFiles/Section_02-toolsAndPlatforms/lima_charlie_lab_part1.md).

### Rule Examples

**DNS request to a known-bad domain**

```yaml
event: DNS_REQUEST
op: is
path: event/DOMAIN_NAME
value: bad.example
actions:
  - action: report
    name: "DNS to bad.example"
```

**Process in a Temp folder launching PowerShell**

```yaml
event: NEW_PROCESS
op: and
rules:
  - op: contains
    path: event/FILE_PATH
    value: \AppData\Local\Temp\
  - op: ends with
    path: event/PROC_NAME
    value: powershell.exe
actions:
  - action: report
    name: "Temp -> PowerShell"
```

**LSASS access attempt (handle open)**

```yaml
event: HANDLE_REQUEST
op: and
rules:
  - op: ends with
    path: event/TARGET/PROC_NAME
    value: lsass.exe
  - op: is
    path: event/ACCESS
    value: PROCESS_VM_READ
actions:
  - action: report
    name: "LSASS read attempt"
```

**Persistence via a Run key**

```yaml
event: REGISTRY_EDIT
op: starts with
path: event/REG_PATH
value: HKCU\Software\Microsoft\Windows\CurrentVersion\Run\
actions:
  - action: report
    name: "Run key persistence"
```

<hr>

## Elastic SIEM Hands-On

**Elastic SIEM** is part of the Elastic Stack (Elasticsearch, Logstash, and Kibana). It provides a flexible and powerful SIEM solution for log ingestion, search, visualization, and detection. Start with the [Elastic SIEM Docs](/SocAnalystLabs/courseFiles/tools/Elastic_Doc_Cloud.md) to get it set up.

> **Hands-On Labs:** After setup, try the [Cloud Version Lab](/SocAnalystLabs/courseFiles/Section_02-toolsAndPlatforms/elasticLabCloud.md) to run on our VM, or the [Local Version Lab](/SocAnalystLabs/courseFiles/Section_02-toolsAndPlatforms/elasticLabLocal.md) if you want to install it on your own system.

<br>

### Rule Examples

**PowerShell with an encoded command**

```
event.category:process and event.type:start and
process.name:("powershell.exe","pwsh.exe") and
process.command_line:(*"-enc"* or *"-EncodedCommand"* or *"FromBase64String("*)
```

**Deleting Volume Shadow Copies**

```
event.category:process and event.type:start and
process.name:"vssadmin.exe" and process.command_line:(*delete* and *shadows*)
```

**Multiple failed logons from one IP (Threshold rule logic)**

```
event.dataset:"windows.security" and winlog.event_id:4625
```

**New Terms: First-time admin tool seen on a host**

```
event.category:process and process.name:(psexec*.exe or "wmic.exe" or "at.exe" or "schtasks.exe")
```

<hr>

## Viewing Alerts & Logs

SOC analysts must interpret alerts in context and verify that they are valid.

### Understanding Alerts

| Element | What to Look For |
|---|---|
| **Components** | Rule name, severity, MITRE technique, timestamp, affected host/user, raw log snippet |
| **Enrichment** | Threat intel (for example, a VirusTotal hash lookup), geolocation, asset context |

**Triage Steps**

1. Is this known-good or benign behavior?
2. Can we correlate with other logs to confirm malicious intent?
3. Are other hosts showing similar behavior?

<br>

### Log Types to Recognize

| Log Type | What It Contains |
|---|---|
| **Windows Event Logs** | Security, System, and Application events |
| **Sysmon Events** | Detailed host telemetry |
| **Firewall Logs** | Source/destination IP, port, and action |
| **DNS Logs** | Lookups, including those to malicious domains |
| **Web Proxy Logs** | User agent and URLs visited |

<hr>

## Writing & Modifying Basic Detection Rules

Detection rules define which behavior is suspicious and should generate an alert. Interns should be able to read, tweak, and eventually write basic rules.

<br>

### Detection Rule Elements

| Element | Purpose |
|---|---|
| **Condition** | The patterns or values to match (for example, parent process = `cmd.exe`, child process = `powershell.exe`) |
| **Filters / Exceptions** | Known-good behaviors to suppress false positives |
| **Severity & Tactic** | Classification based on MITRE ATT&CK |

<br>

### Examples by Rule Format

| Format | Example |
|---|---|
| **Sigma Rule (YAML)** | Detect PowerShell with Base64-encoded strings |
| **Elastic Rule (KQL)** | `event.code: 4625 and winlog.event_data.LogonType: 3` |
| **LimaCharlie Rule (YAML)** | Match file writes to suspicious locations |

<hr>

## Telemetry Searching

Analysts often need to go beyond alerts and search raw telemetry for related or supporting evidence.

<br>

### Key Skills

| Skill | Description |
|---|---|
| **Search Syntax** | Learn how to query data (for example, KQL in Elastic or telemetry filters in LimaCharlie) |
| **Pivoting** | Move from an IP to related processes, users, or domains |
| **Filtering** | Narrow by time range, hostname, or event type |

<br>

### Common Use Cases

1. "Show all PowerShell executions on this host in the last 24 hours."
2. "List all logon events from a suspicious IP."
3. "Search for DLL side-loading activity using Sysmon logs."
