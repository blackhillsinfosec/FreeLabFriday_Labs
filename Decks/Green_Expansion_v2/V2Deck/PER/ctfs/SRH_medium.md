![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Tracing the Execution Chain

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

---

## Question

Based on the event chain, what is the correct order of attacker operations?

---

## Flags (Choose One)

- **A)** Malware dropped -> service crashed naturally -> payload executed -> C2 connection established
- **B)** C2 connection established -> payload executed -> service failure action modified -> service crashed
- **C)** Service crashed -> payload executed -> failure action modified -> C2 connection established
- **D)** Service failure action modified -> service crashed (forced or natural) -> payload executed as SYSTEM -> C2 connection established

---

Correct Flag: **D**

---

# Finished?
[Next Question](SRH_hard.md)
[Back to Card's Main Page](../Service_Recovery_Hijacking.md)
