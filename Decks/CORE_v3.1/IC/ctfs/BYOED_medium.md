## Tracking a Remote Access Trojan

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
