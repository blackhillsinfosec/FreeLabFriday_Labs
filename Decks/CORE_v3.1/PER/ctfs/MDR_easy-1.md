![image](/FilesForLabs/images/blueantisyphon.png)

## Spot the Suspicious Driver

A junior analyst is reviewing the list of installed drivers on a Windows endpoint that triggered an alert. The system looks clean at first glance, but one entry stands out:

```
Driver Name:    sysmon64.sys
Display Name:   System Monitor
Start Type:     Boot
Signature:      Unsigned
Path:           C:\Windows\System32\drivers\sysmon64.sys
```

Everything else on the system is properly signed by Microsoft or known vendors.
