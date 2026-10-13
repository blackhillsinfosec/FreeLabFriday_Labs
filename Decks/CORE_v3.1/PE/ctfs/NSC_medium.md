## Modified Service Investigation

You are a SOC analyst. An EDR alert fired on a workstation for "suspicious service modification." You pull the relevant logs and find the following sequence of events:

```
[09:42:11]  Process: powershell.exe  (parent: cmd.exe)
            Command: sc config "Spooler" binPath= "C:\Windows\Temp\spool32.exe"

[09:42:14]  Event ID 7040 - Service configuration changed
            Service Name: Spooler
            Old Binary:   C:\Windows\System32\spoolsv.exe
            New Binary:   C:\Windows\Temp\spool32.exe

[09:42:15]  Event ID 7036 - Service state changed
            Service Name: Spooler
            New State:    Running
```

You look up `spool32.exe` - it does not exist in any known software inventory and has no digital signature.
