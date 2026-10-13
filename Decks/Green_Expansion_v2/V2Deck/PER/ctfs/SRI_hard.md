## Layered Registry Persistence

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
