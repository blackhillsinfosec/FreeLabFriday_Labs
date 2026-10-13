## Persistence Chain

You are a SOC analyst responding to an alert. An EDR product flagged suspicious process activity on a server at 03:12 AM. You pull the process tree and the relevant event logs.

**Process tree (03:11-03:14):**

```
services.exe
  └── cmd.exe (spawned by: IIS worker process w3wp.exe)
        ├── net.exe  "user backdoor_svc P@ssw0rd123! /add"
        ├── net.exe  "localgroup administrators backdoor_svc /add"
        └── reg.exe  "add HKLM\...\Winlogon /v DefaultUserName /d backdoor_svc"
```

**Windows Security Events (same timeframe):**

```
03:12:01  Event 4688 - New process: cmd.exe  (parent: w3wp.exe)
03:12:04  Event 4720 - Account created: backdoor_svc
03:12:05  Event 4732 - Account added to Administrators
03:12:09  Event 4657 - Registry value modified: Winlogon\DefaultUserName
```
