![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Registry and Service Abuse

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

---

## Question

Based on all the evidence, what is the most accurate conclusion?

---

## Flags (Choose One)

- **A)** This is a duplicate entry caused by a Windows update conflict
- **B)** The attacker created a look-alike service with a slightly different name to blend in with a real one, using an unsigned binary dropped in ProgramData
- **C)** The service is unsigned but likely harmless since it has no VirusTotal hits
- **D)** The registry key is corrupted and should be repaired using `sfc /scannow`

---

Correct Flag: **B**

---

# Finished?
[Next Question](MS_hard.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Service.md)
