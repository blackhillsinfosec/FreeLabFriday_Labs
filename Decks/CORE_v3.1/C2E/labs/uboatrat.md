![image](/FilesForLabs/images/blueantisyphon.png)

# UBoatRAT - BITS Job Abuse and Behavioral Investigation

**Environment:** Windows 11 VM (isolated workstation) + Ubuntu VM (controlled server)

## Mission briefing

Your SOC isolated a Windows 11 workstation after an unsigned executable, `WinSvcHelper.exe`, was discovered. An analyst ran it once: no window appeared and no visible output was produced. Investigate the suspicious behavior using the Windows workstation and a controlled Ubuntu server.

**Your goal:** identify how the executable stages a misleadingly named file, configures a BITS download and completion callback, retrieves a dead-drop resolver, and sends a fixed XOR-encoded network beacon. Then propose one practical detection.

> [!IMPORTANT]
> **This is not UBoatRAT malware.** `WinSvcHelper.exe` is an educational simulator that we will use to understand how **UBoatRAT** works. It cannot execute remote commands, open a shell, steal credentials, collect or exfiltrate files, upload over HTTP, or receive C2 instructions. It sends one predetermined benign message to the Ubuntu VM.

### Architecture

The **Windows VM** is the isolated workstation under SOC investigation. The **Ubuntu VM** emulates external C2 infrastructure using controlled, harmless services. The diagram below describes the way UBoatRAT would communicate with a C2 server from an infected machine (the Windows VM, in this instance) .

<img width="1774" height="887" alt="image" src="https://github.com/user-attachments/assets/4d47a66a-e8fd-410e-8f14-a28b83ef4059" />

Ubuntu serves only `GET/HEAD /health`, `/c2/trigger.dat`, `/resolver/README.md`, plus a TCP/9001 receiver. No HTTP uploads or command responses are supported.

### Concepts to recognize

