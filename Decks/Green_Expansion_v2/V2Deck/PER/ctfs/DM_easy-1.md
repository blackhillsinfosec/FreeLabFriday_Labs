![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Suspicious Scheduled Task

You are doing a routine review of a Windows workstation that was flagged by endpoint analysis. You run the following command to list scheduled tasks:

```
schtasks /query /fo LIST /v
```

Among the results, you find this entry:

```
TaskName:      \Microsoft\Windows\UpdateCheck
Run As User:   SYSTEM
Task To Run:   C:\Users\Public\svchost32.exe
Schedule:      At system startup
Status:        Ready
Last Run Time: N/A
```

The machine has been running for three weeks. The task has never executed. The binary `svchost32.exe` is not a known Windows system file.