![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Process Hunt

You are analyzing a memory image from a Windows workstation flagged by the SIEM.

You run `pslist` in Volatility and get the following output (trimmed):

```
Offset     Name                PID   PPID
---------- ------------------- ----- -----
0x1a2b3c   System              4     0
0x2c3d4e   smss.exe            312   4
0x3e4f5a   csrss.exe           420   312
0x4b5c6d   winlogon.exe        488   312
0x5d6e7f   explorer.exe        1204  488
0x6e7f8a   svchost.exe         832   624
0x7f8a9b   svchost.exe         940   624
0x8a9bac   notepad.exe         2048  1204
0x9bacbd   svchost.exe         3312  1204
```

---

## Question

One of the processes above is suspicious. Which one, and why?

---

## Flags (Choose One)

- **A)** `winlogon.exe` - it should not be running after login is complete
- **B)** `notepad.exe` - text editors are always malicious
- **C)** `svchost.exe` with PID 3312 - its parent is `explorer.exe` instead of `services.exe`
- **D)** `csrss.exe` - it has too low a PID

---

Correct Flag: **C**

---

# Finished?
[Next Challenge](MA_easy-2.md)  
[Back to Card's Main Page](../Memory_Analysis.md)
