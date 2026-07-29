![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Credential Dumping Investigation

A Wazuh alert fired on a domain controller at 02:14 AM. You pull the relevant logs and find the following sequence of events:

```
[02:13:58]  lsass.exe          started by: taskmgr.exe         (PID 7740)
[02:14:01]  procdump64.exe     started by: cmd.exe             (PID 7812)
[02:14:03]  procdump64.exe     accessed process: lsass.exe
[02:14:05]  lsass.dmp          created in: C:\Windows\Temp\
[02:14:11]  powershell.exe     started by: cmd.exe             (PID 7812)
[02:14:13]  Invoke-Mimikatz    detected in memory (fileless)
```

No interactive user session was active on the machine at that time.

---

## Question

Looking at the full sequence, what is the attacker's most likely goal after the `lsass.dmp` file is created?

---

## Flags (Choose One)

- **A)** Exfiltrate the dump file and extract plaintext credentials or hashes offline
- **B)** Use the dump file to restore lsass.exe after it crashes
- **C)** Scan the domain controller for open SMB shares
- **D)** Escalate privileges by replacing the lsass.exe binary

---

Correct Flag: **A**

---

# Finished?
[Next Question](EPA_hard.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Endpoint_Security_Protection_Analysis.md)
