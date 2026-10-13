## Registry and Service Abuse

During an incident response, you image a compromised workstation and start combing through its registry. You find the following key:

```
HKLM\SYSTEM\CurrentControlSet\Services\NetDiagSvc
  ImagePath   = C:\ProgramData\netdiag\netd.exe -k netsvcs
  Start       = 2
  Type        = 16
  ObjectName  = LocalSystem
  Description = Network Diagnostics Background Service
```

You pull the binary and check it:

```
File:       netd.exe
Size:       48 KB
Signed:     No
Hash:       (no match in VirusTotal)
Created:    2024-11-21 01:44:08
Modified:   2024-11-21 01:44:08
```

You also notice the legitimate Windows service `NetDiagsSvc` (with an *s*) already exists on the same machine with a different ImagePath pointing to `%SystemRoot%\system32\netdiag.exe`.
