![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Full Attack Reconstruction

You are the lead responder on a compromised domain-joined workstation. You have collected the following evidence:

**Excerpt from PowerShell Script Block Logging (Event ID 4104):**
```powershell
$svc = "EventLog"
sc.exe failure $svc reset= 86400 actions= run/5000 command= "C:\Windows\Tasks\evtlog_helper.exe"
```

**Sysmon Event ID 1 - Process Created (T+12 hours later):**
```
ParentImage:  C:\Windows\System32\services.exe
Image:        C:\Windows\Tasks\evtlog_helper.exe
IntegrityLevel: System
User:         NT AUTHORITY\SYSTEM
CommandLine:  evtlog_helper.exe --dump-creds
```

**File metadata for `evtlog_helper.exe`:**
```
Created:   2024-11-03 02:14:07 UTC
Modified:  2024-11-03 02:14:07 UTC
Signed:    No
Hash (SHA256): a3f1c8e2...
```

**Security Event Log:**
```
[Event ID 1102] - The audit log was cleared.
  Subject: DOMAIN\svc_backup
```

**No Event ID 7034 (service crash) is present in the System log.**

---

## Question

The absence of Event ID 7034 combined with the rest of the evidence points to which conclusion?

---

## Flags (Choose One)

- **A)** The attack failed because the service never crashed and the payload never ran
- **B)** The attacker manually triggered the failure action using sc.exe control without crashing the service, and then cleared logs to hide the crash record
- **C)** The Event Log service was deliberately stopped by the attacker to force a crash and trigger the payload, and 7034 was cleared along with the rest of the audit log
- **D)** The payload ran under a scheduled task, not via the service recovery mechanism, making this a different technique entirely

---

Correct Flag: **C**

---

# Finished?
[Back to Card's Main Page](../Service_Recovery_Hijacking.md)
