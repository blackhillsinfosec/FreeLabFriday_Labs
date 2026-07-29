![image](/FilesForLabs/images/blueantisyphon.png)

# SharpUp

# Windows VM

## In this lab we will

- Create **two realistic privilege‑escalation misconfigurations**
- Run **SharpUp** to audit the system
- Save the output to a file
- Locate the misconfigurations in the SharpUp results

The goal is to understand **how SharpUp detects privilege‑escalation issues**.

---


# Create Misconfiguration 1 - Autorun entry pointing to a writable path

This misconfiguration creates a **startup program entry** in the Windows registry that points to an executable located in a directory writable by normal users.  
If the executable can be modified by non‑administrative users, it may allow **privilege escalation or persistence**.

Create a directory that normal users will be able to modify.

```powershell
cd C:\Users\Administrator\Desktop\Labs\SharpUpLab
```

```powershell
mkdir AutorunApp
```

Grant **Users** modify permissions.

```powershell
icacls .\AutorunApp\ /grant "Users:(OI)(CI)M"
```

Create a simple dummy executable file.

```powershell
Set-Content .\AutorunApp\autorunapp.exe "test"
```

Create the Autorun registry entry

Add the application to the Windows **Run** key so it executes at login.

```powershell
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" `
 /v VulnAutorunApp `
 /t REG_SZ `
 /d "C:\Users\Administrator\Desktop\Labs\SharpUpLab\AutorunApp\autorunapp.exe" `
 /f
```

Verify the entry:

```powershell
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run"
```

You should see:

<img width="1044" height="110" alt="2026-04-03_18-10" src="https://github.com/user-attachments/assets/acd745fb-c5f0-48fd-912b-0332d54862ee" />


---

# Create Misconfiguration 2 - Writable service binary

Create a test service directory.

```powershell
mkdir Service
```

Create a dummy service executable file.

```powershell
echo test > .\Service\labservice.exe
```

Grant normal users modify permissions:

```powershell
icacls .\Service\labservice.exe /grant "Users:(M)"
```

Create a Windows service pointing to this binary.

```powershell
sc.exe create SharpUpLabService binPath= "C:\Users\Administrator\Desktop\Labs\SharpUpLab\Service\labservice.exe" start= auto
```

Verify the service:

```powershell
sc.exe qc SharpUpLabService
```

Expected output:

<img width="914" height="273" alt="2026-04-03_18-15" src="https://github.com/user-attachments/assets/26bcb677-944a-4d27-bf00-46389ecd6d29" />


---

# Run SharpUp

Generate the audit and save it to a file.

```powershell
.\SharpUp.exe audit | Tee-Object -FilePath sharpup-output.txt
```

> [!NOTE]
> Wait until the end of the audit.

---

# Locate the misconfigurations

Search the output for the issues you created.

```powershell
Select-String -Path sharpup-output.txt -Pattern "VulnAutorunApp|autorunapp.exe|SharpUpLabService|labservice.exe"
```

You should find:

<img width="1100" height="201" alt="2026-04-03_18-20" src="https://github.com/user-attachments/assets/2c2d296a-f03b-44ab-b8b8-98b7a2e3ee26" />


---

# Open audit file

Now, after finishing these tasks, you can take a look at the rest of the **sharpup-output.txt** file. The audit mode was run in high integrity, so many of the findings are false-positives.

```powershell
notepad sharpup-output.txt
```

<img width="1498" height="1004" alt="2026-04-03_18-22" src="https://github.com/user-attachments/assets/b492ff80-2386-4e43-a6d3-1d4341d0c3bd" />



Anayze the list of different vulnerabilities found by **SharpUp**.
Scroll through the output and review the findings. SharpUp reports potential privilege escalation issues in several categories, including:

* Modifiable Service Binaries

* Services with Modifiable Registry Keys

* Unquoted Service Paths

* Modifiable Scheduled Tasks

* Registry Autorun Entries

* Modifiable Folders in PATH

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Local_Privilege_Escalation.md)
