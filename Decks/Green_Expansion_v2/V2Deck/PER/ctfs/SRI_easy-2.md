![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Registry Artifact Hunt

During an incident investigation, you run the following command on a compromised machine:

```
reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run
```

The output comes back as:

```
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run

    SecurityHealth       REG_SZ    %SystemRoot%\system32\SecurityHealthSystray.exe
    OneDrive             REG_SZ    "C:\Program Files\OneDrive\OneDrive.exe" /background
    svcmon               REG_SZ    C:\Windows\Temp\svcmon.exe
```

You check the other two entries and they are verified as legitimate. The file `svcmon.exe` is located in `C:\Windows\Temp\`, has no digital signature, and was written to disk six hours ago - around the same time the user reported strange behavior.

---

## Question

Which entry should be flagged as suspicious and why?

---

## Flags (Choose One)

- **A)** `SecurityHealth` - because system tools should not be in the Run key
- **B)** `OneDrive` - because cloud apps should not auto-start
- **C)** `svcmon` - because it points to an unsigned executable in a temp directory
- **D)** All three entries - the entire Run key is compromised

---

Correct Flag: **C**

---

# Finished?
[Next Question](SRI_medium.md)
[Back to Card's Main Page](../Startup_Registry_Injection.md)
