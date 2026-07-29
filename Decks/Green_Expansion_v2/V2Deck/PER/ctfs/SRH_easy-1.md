![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Spot the Modified Service

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

---

## Question

What does the presence of `recovery_helper.exe` as a failure action most likely indicate?

---

## Flags (Choose One)

- **A)** A Windows Update installed a helper utility for crash recovery
- **B)** The service was configured by the OS to prevent reboot loops
- **C)** An attacker planted a malicious executable that runs when the service fails
- **D)** The file is a legitimate diagnostic tool deployed by the IT team

---

Correct Flag: **C**

---

# Finished?
[Next Question](SRH_easy-2.md)
[Back to Card's Main Page](../Service_Recovery_Hijacking.md)
