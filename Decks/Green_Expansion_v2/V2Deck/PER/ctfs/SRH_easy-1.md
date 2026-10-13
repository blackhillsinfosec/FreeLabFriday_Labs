![image](/FilesForLabs/images/blueantisyphon.png)

## Spot the Modified Service

A junior analyst is reviewing a Windows workstation after a user reported strange behavior. They pull the current recovery configuration for the Windows Update service using `sc qfailure wuauserv` and get the following output:

```
SERVICE_NAME: wuauserv
RESET_PERIOD (in seconds)    : 86400
REBOOT_MESSAGE               :
RUN_FILE                     : C:\Windows\Temp\recovery_helper.exe
FAILURE_ACTIONS              : RESTART -- Delay = 0 milliseconds
                               RUN PROCESS -- Delay = 1000 milliseconds
                               RESTART -- Delay = 0 milliseconds
```

The workstation has no known scheduled maintenance tasks. `recovery_helper.exe` is not signed and does not appear in any software inventory.