| Concept | What to look for |
|---|---|
| **BITS job** | A persistent, service-managed transfer request with a name, URLs, destination, state, and optional notification. |
| **`SetNotifyCmdLine`** | A command configured to run when BITS reports a relevant transfer notification; it is not the download itself. |
| **Masquerading** | `svchost.exe` running from `runtime\`, **not** from a normal Windows system directory. |
| **Dead-drop resolver** | `/resolver/README.md` contains `[Rudeltaktik]<BASE64_VALUE>!`; Base64 decodes to the private Ubuntu address on port `9001`. |
| **XOR beacon** | A fixed message XOR-encoded with `0x88`, sent once over TCP; XOR is encoding, not encryption. |

The job is named `UBoatLab_Persistence`. Its download is inert. In this exercise, the BITS transfer enables the callback; **BITS does not send the beacon**. The callback executable performs the resolver request and beacon connection.

**ATT&CK links:** T1197 (BITS Jobs), T1102.001 (Dead Drop Resolver), T1036 (Masquerading), and an inert download resembling T1105 (Ingress Tool Transfer). This is a behavioral mapping, not a full historical UBoatRAT emulation.



---

# Part I - Investigate the suspicious executable

## Phase 1 - Start the two VMs

### 1.1 Ubuntu: establish the controlled server

In Windows, connect to the Ubuntu VM and identify the IPv4 address : 

```bash
ip -brief -4 address show scope global
```

<img width="382" height="400" alt="image" src="https://github.com/user-attachments/assets/4c028299-7761-4b62-9255-904163c9e3b3" />
<br>
<img width="668" height="131" alt="image" src="https://github.com/user-attachments/assets/90ffbb7b-beca-47e1-8aad-ff469aaeb5db" />

**Read the output:** identify the VM's private IPv4 address (for example, an address beginning with `10.`). Do not reuse the IP printed in a screenshot: **your session IP can change**. Refer to it as `<UBUNTU_PRIVATE_IP>` below.

Start the server in the same terminal, replacing the placeholder with your actual IP:

```bash
cd ~/BnB/UBoatRAT
python3 ubuntu_c2_server.py --bind <UBUNTU_PRIVATE_IP> --advertise-ip <UBUNTU_PRIVATE_IP>
```
<img width="1169" height="359" alt="image" src="https://github.com/user-attachments/assets/cc12e121-9045-46a0-b6bc-b3963bfbd590" />

**Read the output:** check that the HTTP server listens on **8080**, the TCP beacon listener on **9001**, and the resolver decodes to `<UBUNTU_PRIVATE_IP>:9001`. Keep this server terminal open.

Open a second Ubuntu terminal if you want to inspect the listening sockets:

<img width="300" height="304" alt="image" src="https://github.com/user-attachments/assets/cc9555ec-80c6-4520-af53-af4ddcba9773" />

```bash
ss -lntp | grep -E ':(8080|9001)\b'
```

<img width="850" height="105" alt="image" src="https://github.com/user-attachments/assets/9e611c92-e9d9-433e-ae7b-abfded785ab7" />

**Read the output:** expect listeners for both ports. When this is confirmed, you can close this terminal. 

### 1.2 Windows: initialize the investigation session

Open the **Administrator Windows PowerShell** shortcut supplied on the desktop. The **classic PowerShell console is supported**; Windows Terminal is not required.

<img width="533" height="283" alt="image" src="https://github.com/user-attachments/assets/a72f555d-992c-4dc8-8345-825af43fe651" />

Run these commands **separately**, rather than pasting them as one multiline block:

```powershell
Set-Location "C:\Users\Administrator\Desktop\Labs\UBoatRAT"
```

```powershell
.\lab_start.ps1 -UbuntuIP <UBUNTU_PRIVATE_IP>
```

The setup script maps `uboat-c2.test` to Ubuntu, checks ports and HTTP endpoints, resets only lab-specific runtime/BITS state, prepares BITS Operational and process telemetry, and writes `lab_session.json`. **It does not execute the simulator.** Wait for the success message.

<img width="1223" height="640" alt="image" src="https://github.com/user-attachments/assets/0fd74fc8-a5fc-4d3e-924a-3098accdff7c" />

**Read the output:** locate the successful initialization message, the Ubuntu IP, the Wireshark display filter, and the saved Sysmon configuration path. `Failed`/`ERROR` means the session is **not** ready.

Inspect the session metadata:

```powershell
Get-Content .\lab_session.json | ConvertFrom-Json | Format-List
```

<img width="1110" height="617" alt="image" src="https://github.com/user-attachments/assets/ca38c2b9-0861-4a00-8b0d-045b2150090f" />

**Read the output:** find `UbuntuIP` and `SessionStartUtc`; these identify your server and the start of the event search window. Store them for later commands:

```powershell
$Session = Get-Content .\lab_session.json | ConvertFrom-Json
```

```powershell
$SessionStart = [datetime]$Session.SessionStartUtc
```

```powershell
$UbuntuIP = $Session.UbuntuIP
```

<img width="919" height="520" alt="image" src="https://github.com/user-attachments/assets/5ce11103-1107-4cdf-9ac8-3b51cbc07729" />

**Read the output:** assignments normally produce **no text**. Verify a variable with `$SessionStart` or `$UbuntuIP` if needed. Keep this PowerShell session open: later commands use these variables.

---

## Phase 2 - Establish the baseline and start captures

### 2.1 Investigate the file **before** execution

Execute each command:

**File metadata**

```powershell
Get-Item .\WinSvcHelper.exe | Format-List Name,Length,CreationTime,LastWriteTime
```

<img width="856" height="189" alt="image" src="https://github.com/user-attachments/assets/584e49d1-5b61-4365-8f01-779abd5236b6" />

**SHA-256**

```powershell
Get-FileHash .\WinSvcHelper.exe -Algorithm SHA256 | Format-List Algorithm,Hash
```

<img width="869" height="188" alt="image" src="https://github.com/user-attachments/assets/0b7feabe-51d1-4450-ab9f-32982f05796a" />

**Digital signature**

```powershell
Get-AuthenticodeSignature .\WinSvcHelper.exe | Format-List Status,StatusMessage
```

<img width="859" height="319" alt="image" src="https://github.com/user-attachments/assets/7a7af5a9-b05e-485c-9390-c26201913cfb" />

**Version fields**

```powershell
(Get-Item .\WinSvcHelper.exe).VersionInfo | Format-List FileVersion,ProductVersion,CompanyName,FileDescription
```

<img width="853" height="223" alt="image" src="https://github.com/user-attachments/assets/d9f16378-12ce-46c5-80d3-fa1a58bab4fb" />

**Read the output:** `Length` is the file size in bytes; `Hash` is a reproducible identifier, not proof of maliciousness; `Status` reveals whether Windows recognizes a valid signature. An unsigned executable warrants investigation but is not automatically malicious. 

### 2.2 Confirm the clean starting state

```powershell
Test-Path .\runtime
```

<img width="640" height="70" alt="image" src="https://github.com/user-attachments/assets/46d5095b-b906-4122-890d-76ecdc4cdc61" />

**Read the output:** expect `False`.

Check the specific BITS job, without touching unrelated jobs:

```powershell
Get-BitsTransfer -AllUsers | Where-Object DisplayName -EQ "UBoatLab_Persistence" | Format-List *
```

<img width="860" height="70" alt="image" src="https://github.com/user-attachments/assets/572d5206-7875-4294-8e67-c523a174b7cf" />

**There should be no output**. That means there are no "UBoatLab_Persistence" BITS jobs currently. 

For an independent queue view:

```powershell
bitsadmin /list /allusers
```

<img width="731" height="148" alt="image" src="https://github.com/user-attachments/assets/abcc4ffc-d3d8-4d06-9f20-1549685f7336" />

**Read the output:** other legitimate Windows jobs may exist. In this case however, there are none. 

### 2.3 Prepare host and network telemetry

Start **Process Monitor (Procmon)**:

```powershell
.\tools\Procmon\Procmon64.exe
```

<img width="919" height="721" alt="image" src="https://github.com/user-attachments/assets/b918dd02-b7d6-4ef1-8e3f-ff5280c497f3" />

**Read the interface:** the events table records operations with timestamp, process name, operation, path, and result. Let Procmon collect briefly, then pause with **Ctrl+E**; resume just before executing the simulator. Leave it open.

Open Wireshark and select the Windows network interface that communicates with Ubuntu:

<img width="554" height="300" alt="image" src="https://github.com/user-attachments/assets/54b5fc16-ab57-44b9-ae8e-25632afb34e9" />

<img width="749" height="580" alt="image" src="https://github.com/user-attachments/assets/14034649-7f49-4f8e-baff-fb3e36948bc0" />

Start the **capture** using Wireshark's Start control. In the **display filter** bar, enter the actual private Ubuntu IP:

```text
ip.addr == <UBUNTU_PRIVATE_IP> && (tcp.port == 8080 || tcp.port == 9001)
```

<img width="958" height="634" alt="image" src="https://github.com/user-attachments/assets/8bbb3269-78a9-4783-a550-ff95baa25a54" />

**Read the interface:** a display filter narrows visible packets.

---

## Phase 3 - Execute the simulator once

Resume Procmon with **Ctrl+E**. Check that Wireshark is still capturing and Ubuntu's server is running.

```powershell
.\WinSvcHelper.exe
```

No visible program window or console output is expected. Allow the transfer and callback time to execute; then pause Procmon and stop the Wireshark capture. **Leave Ubuntu running** for evidence inspection.

<img width="877" height="949" alt="image" src="https://github.com/user-attachments/assets/88bb1ccc-2e6c-4840-bed0-21a49e6806a5" />

**Read the screenshot:** note the execution may appear uneventful in PowerShell. Lack of console output is not evidence of failure.

Inspect generated files:

```powershell
Get-ChildItem .\runtime -Force | Format-Table Name,Length,LastWriteTime -AutoSize
```

<img width="940" height="349" alt="image" src="https://github.com/user-attachments/assets/aeb2e2b4-0ff8-45ec-93e8-2a88e5bc4150" />

**Read the output:** new files under `runtime` demonstrate staging, but do not alone prove the callback or network activity. Verify those independently in the next phases.

> [!WARNING]
> Do not rerun the simulator merely because output is silent. Inspect `runtime\execution.log`, `runtime\bitsadmin.log`, and `runtime\callback.log` first. Avoid executing `/complete` on `UBoatLab_Persistence`: we want to inspect the job as left by the simulator.

---

## Phase 4 - Reconstruct execution and file staging

### 4.1 Procmon: who launched what?

In Procmon choose **Tools → Process Tree**:

<img width="741" height="472" alt="image" src="https://github.com/user-attachments/assets/d650bb61-d05c-4c3e-b3bd-671801c5bf9b" />

<img width="1229" height="857" alt="image" src="https://github.com/user-attachments/assets/224a1e95-7609-4cc0-96f8-eb024c467253" />

**Read the tree:** look for the initial `WinSvcHelper.exe` launched by `powershell.exe`, followed by `cmd.exe` and the `bitsadmin.exe` invocations. This is the setup chain:

```text
powershell.exe → WinSvcHelper.exe → cmd.exe → bitsadmin.exe
```

<img width="1157" height="186" alt="image" src="https://github.com/user-attachments/assets/ba94605f-d934-439c-9d76-55191435166f" />

The callback is a **separate execution** of `runtime\svchost.exe --bits-callback`, triggered by BITS notifications; it need not be a direct child of the initial simulator process.

### 4.2 Procmon: narrow down events

Press **Ctrl+L** to open the filter dialog. Add **Include** rules for these process names:

```text
WinSvcHelper.exe
cmd.exe
bitsadmin.exe
svchost.exe
```

<img width="582" height="340" alt="image" src="https://github.com/user-attachments/assets/4287da15-c05d-4d09-a425-6a4a0ef4259d" />

<img width="583" height="340" alt="image" src="https://github.com/user-attachments/assets/8374898a-0766-4c6e-b60c-f0316ce9e2b8" />

<img width="585" height="342" alt="image" src="https://github.com/user-attachments/assets/a950cfde-d256-45ae-b214-abbb15274fe5" />

<img width="583" height="342" alt="image" src="https://github.com/user-attachments/assets/2cb23f7b-7324-4c12-8104-482e7eaa1903" />

### Exercise — Trace the BITS Initialization Script

Open the Process Monitor Filter dialog using **Ctrl+L**.

Keep the four existing Process Name filters and add the following three **Include** rules:

| Column | Relation | Value | Action |
|---|---|---|---|
| Operation | is | `WriteFile` | Include |
| Operation | is | `ReadFile` | Include |
| Path | contains | `\runtime\init.bat` | Include |

These filters narrow the investigation to file read/write operations involving the BITS initialization script.

Your final filter configuration should look similar to this:

<img width="629" height="458" alt="image" src="https://github.com/user-attachments/assets/0d15467d-50f5-4a82-bb11-5551051eab6f" />

Apply the filters by clicking **Apply**, then click **OK**.

### Analyze the Results

Your filtered events should resemble the following output:

<img width="925" height="728" alt="image" src="https://github.com/user-attachments/assets/2b34d0cd-42c5-4b57-a768-f551835bed79" />

**Read the output:**

Focus on the **Process Name**, **Operation**, **Path**, and **Result** columns.

**1. `WinSvcHelper.exe` — WriteFile**

The simulator writes data to `runtime\init.bat`.

The `SUCCESS` result confirms that the write operation completed successfully.

**2. `WinSvcHelper.exe` — ReadFile**

The simulator also reads the generated script.

This confirms that the executable accesses the file after writing it.

**3. `cmd.exe` — ReadFile**

The Windows command interpreter reads `runtime\init.bat`.

The repeated `ReadFile` operations show successive reads from the script, while `END OF FILE` indicates that the interpreter reached its end.

### What Have We Discovered?

We have identified a relationship between the malware and the generated BITS initialization script:

<img width="567" height="481" alt="image" src="https://github.com/user-attachments/assets/fb9c507a-b41e-4d56-877f-9af396d8a5bb" />

Procmon provides evidence of the file operations. Combined with the Process Tree and Sysmon process creation events, these findings help reconstruct how the simulator prepares and executes the BITS initialization workflow.

**Investigation question:** Why does the simulator generate a batch script instead of configuring BITS directly through its own process?

### 4.3 Confirm Process Creation in Sysmon

We have already observed the execution chain in Procmon. Now, let's verify it using **Sysmon Event ID 1**, which records process creation events, including command lines and parent processes.

First, in Powershell, define the Sysmon event log:

```powershell
$Sysmon = 'Microsoft-Windows-Sysmon/Operational'
```

Query process creation events from the current laboratory session:

```powershell
Get-WinEvent -FilterHashtable @{LogName=$Sysmon;Id=1;StartTime=$SessionStart} | Where-Object Message -Match 'WinSvcHelper|bitsadmin|\\runtime\\svchost' | Format-List TimeCreated,Message
```

**How does this command work?**

- **`Get-WinEvent`** retrieves Sysmon Event ID 1 events recorded after the laboratory session started.
- **`Where-Object`** keeps events mentioning `WinSvcHelper`, `bitsadmin`, or `runtime\svchost`.
- **`Format-List`** displays each matching event's timestamp and message.

**Read the output:** Identify the following fields:

| Field | Meaning |
|---|---|
| `Image` | Executable that was launched |
| `CommandLine` | Arguments used during execution |
| `ParentImage` | Process responsible for launching it |
| `ProcessGuid` | Unique identifier used by Sysmon to correlate process activity |

**1. Initial Execution — WinSvcHelper.exe**

The first event shows the initial execution of `WinSvcHelper.exe`.

- **TimeCreated:** When the process was launched.
- **Process Create:** Sysmon Event ID 1, indicating a new process.
- **Image:** The full path of the executable.
- **ParentImage:** `powershell.exe`, the process that launched it.

This establishes the starting point of our investigation : 

<img width="915" height="611" alt="image" src="https://github.com/user-attachments/assets/ac1563a1-f8a0-4047-8b24-007744155ccf" />

**2. BITS Callback Registration — bitsadmin.exe**

The next event shows `bitsadmin.exe` configuring a notification command for the BITS job.

- **TimeCreated:** When the command was executed.
- **Image:** `bitsadmin.exe`, the Windows utility used to manage BITS jobs.
- **CommandLine:** `/setnotifycmdline` configures `runtime\svchost.exe --bits-callback` as the notification command.
- **ParentImage:** `cmd.exe`, which launched `bitsadmin.exe`.
- **ParentCommandLine:** Shows that `cmd.exe` was executing `runtime\init.bat`.

This connects the initialization script discovered in Procmon to the BITS callback configuration.

The event confirms that the command was executed. We will verify the actual BITS job configuration in Phase 5.

<img width="1429" height="545" alt="image" src="https://github.com/user-attachments/assets/13ee256e-a469-4875-aa57-7bd8f2138dde" />

**3. BITS Callback Execution — svchost.exe**

The final event shows a new process launched by the Windows BITS service.

- **TimeCreated:** When the callback executable started.
- **Image:** `runtime\svchost.exe`, an executable located outside the legitimate Windows system directories.
- **OriginalFileName:** `WinSvcHelper.exe`, revealing the executable's original name.
- **CommandLine:** The `--bits-callback` argument identifies its callback execution mode.
- **ParentImage:** `C:\Windows\System32\svchost.exe`, a legitimate Windows service-host process.
- **ParentCommandLine:** The `-s BITS` argument identifies the service responsible for launching the callback.

Notice that the callback was launched by the BITS service, **not directly by the original `WinSvcHelper.exe` process**.

This demonstrates how BITS can be abused to execute a configured program through its notification mechanism.

<img width="1091" height="522" alt="image" src="https://github.com/user-attachments/assets/e592f0e9-0e2f-4e58-9493-a65d18781c3d" />

---

### 4.4 Inspect File Artifacts and the Generated Batch

Now that we have identified the processes, let's examine the files they created.

**Step 1 — List the generated artifacts**

```powershell
Get-ChildItem .\runtime -Force
```

This command lists the contents of the `runtime` directory, including hidden files.

**Read the output:** Look for `svchost.exe`, `init.bat`, `execution.log`, `bitsadmin.log`, `callback.log`, and other generated artifacts.

<img width="783" height="359" alt="image" src="https://github.com/user-attachments/assets/54318519-1555-4dde-9116-fa4f972e6bcb" />

The BITS download still appears as a temporary `BIT*.tmp` file, since transfer has not yet been acknowledged.

**Step 2 — Inspect the BITS initialization script**

```powershell
Get-Content .\runtime\init.bat
```

`Get-Content` displays the script without executing it.

**Read the output:** Identify these BITS commands:

| Command | Purpose |
|---|---|
| `/create /download` | Creates a BITS download job |
| `/addfile` | Specifies the download URL and destination |
| `/setnotifycmdline` | Configures the executable launched by the BITS notification |
| `/resume` | Starts or resumes the transfer |

<img width="1018" height="606" alt="image" src="https://github.com/user-attachments/assets/511429b7-6da0-4a8f-bc06-50809f617756" />

**Important:** The malware generates `init.bat`, and `cmd.exe` executes it. This explains the file operations we previously observed in Procmon.

**Step 3 — Inspect the execution logs**

The simulator generates several logs documenting different stages of its behavior.

**Initial execution and file staging:**

```powershell
Get-Content .\runtime\execution.log
```

<img width="1354" height="201" alt="image" src="https://github.com/user-attachments/assets/f614e848-777c-4223-ac48-b927e19bef73" />

- The log confirms that the simulator copied itself to runtime\svchost.exe, generated init.bat, and completed the initial BITS setup. This connects the file artifacts to the execution chain observed in Procmon and Sysmon.

**BITS configuration results:**

```powershell
Get-Content .\runtime\bitsadmin.log
```

<img width="1887" height="566" alt="image" src="https://github.com/user-attachments/assets/55a16f56-0f74-425e-b5bd-355f163c9330" />

- The output confirms that a BITS download job was created, its source and destination were configured, and runtime\svchost.exe --bits-callback was registered as the notification command before the job was resumed.


**Callback execution and network activity:**

```powershell
Get-Content .\runtime\callback.log
```

<img width="1169" height="185" alt="image" src="https://github.com/user-attachments/assets/b83bb6b2-7428-4dc6-8f6c-3be3906da3c1" />

- The log shows that the callback retrieved and decoded the resolver, identified the server on port 9001, and sent a 49-byte XOR-encoded beacon. It also reports that no command channel was opened.

**Read the output:** Compare the recorded actions with the behavior observed in Procmon and Sysmon.

Remember that these logs are generated by the simulator itself. Independent telemetry provides stronger evidence than application logs alone.

---

## Phase 5 - Understand the BITS job and callback

Inspect the live job:

```powershell
Get-BitsTransfer -AllUsers | Where-Object DisplayName -EQ 'UBoatLab_Persistence' | Format-List *
```

<img width="999" height="870" alt="image" src="https://github.com/user-attachments/assets/9403eb35-b83b-447c-bea4-5b453bd167fb" />

**Read the output:** identify the job GUID/name, type (**download**), source and destination, state, owner, and callback command. The important difference is **`TRANSFERRED` versus `/complete`**: a transferred job may still be inspectable; a successfully acknowledged/completed job leaves the active BITS queue. Leaving it uncompleted does **not** guarantee repeated execution or traffic.

Query the BITS Operational log since this session began:

```powershell
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Bits-Client/Operational'; StartTime=$SessionStart} | Sort-Object TimeCreated | Format-List TimeCreated,Id,Message
```

<img width="776" height="800" alt="image" src="https://github.com/user-attachments/assets/a55251db-cd0e-4532-b487-1272c826d714" />

Then focus on messages mentioning our job:

```powershell
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-Bits-Client/Operational'; StartTime=$SessionStart} | Where-Object Message -Match 'UBoatLab_Persistence' | Format-List TimeCreated,Id,Message
```

<img width="929" height="300" alt="image" src="https://github.com/user-attachments/assets/9a19875c-4584-4366-bff9-789367f58edb" />

The filtered events show the lifecycle of `UBoatLab_Persistence`: the job was created (Event ID 3), the transfer started (ID 59), and BITS later stopped transferring with status `0x0` (ID 60), indicating no reported error.

**Checkpoint:** which BITS evidence ties a legitimate background-transfer service to execution of the suspicious `runtime\svchost.exe`?

---

## Phase 6 - Network Evidence: BITS, Resolver, and XOR Beacon

We have reconstructed the execution chain and confirmed the BITS job activity. Now, let's use **Wireshark** to investigate what actually happened on the network.

We expect three stages: a BITS download over TCP/8080, a resolver request from the callback, and a single XOR-encoded beacon sent over TCP/9001.

Open the Wireshark capture recorded during Phase 3. **Do not execute the simulator again.**

### 6.1 Investigate the BITS HTTP Download

Earlier, `init.bat` and the BITS logs revealed that the job was configured to download `/c2/trigger.dat`.

Let's verify that this request actually appeared on the network.

Apply the following **Wireshark display filter**:

```text
http.request.uri == "/c2/trigger.dat"
```

The filter selects HTTP requests targeting this specific file, excluding unrelated traffic.

Select a matching packet and expand **Hypertext Transfer Protocol** in the packet details pane.

<img width="1408" height="907" alt="image" src="https://github.com/user-attachments/assets/5e14a996-051e-4b33-a094-1ccfb7e4fab3" />

**Examine the following fields:**

- **Source / Destination:** Which machine initiated the connection?
- **Request Method:** Was the request a `GET` or `HEAD`?
- **Request URI:** Does it match `/c2/trigger.dat`?
- **User-Agent:** What identifies the HTTP client?
- **Range:** Did the client request a specific portion of the file?

<img width="1179" height="839" alt="image" src="https://github.com/user-attachments/assets/73216af4-39d9-4a39-8e5d-b69bcf131187" />

Let's select a **GET** packet : 

<img width="1178" height="832" alt="image" src="https://github.com/user-attachments/assets/1ae6a75e-561d-4a52-8709-147a0d884ba5" />

The packet shows BITS requesting `/c2/trigger.dat` from the Ubuntu server over HTTP. The `User-Agent: Microsoft BITS/7.8` identifies the client, while `Range: bytes=0-1119` indicates that it requests a specific portion of the file rather than necessarily downloading it all at once.

Click Response in frame: 5273 in the packet details to inspect the server's response. The frame number may differ between captures.

Look for the HTTP status code, such as `200 OK` or `206 Partial Content`, depending on the request.

<img width="1181" height="842" alt="image" src="https://github.com/user-attachments/assets/ced3e041-7daf-4a89-8d66-885bd87120c0" />

The server responds with `206 Partial Content`, confirming that it accepted BITS' range request. The `Content-Range` header shows that bytes `0–1119` were returned from a 262,144-byte file.

**What have we discovered?**

Wireshark confirms that BITS requested /c2/trigger.dat and the Ubuntu server returned the requested data. This provides independent network evidence of the BITS transfer observed earlier in Windows logs.

This demonstrates how BITS can retrieve a file in smaller portions rather than transferring it all at once.

---

### 6.2 Investigate the Dead-Drop Resolver

The `callback.log` revealed that the callback requested `/resolver/README.md`.

Let's investigate this request to discover how the simulator obtained its communication endpoint.

Apply:

```text
http.request.uri == "/resolver/README.md"
```

This filter isolates requests for the resolver file, which is retrieved by the callback rather than the BITS transfer service.

<img width="1405" height="905" alt="image" src="https://github.com/user-attachments/assets/39f8983a-99fe-4de4-ae58-fc379cd05b2d" /> 

<img width="1404" height="904" alt="image" src="https://github.com/user-attachments/assets/74345e03-0b64-4ccf-9140-8786b110c352" />

Select the matching request and choose **Follow -> HTTP Stream**

**Read the HTTP stream:** Notice the callback's `User-Agent: UBoatRAT-Lab-Simulator/1.0` and examine the server response.

<img width="837" height="583" alt="image" src="https://github.com/user-attachments/assets/7edb8aeb-28a6-4b7d-90a9-63577118c9fb" />

Look for the following pattern:

```text
[Rudeltaktik]<BASE64_VALUE>!
```

It searched for the marker [Rudeltaktik], extracted the Base64 string between that marker and !, and decoded it to obtain the C2 IP address and port.

>[!TIP]
> Rudeltaktik is a German term associated with the submarine "wolfpack" tactics used during World War II, fitting the malware's U-boat theme.

Our simulator reproduces this technique using a controlled Ubuntu server instead of GitHub.

#### Exercise — Decode the Resolver

Copy **only the Base64 value** from the HTTP response, without the surrounding markers.

In Windows PowerShell, decode it using:

```powershell
[Text.Encoding]::ASCII.GetString([Convert]::FromBase64String('<BASE64_VALUE>'))
```

Replace `<BASE64_VALUE>` with the value extracted from Wireshark.

**Expected result:** An IPv4 address followed by port `9001`, matching your Ubuntu VM.

<img width="1197" height="315" alt="image" src="https://github.com/user-attachments/assets/6e6c6ac9-c2d4-4357-8f11-0391fff027d8" />

**What have we discovered?**

Instead of relying on a fixed endpoint embedded directly in the executable, the callback retrieves an encoded address from an HTTP resource.

The technique is called a **dead-drop resolver**. It can allow an attacker to change the communication destination without modifying the executable.

Remember that Base64 is encoding, **not encryption**.

---

### 6.3 Investigate the XOR-Encoded Beacon

The decoded resolver identified TCP port `9001` as the communication destination.

Let's isolate this connection and examine the data sent by the callback.

Apply:

```text
tcp.port == 9001
```

Unlike the previous filters, this one selects TCP traffic based on its port rather than an HTTP URI. The beacon does not use HTTP.

<img width="1403" height="632" alt="image" src="https://github.com/user-attachments/assets/e51848ab-9a87-4746-b8e6-c284d0b26be3" />

The capture shows Windows establishing a TCP connection to the decoded resolver endpoint on port 9001. After the three-way handshake, the client sends a single 49-byte payload (PSH, ACK), followed by connection termination.

Select a packet belonging to the connection and **Right click -> Follow -> TCP Stream**.

Change the display format to **HEX Dump**.

<img width="932" height="374" alt="image" src="https://github.com/user-attachments/assets/5fa6dc60-b7a0-43b4-8697-2c88ce5a3378" />

**Read the stream:** Focus on the data sent from **Windows to Ubuntu**.

The payload is not readable as ordinary ASCII text because the simulator applies an XOR operation to every byte. We know that the simulator uses the XOR key `0x88`. For example, the original ASCII character `4` has the hexadecimal value `0x34`:

```text
0x34 XOR 0x88 = 0xBC
```

Therefore, the plaintext prefix `488` becomes:

```text
BC B0 B0
```

Look for these bytes at the beginning of the client payload.

To recover the complete message:

1. In the **Follow TCP Stream** window, select only the **Windows → Ubuntu** direction.
2. Change the display format to **Raw**.
3. Click **Save As** and save the data as `beacon.bin` on the Windows desktop.

<img width="936" height="376" alt="image" src="https://github.com/user-attachments/assets/e88fd081-38c9-4fcd-bf93-f78914fbeb95" />

<img width="936" height="509" alt="image" src="https://github.com/user-attachments/assets/737504f6-8d8b-4cf2-828f-9cd57d2160f2" />

The saved file should contain **49 bytes**.

In PowerShell, load the captured bytes:

```powershell
$Bytes = [IO.File]::ReadAllBytes("$env:USERPROFILE\Desktop\beacon.bin")
```

Decode them using the same XOR key:

```powershell
[Text.Encoding]::ASCII.GetString([byte[]]($Bytes | ForEach-Object { $_ -bxor 0x88 }))
```

**Expected output:**

```text
488|UBOATRAT_LAB|BENIGN_BEACON|NO_COMMAND_CHANNEL
```

<!-- SCREENSHOT PLACEHOLDER:
PowerShell showing the decoded XOR beacon.
-->

**What have we discovered?**

The captured network payload contains a fixed, XOR-encoded message. Applying the same XOR key again restores the original plaintext.

XOR encoding makes the payload less immediately readable, but it does not provide meaningful cryptographic protection.

The simulator sends only this predetermined benign beacon. It does not implement remote command execution or data exfiltration.

---

### 6.4 Correlate Network Activity with Sysmon

Wireshark reveals network connections and their contents, but it does not directly identify the Windows process responsible for sending them.

We can use **Sysmon Event ID 3 (Network Connection)** to investigate this relationship.

In the same PowerShell session, run:

```powershell
Get-WinEvent -FilterHashtable @{LogName=$Sysmon;Id=3;StartTime=$SessionStart} | Where-Object Message -Match 'DestinationPort: 9001' | Format-List TimeCreated,Message
```

The command searches for recorded network connections to port `9001` since the laboratory session began.

**Read the output:**

- **Image:** Which executable initiated the connection?
- **DestinationIp:** Does it match the decoded resolver address?
- **DestinationPort:** Is the destination port `9001`?

<!-- SCREENSHOT PLACEHOLDER:
Sysmon Event ID 3 showing the callback's network connection.
-->

Compare the event with the corresponding Wireshark connection.

If no events appear, check whether network connection logging is enabled in the active Sysmon configuration. An empty result does not invalidate the network capture.

**What have we discovered?**

Wireshark provides evidence of the transmitted data, while Sysmon can associate the connection with the responsible Windows executable.

Together, these sources help connect the suspicious `runtime\svchost.exe` process to the observed beacon activity.

---

### 6.5 Verify the Server-Side Evidence

Finally, let's compare our findings with the controlled Ubuntu server.

In the Ubuntu terminal, inspect the beacon log:

```bash
cat ~/BnB/UBoatRAT/logs/beacon.log
```

<!-- SCREENSHOT PLACEHOLDER:
Ubuntu beacon.log showing the validated beacon.
-->

**Read the output:** Look for the source IP, the decoded message, and the server's validation result.

Now inspect the HTTP server log:

```bash
cat ~/BnB/UBoatRAT/logs/server.log
```

<!-- SCREENSHOT PLACEHOLDER:
Ubuntu server.log showing the BITS and resolver requests.
-->

**Read the output:** Identify the requests for `/c2/trigger.dat` and `/resolver/README.md`.

Compare their order with the BITS events and the Wireshark capture.

The server logs provide an additional perspective, but remember that they are generated by our controlled laboratory infrastructure.

### Final Investigation Checkpoint

Using the collected evidence, answer these questions:

1. Which network request was performed by BITS?
2. What information did the callback retrieve from the resolver?
3. What was the destination of the XOR-encoded beacon?
4. Which executable was responsible for the beacon connection?
5. Did the captured interaction contain any remote commands or file exfiltration?

You should now be able to explain the entire workflow, from the initial executable to the final network communication.

---

# Part II - Findings and Cleanup

## Phase 7 - Produce a Short Investigation Report

You have completed the investigation.

Summarize your findings using **observed evidence** from the tools used throughout the laboratory.

| Finding | Evidence |
|---|---|
| Initial executable | File metadata and Sysmon Event ID 1 |
| Process execution chain | Procmon Process Tree and Sysmon |
| Generated files | Procmon and `runtime` artifacts |
| BITS configuration | `init.bat` and BITS job information |
| BITS callback execution | Sysmon and BITS Operational events |
| HTTP download | Wireshark `/c2/trigger.dat` |
| Dead-drop resolver | Wireshark HTTP stream and decoded Base64 |
| XOR beacon | TCP/9001 capture and decoded payload |
| Server-side activity | Ubuntu HTTP and beacon logs |

**Conclusion:** The simulator creates a BITS download job, registers a notification callback, and launches a renamed copy of itself through the BITS service. The callback retrieves an encoded endpoint and sends a single benign XOR-encoded beacon.

The laboratory demonstrates these behaviors without implementing a real command-and-control channel, remote command execution, or data exfiltration.

### End the Session Safely

Stop the Ubuntu server using **Ctrl+C** and close the laboratory session.

The platform restores both disposable VMs to their prepared snapshots. Do not remove unrelated BITS jobs or modify system-wide security settings.

---

# Finished?

[Back to Card's Main Page](../Backround_Intelligent_Transfer_Service_As_Exfil.md)
