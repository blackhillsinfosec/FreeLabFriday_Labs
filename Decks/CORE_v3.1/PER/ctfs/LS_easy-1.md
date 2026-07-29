![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Suspicious Startup Script

You are doing a routine review of a Windows workstation after a user reported their machine running slow after every login.

You find the following entry in the user's environment variables:

```
UserInitMprLogonScript = C:\Users\Public\update_helper.bat
```

You open the file and find:

```bat
@echo off
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Users\Public\beacon.ps1
```

---

## Question

What is the most likely purpose of this logon script?

---

## Flags (Choose One)

- **A)** It is a standard Windows update utility
- **B)** It maps a shared network drive for the user
- **C)** It clears temporary files to improve performance
- **D)** It silently runs a PowerShell script every time the user logs in

---

Correct Flag: **D**

---

# Finished?
[Next Question](LS_easy-2.md)  
[Back to Card's Main Page](../Logon_Scripts.md)
