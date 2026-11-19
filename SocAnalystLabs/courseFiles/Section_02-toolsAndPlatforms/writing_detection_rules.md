# Writing & Modifying Basic Detection Rules

## Overview

A **detection rule** describes behavior that should generate an alert. Rules are how a SOC turns raw telemetry into something an analyst can act on. Good rules catch real attacks without flooding the team with noise.

As a new analyst you should be able to:

- **Read** an existing rule and explain what it detects
- **Tweak** a rule to reduce false positives
- **Write** simple rules for well-understood behavior

<hr>

## Detection Rule Elements

Almost every rule format, whether it's Sigma, Elastic, or LimaCharlie, contains the same building blocks:

| Element | Purpose | Example |
|---|---|---|
| **Log Source** | Which data the rule runs against | Windows process creation events |
| **Condition** | The patterns or values to match | Parent process = `cmd.exe`, child process = `powershell.exe` |
| **Logic** | How the conditions combine | `selection AND NOT filter` |
| **Filters / Exceptions** | Known-good behavior to suppress false positives | Ignore `powershell.exe` launched by the SCCM agent |
| **Severity** | How urgent an alert should be | `high` |
| **MITRE ATT&CK Mapping** | The tactic and technique the rule covers | `attack.execution`, `attack.t1059.001` |
| **Metadata** | Title, description, author, references, known false positives | Helps the next analyst understand the rule |

<hr>

## Types of Detection Rules

| Rule Type | How It Works | Example |
|---|---|---|
| **Query / Match** | Alerts when a single event matches a pattern | PowerShell started with `-EncodedCommand` |
| **Threshold** | Alerts when a count passes a limit within a time window | 20 failed logons from one IP in 5 minutes |
| **Sequence / Correlation** | Alerts when events happen in a specific order | Several failed logons, then a success, for the same user |
| **New Terms / First Seen** | Alerts the first time a value appears | `psexec.exe` runs on a host for the first time |
| **Indicator Match** | Alerts when an event matches a threat intel indicator | A DNS query for a domain on a known-bad list |
| **Machine Learning / Anomaly** | Alerts on deviation from a learned baseline | A user downloads 50x more data than normal |

<hr>

## Sigma: A Vendor-Neutral Rule Format

**Sigma** is an open, YAML-based format for writing detection rules once and converting them to many SIEM query languages. It's a great format to learn because the community [Sigma repository](https://github.com/SigmaHQ/sigma) has thousands of rules you can read and borrow from.

### Example Sigma Rule

```yaml
title: Suspicious Encoded PowerShell Command Line
id: 1f2b8c4e-7a3d-4c5e-9b21-6d8f0a3e9c17
status: experimental
description: Detects PowerShell launched with an encoded command, which is often used to hide malicious scripts.
author: SOC Analyst Labs
date: 2026-11-19
tags:
  - attack.execution
  - attack.t1059.001
logsource:
  product: windows
  category: process_creation
detection:
  selection_img:
    Image|endswith:
      - '\powershell.exe'
      - '\pwsh.exe'
  selection_cli:
    CommandLine|contains:
      - ' -enc '
      - ' -EncodedCommand '
  condition: all of selection_*
falsepositives:
  - Legitimate administration or software deployment scripts that use encoded commands
level: high
```

### Reading the Rule

| Section | What It Means |
|---|---|
| `logsource` | Run against Windows process creation events (for example, Sysmon Event ID 1 or Security Event ID 4688) |
| `selection_img` | The process image ends with `powershell.exe` **or** `pwsh.exe` |
| `selection_cli` | The command line contains `-enc` **or** `-EncodedCommand` |
| `condition: all of selection_*` | Both selections must match |
| `level` | The resulting alert severity |

> **Tip:** Items in a **list** are combined with **OR**. Separate **selections** are combined using the `condition` line.

### Converting Sigma

