# Sysmon Logs

> **Hands-On Lab:** Put this into practice with the [Sysmon Lab](https://freelabfridays.com/labs/introclassfiles/tools/introclass/sysmon/sysmon/) and the [Hayabusa Lab](https://freelabfridays.com/labs/introclassfiles/tools/introclass/hayabusa/).

<hr>

## What is Sysmon?

**Sysmon (System Monitor)** is a free tool from Microsoft's Sysinternals suite. It runs as a Windows service and driver, and writes detailed activity to the Windows Event Log, far beyond what the built-in Security log captures.

Standard Windows logging can tell you that a process started.<br>
Sysmon tells you:

- The **full command line** and the **parent process** that launched it
- The **file hashes** of the executable
- Which **network connections** the process made
- Which **files** and **registry keys** it created or changed
- Which **other processes** it touched, such as a tool reading LSASS memory to dump credentials

That level of detail is why Sysmon is a staple of threat hunting, detection engineering, and DFIR.

<hr>

## Where to Find Sysmon Logs

Sysmon events are written to their own channel:

```
Applications and Services Logs > Microsoft > Windows > Sysmon > Operational
```

Or, from PowerShell:

```powershell
Get-WinEvent -LogName 'Microsoft-Windows-Sysmon/Operational' -MaxEvents 20
```

The raw file is located at:

```
C:\Windows\System32\winevt\Logs\Microsoft-Windows-Sysmon%4Operational.evtx
```

<hr>

## Installing and Configuring Sysmon

Sysmon is driven by an XML **configuration file** that decides what gets logged and what gets filtered out. Without a good config, Sysmon is either too noisy or too quiet.

```powershell
# Install with a config file
sysmon64.exe -accepteula -i sysmonconfig.xml

# Update the config on a running install
sysmon64.exe -c sysmonconfig.xml

# Check the current config
sysmon64.exe -c
```

Two widely used community configs:

| Config | Best For |
|---|---|
| **SwiftOnSecurity sysmon-config** | A well-commented, balanced starting point |
| **Olaf Hartong sysmon-modular** | A modular config mapped to MITRE ATT&CK techniques |

> **Tip:** Event ID **16** fires when the Sysmon config changes. An attacker changing the config to blind your logging is something you want to know about.

<hr>

## Sysmon Event IDs

| Event ID | Event | What It's Good For |
|---|---|---|
| **1** | Process creation | Command lines, parent/child relationships, hashes |
| **2** | File creation time changed | Timestomping (attackers faking file dates) |
| **3** | Network connection | Which process talked to which IP and port |
| **4** | Sysmon service state changed | Sysmon stopped or started |
| **5** | Process terminated | Process lifetime |
| **6** | Driver loaded | Malicious or vulnerable drivers |
| **7** | Image (DLL) loaded | DLL side-loading and injection |
| **8** | CreateRemoteThread | Process injection |
| **9** | RawAccessRead | Direct disk reads (for example, copying a locked NTDS.dit) |
| **10** | Process access | One process opening another, such as credential dumping from LSASS |
| **11** | File created | Dropped payloads, scripts, and tools |
| **12 / 13 / 14** | Registry object created or deleted / value set / renamed | Persistence through Run keys, services, and more |
| **15** | File stream created | Alternate Data Streams, Mark-of-the-Web |
| **16** | Sysmon config changed | Logging tampering |
| **17 / 18** | Named pipe created / connected | C2 frameworks such as Cobalt Strike use named pipes |
| **19 / 20 / 21** | WMI filter / consumer / binding | WMI event subscription persistence |
| **22** | DNS query | Which process looked up which domain |
| **23** | File delete (archived) | Captures a copy of deleted files |
| **24** | Clipboard change | Clipboard capture (when enabled) |
| **25** | Process tampering | Process hollowing and herpaderping |
| **26** | File delete detected | Logs deletions without archiving |
| **27 / 28** | File block executable / file block shredding | Sysmon blocking actions (when configured) |
| **29** | File executable detected | A new executable written to disk |

<hr>

## Reading a Sysmon Event ID 1

Event ID 1 is the workhorse of Sysmon. Here are the fields that matter most:

| Field | Why It Matters |
|---|---|
| **Image** | Full path of the executable that ran |
| **CommandLine** | Exactly what was run, including arguments |
| **ParentImage / ParentCommandLine** | What launched it, which is often the key to spotting malicious activity |
| **User** | The account it ran as |
| **IntegrityLevel** | Low, Medium, High, or System (High/System means elevated) |
| **Hashes** | MD5, SHA256, and IMPHASH for threat-intel lookups |
| **OriginalFileName** | The name compiled into the binary, which catches renamed tools |
| **ProcessGuid** | A unique ID used to link this process to its network, file, and registry events |

Example of a suspicious event:

```
Image:             C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
CommandLine:       powershell.exe -nop -w hidden -enc SQBFAFgAIAAoAE4AZQB3AC0ATwBi...
ParentImage:       C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE
User:              CORP\jsmith
IntegrityLevel:    Medium
```

**Why this is bad:** Microsoft Word should almost never launch PowerShell. Add a hidden window (`-w hidden`) and a Base64-encoded command (`-enc`), and this is a classic malicious macro pattern.

<hr>

## Hunting with Sysmon: Common Patterns

### Suspicious Parent/Child Relationships (Event ID 1)
| Parent | Child | Possible Activity |
|---|---|---|
| `winword.exe`, `excel.exe`, `outlook.exe` | `powershell.exe`, `cmd.exe`, `wscript.exe` | Malicious macro or attachment |
| `w3wp.exe` (IIS) | `cmd.exe`, `powershell.exe` | Web shell |
| `services.exe` | Random executable in a temp folder | Malicious service |
| `wmiprvse.exe` | `powershell.exe` | Remote execution through WMI |

### Credential Dumping (Event ID 10)
Look for processes opening **`lsass.exe`** where the source process is unusual:

```
TargetImage:    C:\Windows\System32\lsass.exe
SourceImage:    C:\Users\Public\procdump64.exe
GrantedAccess:  0x1FFFFF
```

Access masks such as `0x1010`, `0x1410`, and `0x1FFFFF` against LSASS from anything that isn't a known security product deserve a close look.

### Living off the Land (Event ID 1 + Event ID 3)
Built-in Windows binaries (LOLBins) making network connections:
- `rundll32.exe`, `regsvr32.exe`, `mshta.exe`, or `certutil.exe` connecting to the internet
- `certutil.exe -urlcache -split -f http://...` downloading a file

### Persistence (Event IDs 12, 13, 19–21)
Registry values set under:
```
HKCU\Software\Microsoft\Windows\CurrentVersion\Run
HKLM\Software\Microsoft\Windows\CurrentVersion\Run
HKLM\System\CurrentControlSet\Services
```

### Command and Control (Event IDs 3, 17/18, 22)
- Repeated connections to the same external IP at regular intervals (beaconing)
- DNS queries to newly registered or random-looking domains
- Unusual named pipes created by non-system processes

<hr>

## Pivoting with ProcessGuid

Every Sysmon event tied to a process includes a **ProcessGuid**. Use it to follow one process across event types:

```
Event 1  (ProcessGuid {A1B2...}) → powershell.exe launched by WINWORD.EXE
Event 22 (ProcessGuid {A1B2...}) → DNS query for evil-updates[.]com
Event 3  (ProcessGuid {A1B2...}) → Connection to 203.0.113.50:443
Event 11 (ProcessGuid {A1B2...}) → Created C:\Users\jsmith\AppData\Roaming\update.exe
Event 13 (ProcessGuid {A1B2...}) → Set HKCU\...\Run\Updater = update.exe
```

In five events you have the full story: **initial access → C2 → payload drop → persistence**.

```powershell
# Pull all Sysmon events for a specific ProcessGuid
Get-WinEvent -LogName 'Microsoft-Windows-Sysmon/Operational' |
  Where-Object { $_.Message -match '{A1B2C3D4-0000-0000-0000-000000000000}' }
```

<hr>

## Check Your Understanding

1. Which Sysmon Event ID would show `procdump.exe` reading the memory of `lsass.exe`?
2. An attacker renames `mimikatz.exe` to `notepad.exe`. Which Event ID 1 field could still reveal the original name?
3. What field lets you link a process creation event to the network connections that process made?
4. Why is `excel.exe` spawning `cmd.exe` suspicious?

<details>
<summary>Answers</summary>

1. Event ID 10 (Process Access).
2. `OriginalFileName` (and the file hashes).
3. `ProcessGuid`.
4. Office applications rarely need to launch a command shell. This is a common sign of a malicious macro or exploit.

</details>
