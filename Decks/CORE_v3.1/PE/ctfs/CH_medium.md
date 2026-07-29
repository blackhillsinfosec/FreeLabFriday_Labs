![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Memory Dump Analysis

Your SIEM triggers an alert on a workstation in the accounting department. The alert reads:

```
[HIGH] Process lsass.exe accessed by non-system process
Source Process: svchost_helper.exe (PID 4872)
User Context: ACCOUNTING\jdoe
Time: 02:14 AM
```

You pull the process list from that machine around the same time:

```
PID   Name                  Parent        User
----  --------------------  ------------  ----------------
4872  svchost_helper.exe    explorer.exe  ACCOUNTING\jdoe
4901  cmd.exe               4872          ACCOUNTING\jdoe
4934  net.exe               4901          ACCOUNTING\jdoe
```

You also notice `net.exe` was used to run:

```
net user administrator /domain
```

---

## Question

What is most likely happening on this machine?

---

## Flags (Choose One)

- **A)** A Windows update is running scheduled maintenance tasks in the background
- **B)** The user `jdoe` is performing legitimate IT administration from their workstation
- **C)** A vulnerability scanner is enumerating domain users as part of a scheduled audit
- **D)** Malware is dumping credentials from memory and enumerating domain accounts

---

Correct Flag: **D**

---

# Finished?
[Next Question](CH_hard.md)  
[Back to Card's Main Page](../Credential_Harvesting.md)
