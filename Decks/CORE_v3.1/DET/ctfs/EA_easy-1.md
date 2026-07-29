![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Suspicious Process Hunt

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

---

## Question

Which process should immediately raise a red flag and why?

---

## Flags (Choose One)

- **A)** `explorer.exe` - it should not be running under PID 1042
- **B)** `svchost.exe` at PID 5509 - it is running from a user's AppData folder, not System32
- **C)** `chrome.exe` - browsers are not allowed to spawn child processes
- **D)** `powershell.exe` - PowerShell should never run on a workstation under any circumstances

---

Correct Flag: **B**

---

# Finished?
[Next Question](EA_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/EA/Endpoint_Analysis.md)
