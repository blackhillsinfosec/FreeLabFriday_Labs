![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Layered Registry Persistence

You are investigating a heavily compromised endpoint. The attacker used a layered persistence strategy - two registry mechanisms working together so that removing one does not break the chain.

You pull the following data during your investigation:

**Entry 1 - found under the standard Run key:**

```
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run

    WinLogHelper    REG_SZ    C:\Windows\System32\wscript.exe C:\ProgramData\init.vbs
```

**Entry 2 - found under the Winlogon key:**

```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon

    Userinit    REG_SZ    C:\Windows\system32\userinit.exe, C:\ProgramData\loader.exe,
```

You analyze both files:

- `init.vbs` - a VBScript that checks if `loader.exe` is running. If not, it launches it.
- `loader.exe` - the actual payload. It connects to a remote C2 server and downloads updated instructions.

The Winlogon `Userinit` key is supposed to contain only `userinit.exe`. The attacker appended `, C:\ProgramData\loader.exe,` to the end of the value - Windows reads the whole string and executes everything listed.

---

## Question

An analyst removes `init.vbs` and deletes the Run key entry. The machine reboots. What happens?

---

## Flags (Choose One)

- **A)** The malware is fully removed - both persistence mechanisms are now gone
- **B)** `loader.exe` still runs on login because the Winlogon Userinit entry was not touched
- **C)** Windows detects the tampered Userinit value and rolls it back automatically
- **D)** The C2 server loses contact and the malware deactivates on its own

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](../Startup_Registry_Injection.md)
