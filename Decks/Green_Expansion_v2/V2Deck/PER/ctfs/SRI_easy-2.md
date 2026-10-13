## Registry Artifact Hunt

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
