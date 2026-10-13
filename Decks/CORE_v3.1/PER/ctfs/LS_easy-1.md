![image](/FilesForLabs/images/blueantisyphon.png)

## Suspicious Startup Script

You are doing a routine review of a Windows workstation after a user reported their machine running slow after every login.

You find the following entry in the user's environment variables:

```
UserInitMprLogonScript = C:\Users\Public\update_helper.bat
```

You open the file and find:

```bat
@echo off
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Users\Public\beacon.ps1
```
