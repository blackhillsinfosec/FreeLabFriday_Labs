## WMI Event Subscription Analysis

During a threat hunt, you query WMI event subscriptions on a server using PowerShell:

```powershell
Get-WMIObject -Namespace root\subscription -Class __EventFilter | Select-Object Name, Query
```

You get back the following:

```
Name  : SystemHealthMonitor
Query : SELECT * FROM __InstanceModificationEvent WITHIN 60
        WHERE TargetInstance ISA 'Win32_LocalTime'
        AND TargetInstance.Hour = 2
        AND TargetInstance.Minute = 0
        AND TargetInstance.DayOfWeek = 1
```

You also find a linked `__CommandLineEventConsumer` pointing to:

```
C:\Windows\Temp\diag_runner.exe
```

The file exists on disk but has not been executed yet. The subscription has been in place for 11 days.