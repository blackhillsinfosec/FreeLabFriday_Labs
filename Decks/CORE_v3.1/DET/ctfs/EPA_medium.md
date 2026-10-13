## Credential Dumping Investigation

A Wazuh alert fired on a domain controller at 02:14 AM. You pull the relevant logs and find the following sequence of events:

```
[02:13:58]  lsass.exe          started by: taskmgr.exe         (PID 7740)
[02:14:01]  procdump64.exe     started by: cmd.exe             (PID 7812)
[02:14:03]  procdump64.exe     accessed process: lsass.exe
[02:14:05]  lsass.dmp          created in: C:\Windows\Temp\
[02:14:11]  powershell.exe     started by: cmd.exe             (PID 7812)
[02:14:13]  Invoke-Mimikatz    detected in memory (fileless)
```

No interactive user session was active on the machine at that time.
