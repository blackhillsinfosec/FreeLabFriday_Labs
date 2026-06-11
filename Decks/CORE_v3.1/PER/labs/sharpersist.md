<img width="791" height="750" alt="2026-06-11_17-08" src="https://github.com/user-attachments/assets/fc9d2a60-4bda-4e08-8bb9-50381060c1f5" />![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# SharPersist

# Windows VM

## In this lab we will
- Understand what persistence means and why attackers use it
- Add a persistence entry via the Registry Run key
- Add a persistence entry via a Scheduled Task
- Add a persistence entry via the Startup folder
- Verify each entry was created


---

## What is persistence?

When an attacker gets access to a machine, they want to survive a reboot. They do this by planting a trigger - something that runs their payload automatically when the system starts or a user logs in. This is called **persistence**.

SharPersist automates several of the most common Windows persistence techniques so you can see exactly how each one works.

---

## Setup

### Disable Windows Defender (temporary, for the lab)

Open PowerShell as Administrator:

<img width="92" height="98" alt="image" src="https://github.com/user-attachments/assets/f98f2626-37d2-4227-a410-93d7685f94c9" />


```powershell
Set-MpPreference -DisableRealtimeMonitoring $true
```

---

### Download SharPersist

Open PowerShell as Administrator and create a working directory:

```powershell
mkdir SharPersist
```

```powershell
cd SharPersist
```

Download the latest release directly from GitHub:

```powershell
Invoke-WebRequest -Uri "https://github.com/mandiant/SharPersist/releases/download/v1.0.1/SharPersist.exe" -OutFile "SharPersist.exe"
```

---

### Verify it runs

```powershell
.\SharPersist.exe -h
```

You will see the help output listing all available persistence types:

<img width="678" height="851" alt="image" src="https://github.com/user-attachments/assets/73bbbe95-47a7-4b7d-8c48-84d51c590338" />


---

## Technique 1 - Registry Run Key

The `HKCU\Software\Microsoft\Windows\CurrentVersion\Run` key runs programs at user login. It is one of the most commonly abused persistence locations.

### Add a Run key entry

We will add an entry that launches `calc.exe` (Calculator) on login as a harmless demo payload:

```powershell
.\SharPersist.exe -t reg -c "C:\Windows\System32\calc.exe" -k hkcurun -v "LabPersist" -m add
```

<img width="1317" height="212" alt="image" src="https://github.com/user-attachments/assets/8c77379a-7ba0-47e6-a513-95361e22a026" />


What each flag means:
- `-t reg` -> use the Registry Run key technique
- `-c` -> the command (payload) to run
- `-k hkcurun` -> the pre-determined registry key (HKCU Run)
- `-v "LabPersist"` -> the name of the registry value to create
- `-m add` -> create the entry

### Verify the entry exists

```powershell
.\SharPersist.exe -t reg -m list -k hkcurun
```

<img width="906" height="519" alt="image" src="https://github.com/user-attachments/assets/03e0b7f5-f28a-4024-97de-2c35753483a0" />


You should see `LabPersist` in the output.

You can also confirm it directly in the registry:

```powershell
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
```

<img width="1174" height="217" alt="2026-06-11_17-06" src="https://github.com/user-attachments/assets/60477e4b-29c1-40dc-9153-1aa5a52c1400" />


You will see `LabPersist` pointing to `C:\Windows\System32\calc.exe`.

---

### What does this look like to a defender?

Open Registry Editor (`regedit`):

<img width="791" height="750" alt="2026-06-11_17-08" src="https://github.com/user-attachments/assets/5a67602e-d248-422e-bf54-200b881b155a" />

And navigate to:

```
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
```

<img width="827" height="133" alt="image" src="https://github.com/user-attachments/assets/5e5be5ca-ab18-43ca-9364-671d5feec08a" />


The `LabPersist` entry is visible here. Any EDR or SIEM monitoring registry changes would generate an alert when this entry was written. Defenders look for:
- Unknown or unusual program names in Run keys
- Entries pointing to temp folders, AppData, or unusual paths
- Entries added outside of software installation windows

---

## Technique 2 - Scheduled Task

Scheduled Tasks can run a payload at login, on a timer, or on a system event. Attackers use them because they blend in with legitimate software tasks.

### Add a scheduled task

```powershell
.\SharPersist.exe -t schtask -c "C:\Windows\System32\calc.exe" -n "LabTask" -m add -o logon
```

<img width="1379" height="195" alt="image" src="https://github.com/user-attachments/assets/43d2e299-6c53-4c36-ab84-cdcf2a9cf115" />


What each flag means:
- `-t schtask` -> use the Scheduled Task technique
- `-c` -> the command to run
- `-n "LabTask"` -> the task name
- `-m add` -> create the task
- `-o logon` -> trigger the task at user logon

### Verify the task exists ( it should be near the beggining )

```powershell
.\SharPersist.exe -t schtask -m list
```

<img width="328" height="347" alt="image" src="https://github.com/user-attachments/assets/aa360333-0b50-4e7e-b039-f9c6c5cacc84" />


You can also check with the built-in Windows tool:

```powershell
schtasks /query /tn "LabTask" /fo LIST
```

<img width="822" height="157" alt="image" src="https://github.com/user-attachments/assets/d861c124-581b-4ca3-8acb-899f35fff60a" />


You will see some of the task details

---

### What does this look like to a defender?

Open Task Scheduler (`taskschd.msc`) from the Start menu. 

<img width="790" height="750" alt="2026-06-11_17-17" src="https://github.com/user-attachments/assets/a393b652-dc58-4034-9b30-3d00211e3ba1" />


Look in the root of the Task Scheduler Library. You will see `LabTask` listed there.

<img width="967" height="226" alt="2026-06-11_17-21" src="https://github.com/user-attachments/assets/8637cf22-31ed-4551-9f71-858c13ea0480" />


Defenders look for:
- Tasks with no description or Publisher
- Tasks pointing to unusual locations (AppData, Temp, user writable paths)
- Tasks created at odd hours
- Tasks created by non-administrator accounts with SYSTEM privileges

---

## Technique 3 - Startup Folder

The Windows Startup folder contains shortcuts or executables that run when a user logs in. It is simple and requires no registry or task changes.

### Add a startup folder entry

```powershell
.\SharPersist.exe -t startupfolder -c "C:\Windows\System32\calc.exe" -f "LabStartup" -m add
```

<img width="1310" height="219" alt="Screenshot 2026-06-11 172621" src="https://github.com/user-attachments/assets/f7962684-ed30-4421-badb-f09f5bd35d2f" />


What each flag means:
- `-t startupfolder` -> use the Startup Folder technique
- `-c` -> the command to run
- `-n` -> the name of the shortcut file created in the folder
- `-m add` -> create the entry

### Verify the entry exists

```powershell
.\SharPersist.exe -t startupfolder -m list
```

<img width="1070" height="197" alt="image" src="https://github.com/user-attachments/assets/1eec66ce-cf2a-4292-8218-07dc7aa87559" />


You can also check the folder directly:

```powershell
dir "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
```

<img width="1058" height="189" alt="Screenshot 2026-06-11 172720" src="https://github.com/user-attachments/assets/6c2f2607-056a-490a-96bc-bd86ed6e8b80" />


You will see a `LabStartup.lnk` shortcut pointing to `calc.exe`.

---

### What does this look like to a defender?

Open **Run**:

<img width="799" height="747" alt="2026-06-11_17-30" src="https://github.com/user-attachments/assets/42233597-f2e0-4829-9ed4-4aadcef44a4f" />


Open the Startup folder manually by running:

```
shell:startup
```

<img width="408" height="221" alt="image" src="https://github.com/user-attachments/assets/4e5135c4-5438-485f-8e84-0dcd9f5c02bf" />

Press **Enter** or click **OK**

<img width="822" height="227" alt="image" src="https://github.com/user-attachments/assets/23701581-4f26-47ac-8b20-0a5cf03d050f" />


The `LabStartup.lnk` shortcut will be visible. Defenders check this location regularly. Any file in this folder that was not placed by a known installer is a red flag.

Autoruns by Sysinternals is the standard tool used to audit all persistence locations including the Startup folder, Run keys, and Scheduled Tasks in one view.


# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Service.md)

---

> Created by Turcu-Stiolica Alexandru
