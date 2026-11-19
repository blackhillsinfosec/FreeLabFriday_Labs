# Viewing Alerts & Logs


<hr>

## Overview

Security tools generate **alerts** when something matches a detection rule. An alert is not proof of an attack. It is a signal that something *might* be wrong and needs a human to look at it. SOC analysts spend much of their day reviewing these alerts, deciding whether they are real, and figuring out what happened.

To do that well, an analyst needs to:

- **Read an alert** and understand exactly what it is claiming
- **Gather context** from the raw logs and other data sources
- **Decide** whether the activity is malicious, benign, or needs more investigation
- **Document** the decision so others can follow it

<hr>

## Anatomy of an Alert

Most SIEM and EDR alerts contain the same core pieces of information:

| Component | What It Tells You | Example |
|---|---|---|
| **Rule Name** | Which detection fired | `Suspicious Encoded PowerShell Command` |
| **Severity / Risk Score** | How urgent the rule author thinks it is | `High` / `73` |
| **MITRE ATT&CK Mapping** | The tactic and technique the behavior relates to | Execution, `T1059.001` |
| **Timestamp** | When the activity happened (usually UTC) | `2026-03-14T02:17:44Z` |
| **Host** | Which machine the activity occurred on | `WS-FINANCE-07` |
| **User** | Which account performed the activity | `CORP\jsmith` |
| **Process / Command Line** | What actually ran | `powershell.exe -nop -w hidden -enc ...` |
| **Raw Event / Evidence** | The original log(s) that triggered the rule | The full Sysmon Event ID 1 record |
| **Status** | Where the alert is in its lifecycle | `Open`, `Acknowledged`, `Closed` |

> **Tip:** Always open the raw event. The alert summary only shows the fields the rule author chose to display. The raw log often contains the detail that changes your decision.

<hr>

## Alert Severity Levels

Severity helps you decide what to look at first. Every organization defines these slightly differently, but a common model looks like this:

| Severity | Typical Meaning | Expected Response |
|---|---|---|
| **Critical** | High-confidence detection of active compromise (for example, ransomware behavior or credential dumping) | Investigate immediately and escalate |
| **High** | Strong indicator of malicious activity | Investigate as soon as possible |
| **Medium** | Suspicious activity that is often malicious but can be legitimate | Investigate within your normal queue |
| **Low** | Unusual activity, frequently benign | Review when time allows, or use for hunting |
| **Informational** | Context only, not suspicious by itself | No action; useful when correlating |

<hr>

## Alert Outcomes

Every alert you close should end up in one of these categories:

| Outcome | Meaning | Example |
|---|---|---|
| **True Positive (TP)** | The alert fired and the activity was malicious | Encoded PowerShell launched by a malicious Word macro |
| **False Positive (FP)** | The alert fired but the rule matched something it shouldn't have | A rule meant for `-enc` also matches a legitimate `-encoding` switch |
| **Benign True Positive (BTP)** | The rule worked correctly, but the activity was authorized | An IT admin running a remote management script that uses `-enc` |
| **False Negative (FN)** | Malicious activity happened but **no** alert fired | An attacker used a technique none of your rules cover |

> **Note:** False positives and benign true positives are both closed as "not malicious," but they lead to different follow-up. A false positive usually means the **rule** needs fixing. A benign true positive may need an **exception** for a known, approved activity.

<hr>

## The Triage Process

Triage is the process of quickly deciding what an alert means and what to do about it. A repeatable process keeps you consistent and fast.

### 1. Understand the Alert
Read the rule name, description, and severity. What behavior is this rule trying to catch?

### 2. Validate the Evidence
Open the raw event. Does the data actually match what the rule describes? Check the process, command line, parent process, user, and host.

### 3. Add Context
Ask questions that the alert alone can't answer:

- Is this host a server, a workstation, or a domain controller?
- Is this user an admin? Do they normally do this?
- Has this alert fired on this host or user before?
- What happened on the host just before and just after?

### 4. Enrich the Indicators
Look up IPs, domains, file hashes, and URLs in threat intelligence and internal sources (see the table below).

