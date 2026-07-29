![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Registry Persistence Hunt

You are analyzing a suspicious endpoint. A colleague exported the following registry key for you to review:

```
Key:   HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
Name:  WindowsDefenderHelper
Data:  C:\Users\Public\Downloads\helper.exe /silent /wait:login
```

The file `helper.exe` has a creation date from six days ago. It has not been executed yet according to the prefetch data. No one on the team recognizes it.

---

## Question

What is the most accurate description of what this registry entry is doing?

---

## Flags (Choose One)

- **A)** It is a standard Windows Defender component set to run at login
- **B)** It is a startup entry for a legitimate third-party security tool
- **C)** It is a persistence mechanism set to execute a suspicious binary when the user logs in
- **D)** It is a leftover entry from an uninstalled application

---

Correct Flag: **C**

---

# Finished?
[Next Question](DM_medium.md)  
[Back to Card's Main Page](../Dormant_Malware.md)
