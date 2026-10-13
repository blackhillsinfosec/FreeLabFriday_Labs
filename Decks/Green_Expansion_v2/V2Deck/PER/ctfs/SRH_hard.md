## Full Attack Reconstruction

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
