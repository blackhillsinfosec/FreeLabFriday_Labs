![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Spot the Rogue Service

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

---

## Question

Which service should be investigated immediately, and why?

---

## Flags (Choose One)

- **A)** `WindowsUpdate` - because it uses `svchost.exe`, which is often abused
- **B)** `SysHelper64` - because its binary lives in a user-writable public directory
- **C)** `WinDefSvc` - because Defender should not be running as a named service
- **D)** All three - legitimate services never run from `System32`

---

Correct Flag: **B**

---

# Finished?
[Next Question](NSC_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PE/New_Service_Creation-Modification.md)
