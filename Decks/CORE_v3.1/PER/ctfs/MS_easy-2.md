![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Event Log Dig

You are reviewing Windows Event Logs on a machine after an alert fired. You find the following entry in the System log:

```
Event ID:    7045
Log:         System
Time:        2024-11-14 03:17:42
Message:     A new service was installed in the system.

Service Name:  svchost32
Service File:  C:\Windows\Temp\svchost32.exe
Service Type:  User Mode Service
Start Type:    Auto Start
Account:       LocalSystem
```

The machine is a standard workstation. No software was scheduled to be installed that night.

---

## Question

Which detail is the strongest indicator that this service was planted by an attacker?

---

## Flags (Choose One)

- **A)** The service was installed at 03:17 AM
- **B)** The service account is LocalSystem
- **C)** The binary lives in `C:\Windows\Temp`, not a legitimate installation directory
- **D)** The event ID is 7045

---

Correct Flag: **C**

---

# Finished?
[Next Question](MS_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Service.md)
