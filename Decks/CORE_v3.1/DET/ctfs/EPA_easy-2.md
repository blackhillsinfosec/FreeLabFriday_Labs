## Registry Persistence

You are investigating a machine that keeps re-infecting itself after the malware file is deleted. You pull the registry hive and find the following entry:

```
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
  Name:  WindowsHelper
  Type:  REG_SZ
  Data:  C:\Users\Public\svchost32.exe
```

The legitimate `svchost.exe` lives in `C:\Windows\System32\`.
