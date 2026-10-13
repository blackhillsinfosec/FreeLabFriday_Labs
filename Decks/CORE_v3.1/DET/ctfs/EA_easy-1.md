![image](/FilesForLabs/images/blueantisyphon.png)

## Suspicious Process Hunt

You are investigating a Windows workstation after a user reported their machine was acting slow. You pull the running process list using osquery and find the following output:

```
PID   | Name              | Path                                      | Parent
------|-------------------|-------------------------------------------|-------
1042  | explorer.exe      | C:\Windows\explorer.exe                   | 812
3381  | chrome.exe        | C:\Program Files\Google\Chrome\chrome.exe | 1042
4712  | svchost.exe       | C:\Windows\System32\svchost.exe           | 812
5509  | svchost.exe       | C:\Users\jsmith\AppData\Roaming\svchost.exe | 5201
5201  | powershell.exe    | C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe | 3381
```
