![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Tailgate Trace

You are reviewing badge access logs after an incident. The logs show the following for a restricted door:

```
08:47:12 - Employee ID 1042 - ACCESS GRANTED
08:47:13 - Employee ID 1042 - ACCESS GRANTED
08:47:14 - [NO BADGE SCANNED] - DOOR HELD OPEN (4.2 seconds)
```

A USB keylogger was found plugged into a workstation inside that room later in the day. No other badge scans were recorded between 08:47 and 09:15.

---

## Question

What does the log entry at 08:47:14 most likely indicate?

---

## Flags (Choose One)

- **A)** A second employee badged in with the same ID
- **B)** A door malfunction triggered a false open event
- **C)** An attacker followed an employee through the door without scanning a badge
- **D)** The access control system rebooted and lost the scan record

---

Correct Flag: **C**

---

# Finished?

[Next Question](PA_medium.md)

[Back to Card's Main Page](../Physical_Access.md)
