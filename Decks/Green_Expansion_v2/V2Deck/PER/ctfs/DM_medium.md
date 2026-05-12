![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - WMI Event Subscription Analysis

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

---

## Question

What will happen, and when?

---

## Flags (Choose One)

- **A)** Nothing - this is a standard WMI health monitoring subscription used by Windows internally
- **B)** `diag_runner.exe` will execute every 60 seconds as long as WMI is running
- **C)** `diag_runner.exe` will execute at 2:00 AM every Monday, triggered by the WMI time event
- **D)** The subscription will fire once when the server is next rebooted, then delete itself

---

Correct Flag: **C**

---

# Finished?
[Next Question](DM_hard.md)  
[Back to Card's Main Page](../Dormant_Malware.md)
