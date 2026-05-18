![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Suspicious Run Key

You are doing a routine check on a Windows workstation after a user reported their antivirus was disabled. You open the registry and browse to:

`HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run`

You find the following entry:

```
Name:   WindowsUpdater
Data:   C:\Users\john\AppData\Roaming\updater32.exe
```

The file `updater32.exe` is not signed, has no version info, and was created three days ago. No update software is known to be installed on this machine.

---

## Question

What does this registry entry most likely indicate?

---

## Flags (Choose One)

- **A)** A malware persistence mechanism set up by an attacker
- **B)** A scheduled task that was incorrectly written to the registry
- **C)** A legitimate Windows update agent configured by IT
- **D)** A browser extension that added itself to startup

---

Correct Flag: **A**

---

# Finished?
[Next Question](SRI_easy-2.md)
[Back to Card's Main Page](../Startup_Registry_Injection.md)
