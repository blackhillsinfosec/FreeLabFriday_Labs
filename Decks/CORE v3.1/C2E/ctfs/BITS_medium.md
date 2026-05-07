![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Reconstructing an Exfiltration Timeline

You are a defender investigating a potential data breach. The endpoint in question is a finance department laptop. You run the following command and get this output:

```cmd
bitsadmin /list /allusers /verbose
```

```
GUID        : {A3F2C1B4-...}
DisplayName : WindowsUpdateHelper
Type        : UPLOAD
State       : TRANSFERRED
Priority    : FOREGROUND
Created     : 2024-03-15 00:04:11
Modified    : 2024-03-15 00:09:55
Transfer    : 1 / 1
Files       : 1 / 1

  Source    : C:\ProgramData\audit_q1_2024.zip
  Dest      : http://update-cdn-microsoft.net/receive/audit_q1_2024.zip
  Size      : 87,341,024 bytes
```

You look up `update-cdn-microsoft.net` - it was registered 6 days ago and does not belong to Microsoft.

---

## Question

There are two red flags in this output that confirm malicious intent. Which answer correctly identifies **both**?

---

## Flags (Choose One)

- **A)** The job name is suspicious, and the file is too large for a normal transfer
- **B)** The state is TRANSFERRED, and the priority is set to FOREGROUND
- **C)** The job ran at midnight, and the file is stored in ProgramData
- **D)** The destination domain is impersonating Microsoft, and the job ran at midnight with a disguised name

---

Correct Flag: **D**

---

# Finished?
[Next Question](BITS_hard.md)  
[Back to Card's Main Page](/Cards/C2E/Backround_Intelligent_Transfer_Service_As_Exfil.md)
