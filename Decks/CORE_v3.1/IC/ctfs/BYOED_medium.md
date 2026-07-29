![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Tracking a Remote Access Trojan

A SOC analyst flags a BYOD laptop after detecting suspicious outbound traffic.

You extract the following process information:

```
Process: updater.exe
Path: C:\Users\alex\AppData\Roaming\
Parent Process: explorer.exe
Network Connections: multiple external IPs
Persistence: HKCU\Software\Microsoft\Windows\CurrentVersion\Run
```

The user says they did not install anything recently.

---

## Question

Which finding most strongly suggests this is a Remote Access Trojan (RAT)?

---

## Flags (Choose One)

- **A)** The process is running from a user AppData directory with persistence
- **B)** Explorer.exe started the process
- **C)** The laptop is a BYOD device
- **D)** The traffic uses HTTPS

---

Correct Flag: **A**

---

# Finished?

[Next Question](BYOED_hard.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/Bring_Your_Own_Exploited_Device.md)
