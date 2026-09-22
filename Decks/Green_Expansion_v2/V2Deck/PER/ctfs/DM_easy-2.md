## Registry Persistence Hunt

You are analyzing a suspicious endpoint. A colleague exported the following registry key for you to review:

```
Key:   HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
Name:  WindowsDefenderHelper
Data:  C:\Users\Public\Downloads\helper.exe /silent /wait:login
```

The file `helper.exe` has a creation date from six days ago. It has not been executed yet according to the prefetch data. No one on the team recognizes it.