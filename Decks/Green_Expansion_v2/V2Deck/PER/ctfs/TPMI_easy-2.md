## Suspicious Update

A company's IT team pushes a routine software update to all workstations on a Monday morning. By noon, the SOC receives alerts from multiple machines showing the same process spawning outbound connections:

```
Process: updater.exe
Parent: svchost.exe
Destination: 185.220.101.47:4444
Frequency: every 60 seconds
```

No user interaction triggered this. The update came from the vendor's official update server.
