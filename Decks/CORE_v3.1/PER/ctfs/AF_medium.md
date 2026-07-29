![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Persistence via Sticky Keys

A workstation was flagged by your SIEM after business hours activity. You pull the event logs and find the following sequence:

```
[22:14:03]  Physical login screen active, no user session
[22:14:11]  sethc.exe triggered via keyboard shortcut
[22:14:11]  PROCESS: sethc.exe spawned cmd.exe (PID 4872)
[22:14:15]  cmd.exe executed: net user backdoor P@ssw0rd123 /add
[22:14:16]  cmd.exe executed: net localgroup administrators backdoor /add
[22:14:20]  New session opened: user "backdoor"
```

No USB devices were logged at this time. The workstation had been compromised remotely three days earlier via a phishing email.

---

## Question

There are two parts here. Answer both:

1. How did the attacker set up this access?
2. What privilege level did the `cmd.exe` process run with when it was spawned by `sethc.exe`?

---

## Flags (Choose One)

- **A)** The attacker used a script from the phishing email to replace sethc.exe remotely; cmd.exe ran as the logged-in user
- **B)** The attacker replaced sethc.exe during the earlier remote compromise; cmd.exe ran as SYSTEM
- **C)** A second attacker with physical access swapped the file; cmd.exe ran with standard user privileges
- **D)** Windows triggered sethc.exe automatically after detecting an idle session; cmd.exe ran as administrator

---

Correct Flag: **B**

---

# Finished?
[Next Question](AF_hard.md)  
[Back to Card's Main Page](../Accesibility_Features.md)
