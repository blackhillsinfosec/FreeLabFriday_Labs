![image](/FilesForLabs/images/blueantisyphon.png)

## Suspicious Process Hunt

You are reviewing endpoint telemetry from a Windows workstation after a user reported their machine was "acting slow."

You find the following process tree in your EDR console:

```
winword.exe (PID 3120)
  └─ powershell.exe (PID 4488)
       └─ cmd.exe (PID 5012)
            └─ net.exe (PID 5200)
```

The PowerShell process was launched with the following command:

```
powershell.exe -nop -w hidden -enc JABjAGwAaQBlAG4AdA...
```