### 5. Correlate
Search other log sources for related activity. Does the same IP appear in firewall logs? Did the same user log in somewhere unusual? Are other hosts showing the same behavior?

### 6. Decide and Document
Classify the alert (TP, FP, or BTP), escalate if needed, and write down what you checked and why you reached your conclusion.

<hr>

## Enrichment Sources

Enrichment adds context to the raw indicators in an alert.

| Source | What It Gives You | Example Use |
|---|---|---|
| **VirusTotal** | Reputation for file hashes, IPs, domains, and URLs | Is this SHA256 known malware? |
| **AbuseIPDB** | Community reports of abusive IP addresses | Has this IP been reported for brute forcing? |
| **WHOIS / Domain Age** | Who registered a domain and when | Was this domain registered two days ago? |
| **GeoIP** | Approximate location and network owner (ASN) of an IP | Is this login coming from a hosting provider overseas? |
| **Asset Inventory / CMDB** | What a host is, who owns it, and how critical it is | Is `SRV-DB-01` a production database? |
| **Identity Directory** | User role, department, group memberships, manager | Is `jsmith` in IT, or in Finance? |
| **Internal Threat Intel** | Indicators from past incidents in your environment | Have we seen this domain before? |

> **Tip:** Be careful with what you submit to public services. Uploading an internal document or a sensitive file to a public sandbox can leak data. Search by **hash** first.

<hr>

## Log Types to Recognize

Alerts point you toward logs. Knowing what each log type contains tells you where to look next.

| Log Type | Key Fields | What It Helps You Answer |
|---|---|---|
| **Windows Security Events** | Event ID, account name, logon type, source IP | Who logged in, from where, and how? (4624, 4625, 4688, 4720) |
| **Sysmon Events** | Process, command line, parent process, hashes, network connections | What ran, what launched it, and what did it connect to? (Event IDs 1, 3, 11, 22) |
| **Firewall Logs** | Source/destination IP, port, protocol, action | Was this connection allowed or blocked? |
| **DNS Logs** | Query name, response, client IP | Which host looked up a suspicious domain? |
| **Web Proxy Logs** | URL, user agent, HTTP method, status code, bytes sent/received | Which user visited this site, and was data uploaded? |
| **EDR Telemetry** | Process tree, file writes, registry changes, network events | What is the full chain of activity on the endpoint? |
| **Authentication / IdP Logs** | User, source IP, device, MFA result | Was this cloud login legitimate? |

<hr>

## Example: Triaging an Alert

**Alert:** `Suspicious Encoded PowerShell Command` (High)

| Field | Value |
|---|---|
| Host | `WS-FINANCE-07` |
| User | `CORP\jsmith` |
| Parent Process | `WINWORD.EXE` |
| Command Line | `powershell.exe -nop -w hidden -enc SQBFAFgA...` |

**Triage notes:**

1. **Understand:** The rule detects PowerShell running with an encoded command, often used to hide scripts.
2. **Validate:** The raw Sysmon Event ID 1 confirms PowerShell was launched by **Microsoft Word**, which is very unusual.
3. **Context:** `jsmith` works in Finance and is not an administrator. No similar alerts in the past 90 days.
4. **Enrich:** Decoding the Base64 shows a command that downloads a file from an external domain registered 3 days ago.
5. **Correlate:** DNS logs show `WS-FINANCE-07` resolved that domain at the same time. Email logs show `jsmith` received a `.docm` attachment minutes earlier.
6. **Decide:** **True Positive.** Escalate as a likely phishing-based malware infection and isolate the host.

<!--
<hr>

## Check Your Understanding

1. An alert fires because an approved IT script uses an encoded PowerShell command. What outcome category is this?
2. Why should you always open the raw event instead of relying on the alert summary?
3. Which log source would best show whether a workstation resolved a suspicious domain?
4. What is a false negative, and why is it dangerous?

<details>
<summary>Answers</summary>

1. A Benign True Positive. The rule worked, but the activity was authorized.
2. The alert summary only shows selected fields. The raw event may contain details, such as the parent process or full command line, that change your decision.
3. DNS logs.
4. Malicious activity that did **not** trigger an alert. It's dangerous because nobody knows to investigate it.

</details>
-->