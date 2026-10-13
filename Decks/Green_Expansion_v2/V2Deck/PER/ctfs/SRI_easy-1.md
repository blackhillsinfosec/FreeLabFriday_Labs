![image](/FilesForLabs/images/blueantisyphon.png)

## Suspicious Run Key

You are doing a routine check on a Windows workstation after a user reported their antivirus was disabled. You open the registry and browse to:

`HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run`

You find the following entry:

```
Name:   WindowsUpdater
Data:   C:\Users\john\AppData\Roaming\updater32.exe
```

The file `updater32.exe` is not signed, has no version info, and was created three days ago. No update software is known to be installed on this machine.
