![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Registry Investigation

You are given read access to the registry of a compromised machine. Navigating to:

```
HKLM\SYSTEM\CurrentControlSet\Services\Spooler\
```

You find the following under the `FailureActions` binary value (parsed for readability):

```
Action 1: Restart Service  - Delay: 60000ms
Action 2: Run Program      - Delay: 5000ms  - Command: C:\Users\Public\svc_mon.exe
Action 3: Restart Service  - Delay: 60000ms
```

You check `C:\Users\Public\` and find `svc_mon.exe` was created 3 days ago. The Print Spooler service has crashed twice in the past week according to the event logs.

---

## Question

Which detail is the strongest indicator that this configuration is malicious?

---

## Flags (Choose One)

- **A)** The service restarted twice, which is normal behavior for Spooler
- **B)** The executable lives in a user-writable public directory, not a system path
- **C)** The delay of 5000ms before running the program is too short
- **D)** The FailureActions key should only contain one action on a healthy system

---

Correct Flag: **B**

---

# Finished?
[Next Question](SRH_medium.md)
[Back to Card's Main Page](../Service_Recovery_Hijacking.md)
