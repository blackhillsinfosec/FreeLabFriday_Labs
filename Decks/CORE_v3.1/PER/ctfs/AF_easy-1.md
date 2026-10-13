![image](/FilesForLabs/images/blueantisyphon.png)

## Spot the Swap

You are reviewing a Windows workstation after a suspicious USB device was found plugged into it. A junior analyst ran a quick file integrity check on the system32 folder and flagged the following:

```
[MODIFIED]  C:\Windows\System32\sethc.exe
Last modified: 2024-11-14 02:31:07
Original hash (SHA256): a1b2c3d4e5f6...
Current hash (SHA256):  9z8y7x6w5v4u...
```

The machine was left unattended in a public area for about 10 minutes before the device was discovered.