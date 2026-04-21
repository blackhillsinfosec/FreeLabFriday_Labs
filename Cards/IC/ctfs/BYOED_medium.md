![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

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

[Back to Card's Main Page](/Cards/IC/Bring_Your_Own_Exploited_Device.md)
