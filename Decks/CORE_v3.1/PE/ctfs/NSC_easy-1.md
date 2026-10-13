![image](/FilesForLabs/images/blueantisyphon.png)

## Spot the Rogue Service

You are doing a routine review of services on a Windows workstation after an alert fired. You run `sc query` and get the following output (shortened):

```
SERVICE_NAME: WindowsUpdate
DISPLAY_NAME: Windows Update Helper
STATE: RUNNING
BINARY_PATH: C:\Windows\System32\svchost.exe

SERVICE_NAME: WinDefSvc
DISPLAY_NAME: Windows Defender Service
STATE: RUNNING
BINARY_PATH: C:\Windows\System32\MsMpEng.exe

SERVICE_NAME: SysHelper64
DISPLAY_NAME: System Helper
STATE: RUNNING
BINARY_PATH: C:\Users\Public\Downloads\helper64.exe
```
