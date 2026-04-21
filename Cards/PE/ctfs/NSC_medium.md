![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Modified Service Investigation

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

---

## Question

The attacker chose to modify the `Spooler` service rather than create a new one. What is the most likely reason for this?

---

## Flags (Choose One)

- **A)** The Spooler service runs with higher privileges than any new service could be granted
- **B)** Creating a new service requires a reboot, while modifying an existing one takes effect immediately
- **C)** A familiar, pre-existing service name is less likely to trigger alerts than a brand new unknown one
- **D)** The attacker needed the print spooler functionality to still work during the attack

---

Correct Flag: **C**

---

# Finished?
[Next Question](NSC_hard.md)  
[Back to Card's Main Page](/Cards/PE/New_Service_Creation-Modification.md)
