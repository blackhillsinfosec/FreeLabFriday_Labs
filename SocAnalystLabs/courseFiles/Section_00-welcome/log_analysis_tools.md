# Log Analysis Tools to Learn

> **Hands-On Labs:** [Hayabusa](https://freelabfridays.com/labs/introclassfiles/tools/introclass/hayabusa/) · [DeepBlueCLI](https://freelabfridays.com/labs/introclassfiles/tools/introclass/deepbluecli/deepbluecli/) · [Sysmon](https://freelabfridays.com/labs/introclassfiles/tools/introclass/sysmon/sysmon/)

<hr>

## Why Tools Matter

A single Windows host can produce tens of thousands of events per day, and a domain controller can produce millions. <br>
Scrolling through Event Viewer one event at a time doesn't scale. Log analysis tools help you:

- **Parse** raw `.evtx` files into something readable
- **Apply detection rules** to automatically flag known-bad behavior
- **Build timelines** across many logs and hosts
- **Filter and search** quickly to answer specific questions

Most analysts use a mix: built-in tools for quick checks, fast triage tools for incident response, and a SIEM for everything at scale.

<hr>

## Tool Comparison

| Tool | Type | Best For | Platform |
|---|---|---|---|
| **Event Viewer** | Built-in GUI | Quick looks at a single host | Windows |
| **PowerShell `Get-WinEvent`** | Built-in CLI | Scripted filtering and extraction | Windows |
| **Hayabusa** | Fast triage / timeline | Sigma-based detection and timelines from `.evtx` | Windows, Linux, macOS |
| **Chainsaw** | Fast triage / hunting | Sigma hunting and keyword search across `.evtx` | Windows, Linux, macOS |
| **DeepBlueCLI** | PowerShell detection script | Quick detection of common attacks | Windows |
| **EvtxECmd + Timeline Explorer** | Parser + viewer | Converting `.evtx` to CSV for deep review | Windows |
| **SIEM** (Wazuh, Elastic, Splunk) | Centralized platform | Collecting, correlating, and alerting at scale | Server-based |

<hr>

## Windows Event Viewer

The built-in starting point for every analyst.

**Open it:** `Win + R` → `eventvwr.msc`

**Useful features:**
- **Filter Current Log:** filter by Event ID, level, source, and time range
- **Custom Views:** save filters you use often (for example, "All failed logons")
- **Open Saved Log:** open an `.evtx` file collected from another machine
- **XML view:** see every field, including ones the General tab hides

**Example XPath filter** (Filter Current Log → XML tab → *Edit query manually*):
```xml
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">
      *[System[(EventID=4625)]] and
      *[EventData[Data[@Name='TargetUserName']='administrator']]
    </Select>
  </Query>
</QueryList>
```

**Limitations:** slow on large logs, one host at a time, and no detection logic.

<hr>

## PowerShell: `Get-WinEvent`

Great for quick, repeatable queries and for pulling specific fields.

```powershell
# Last 50 successful logons
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624} -MaxEvents 50

# Query a saved .evtx file
Get-WinEvent -Path .\Security.evtx -FilterXPath "*[System[EventID=4625]]"

# Process creation events containing "-enc"
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Sysmon/Operational'; Id=1} |
  Where-Object { $_.Message -match '-enc' }

# Export results to CSV
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} |
  Select-Object TimeCreated, Id, Message | Export-Csv failed_logons.csv -NoTypeInformation
```

> **Tip:** Always filter with `-FilterHashtable` or `-FilterXPath` rather than piping everything to `Where-Object`. It's dramatically faster on large logs.

<hr>

## Hayabusa

**Hayabusa** is a fast, open-source Windows event log analyzer from Yamato Security. It runs **Sigma** and Hayabusa detection rules against `.evtx` files and produces a single, sorted timeline of alerts.

**Why analysts like it:**
- Thousands of community detection rules out of the box
- Results ranked by severity (critical, high, medium, low, informational)
- Works on a single file, a folder of logs, or the live system
- Outputs CSV or JSON for review in Timeline Explorer or a SIEM

**Common commands:**
```bash
# Update detection rules
hayabusa update-rules

# Create a CSV timeline from a folder of .evtx files
hayabusa csv-timeline -d C:\Logs -o timeline.csv

# Analyze the live system's logs (run as Administrator)
hayabusa csv-timeline -l -o live_timeline.csv

# Summarize successful and failed logons
hayabusa logon-summary -d C:\Logs

# Count events by Event ID to see what a log contains
hayabusa eid-metrics -f Security.evtx
```

**Reading the output:** Start with **critical** and **high** alerts, note the timestamps and hosts, then pivot into the surrounding events to build the story.

<hr>

## Chainsaw

**Chainsaw** from WithSecure is another fast `.evtx` hunting tool. It's especially good for **keyword searching** and **Sigma-based hunting**.

```bash
# Hunt with Sigma rules
chainsaw hunt C:\Logs -s sigma/ --mapping mappings/sigma-event-logs-all.yml

# Search all logs for a keyword
chainsaw search "mimikatz" -i C:\Logs
```

<hr>

## DeepBlueCLI

**DeepBlueCLI** is a PowerShell script from SANS that checks Windows logs for common attack patterns, including password spraying, suspicious command lines, new services, and log clearing.

```powershell
# Analyze a saved Security log
.\DeepBlue.ps1 .\Security.evtx

# Analyze the live System log
.\DeepBlue.ps1 -log system
```

It's lightweight, easy to read, and a great first tool for learning what attacks look like in logs.

<hr>

## EvtxECmd + Timeline Explorer

Part of **Eric Zimmerman's tools**, a DFIR favorite.

- **EvtxECmd** parses `.evtx` files into CSV and normalizes the important fields
- **Timeline Explorer** opens large CSVs with fast filtering, grouping, and highlighting

```powershell
EvtxECmd.exe -d C:\Logs --csv C:\Output --csvf all_events.csv
```

Then open `all_events.csv` in Timeline Explorer. Hayabusa's CSV output also works well here.

<hr>

## SIEMs

In a real SOC, logs from every endpoint, server, firewall, and cloud service are forwarded into a **SIEM (Security Information and Event Management)** platform. A SIEM:

- **Centralizes** logs so you can search across the whole environment
- **Correlates** events from different sources, such as a VPN login, then a file server access, then a large upload
- **Alerts** on detection rules in near real time
- **Retains** logs even if an attacker clears them on the host

Common SIEMs you'll see: **Wazuh** (open source), **Elastic Security**, **Splunk**, and **Microsoft Sentinel**. The skills from the tools above (knowing event IDs, filtering, and building timelines) carry directly into any SIEM.

<hr>

## Choosing the Right Tool

| Situation | Reach For |
|---|---|
| "Did this one user log in last night?" | Event Viewer or `Get-WinEvent` |
| "We just collected logs from a compromised host. What happened?" | Hayabusa or Chainsaw |
| "I need to review every event in detail and sort it my way." | EvtxECmd + Timeline Explorer |
| "Quick check for obvious attacks on a box." | DeepBlueCLI |
| "Is this happening anywhere else in the environment?" | SIEM |

<hr>

## Check Your Understanding

1. Why is `-FilterHashtable` preferred over piping to `Where-Object` in PowerShell?
2. What detection rule format do Hayabusa and Chainsaw both support?
3. An attacker cleared the Security log on a host. Which tool category is most likely to still have the events?
4. Which Hayabusa command would you use to quickly see which accounts logged on successfully and unsuccessfully?

<details>
<summary>Answers</summary>

1. It filters at the event log level, so far less data is loaded. That makes it much faster.
2. Sigma.
3. A SIEM, because the logs were forwarded off the host before they were cleared.
4. `hayabusa logon-summary`.

</details>
