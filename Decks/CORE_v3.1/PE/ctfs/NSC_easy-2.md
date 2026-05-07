![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Event Log Digging

You are reviewing the Windows System Event Log on a machine that was flagged by your SIEM. You find the following entry:

```
Log:        System
Event ID:   7045
Time:       2024-11-14 02:17:43
Message:    A new service was installed in the system.

Service Name:   NetMonSvc
Service File:   C:\Temp\netmon.exe
Service Type:   Win32OwnProcess
Start Type:     Auto Start
Account:        LocalSystem
```

The machine belongs to a standard employee with no admin responsibilities. It is 2 AM.

---

## Question

What does this event log entry most likely indicate?

---

## Flags (Choose One)

- **A)** A Windows update installed a new background monitoring service
- **B)** The IT team deployed a remote management agent after hours
- **C)** The employee manually registered a helper tool for their work
- **D)** An attacker installed a persistent service to survive reboots

---

Correct Flag: **D**

---

# Finished?
[Next Question](NSC_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PE/New_Service_Creation-Modification.md)
