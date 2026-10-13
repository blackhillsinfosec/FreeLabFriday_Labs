## Tracing the Execution Chain

During an incident response, you collect the following sequence of events from Windows Event Logs and Sysmon on a compromised server:

```
[Event ID 7034] - Service "Windows Management Instrumentation" terminated unexpectedly.

[Sysmon Event ID 1] - Process Created
  ParentImage:  C:\Windows\System32\services.exe
  Image:        C:\ProgramData\MSUpdate\updater32.exe
  CommandLine:  updater32.exe -s -hidden
  User:         NT AUTHORITY\SYSTEM

[Sysmon Event ID 3] - Network Connection
  Image:        C:\ProgramData\MSUpdate\updater32.exe
  DestinationIp: 185.220.101.47
  DestinationPort: 4444

[Event ID 7036] - Service "Windows Management Instrumentation" started successfully.
```

You also find the WMI service has its failure action set to run `C:\ProgramData\MSUpdate\updater32.exe`.
