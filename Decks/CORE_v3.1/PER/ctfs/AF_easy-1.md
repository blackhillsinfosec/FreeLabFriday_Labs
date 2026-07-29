![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Spot the Swap

You are reviewing a Windows workstation after a suspicious USB device was found plugged into it. A junior analyst ran a quick file integrity check on the system32 folder and flagged the following:

```
[MODIFIED]  C:\Windows\System32\sethc.exe
Last modified: 2024-11-14 02:31:07
Original hash (SHA256): a1b2c3d4e5f6...
Current hash (SHA256):  9z8y7x6w5v4u...
```

The machine was left unattended in a public area for about 10 minutes before the device was discovered.

---

## Question

What most likely happened to `sethc.exe`, and what would the attacker gain from it?

---

## Flags (Choose One)

- **A)** Windows automatically updated the file during a patch cycle
- **B)** The attacker replaced Sticky Keys with a backdoor to get a shell from the login screen
- **C)** A user accidentally corrupted the file by running a disk cleanup
- **D)** An antivirus quarantined the file and replaced it with a placeholder

---

Correct Flag: **B**

---

# Finished?
[Next Question](AF_easy-2.md)  
[Back to Card's Main Page](../Accesibility_Features.md)