Use [sigma-cli](https://github.com/SigmaHQ/sigma-cli) to convert a Sigma rule into a query for your SIEM:

```bash
# Install sigma-cli and the Elasticsearch backend
pip install sigma-cli
sigma plugin install elasticsearch

# Convert a rule to an Elastic (Lucene) query using the Windows ECS field mappings
sigma convert -t lucene -p ecs_windows encoded_powershell.yml
```

<hr>

## Elastic Rule Examples

### Custom Query (KQL)

Network logon failures (logon type 3):

```
event.code: 4625 and winlog.event_data.LogonType: 3
```

### Threshold Rule

Use the query below and set the threshold to **group by** `source.ip` with a count of **20** or more:

```
event.dataset: "windows.security" and event.code: 4625
```

### Sequence Rule (EQL)

Five failed logons followed by a successful logon on the same host within one minute:

```
sequence by host.name with maxspan=1m
  [authentication where event.outcome == "failure"] with runs=5
  [authentication where event.outcome == "success"]
```

<hr>

## LimaCharlie Rule Example

LimaCharlie uses **Detection & Response (D&R) rules**. The `detect` section describes what to match, and the `respond` section describes what to do about it.

Executable or script files written to user-writable locations:

```yaml
detect:
  event: FILE_CREATE
  op: matches
  path: event/FILE_PATH
  re: (?i)\\(temp|appdata\\roaming|users\\public)\\.*\.(exe|dll|ps1|vbs|bat)$
respond:
  - action: report
    name: suspicious-file-write
```

<hr>

## Modifying and Tuning Rules

Most of a new analyst's rule work is **tuning** existing rules, not writing new ones.

### Common Tuning Changes

| Problem | Tuning Approach |
|---|---|
| A known admin tool keeps triggering the rule | Add a **filter / exception** for that specific process, path, or account |
| The rule fires on normal low-volume activity | Raise the **threshold** or shorten the time window |
| The rule is too broad | Make the **condition** more specific (for example, also require an unusual parent process) |
| Severity doesn't match the real risk | Adjust the **severity** or risk score |
| Analysts don't understand the alert | Improve the **description** and add known **false positives** |

### Adding an Exception in Sigma

Exclude encoded PowerShell launched by a known management agent:

```yaml
detection:
  selection_img:
    Image|endswith:
      - '\powershell.exe'
      - '\pwsh.exe'
  selection_cli:
    CommandLine|contains:
      - ' -enc '
      - ' -EncodedCommand '
  filter_sccm:
    ParentImage|endswith: '\CcmExec.exe'
  condition: all of selection_* and not filter_sccm
```

> **Note:** Keep exceptions as **narrow** as possible. Excluding all of `C:\Windows\` might silence the false positives, but it also creates a perfect hiding spot for attackers.

<hr>

## Testing Your Rules

Never assume a rule works just because it looks correct.

1. **Generate the behavior safely.** Use a lab machine and a tool like [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team) to simulate the technique.
2. **Confirm the alert fires.** Check that the rule triggered and that the alert contains useful fields.
3. **Check for noise.** Run the rule's query over the last 7–30 days of data to see how many results normal activity would produce.
4. **Document and version.** Record what changed and why. Many teams store rules in Git so changes can be reviewed and rolled back.

<hr>

## Common Pitfalls

| Pitfall | Why It's a Problem |
|---|---|
| Matching on file **name** only | Attackers can rename `mimikatz.exe` to `notepad.exe`. Use hashes, `OriginalFileName`, or behavior. |
| Case-sensitive matches | `PowerShell.exe` and `powershell.exe` may not both match. |
| Overly broad exceptions | Hides real attacks along with the noise. |
| No testing | A rule with a typo in a field name will silently never fire. |
| Missing context | An alert with no description wastes the next analyst's time. |

<hr>

## Check Your Understanding

1. In Sigma, how are multiple values in the same list combined?
2. Which rule type would you use to alert on 20 failed logons from one IP in 5 minutes?
3. A rule fires every night because of an approved backup script. What's the best fix?
4. Why is matching only on a process name a weak detection?

<details>
<summary>Answers</summary>

1. With **OR**: any one of the listed values can match.
2. A threshold rule.
3. Add a narrow exception for that specific script, path, or service account, and document why.
4. Attackers can rename a binary. Matching on hashes, `OriginalFileName`, or behavior is more reliable.

</details>
