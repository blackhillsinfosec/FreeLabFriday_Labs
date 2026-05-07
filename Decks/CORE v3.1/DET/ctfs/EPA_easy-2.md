![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Registry Persistence

You are investigating a machine that keeps re-infecting itself after the malware file is deleted. You pull the registry hive and find the following entry:

```
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
  Name:  WindowsHelper
  Type:  REG_SZ
  Data:  C:\Users\Public\svchost32.exe
```

The legitimate `svchost.exe` lives in `C:\Windows\System32\`.

---

## Question

What technique is the attacker using here?

---

## Flags (Choose One)

- **A)** DLL hijacking via a missing library
- **B)** Privilege escalation through token impersonation
- **C)** Persistence via a registry Run key with a masquerading binary
- **D)** A scheduled task set to run at user logon

---

Correct Flag: **C**

---

# Finished?
[Next Question](EPA_medium.md)  
[Back to Card's Main Page](/Cards/DET/Endpoint_Security_Protection_Analysis.md)
