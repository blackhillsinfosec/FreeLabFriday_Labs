![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Log the Copy

You are reviewing endpoint logs after a security review flagged an anomaly. You find the following entries on a workstation in the finance department:

```
[09:42:11] Device connected: USB Mass Storage - SanDisk Ultra 64GB
[09:42:14] File copied: C:\Finance\Q3_Report_Final.xlsx -> E:\
[09:42:15] File copied: C:\Finance\Payroll_2024.xlsx -> E:\
[09:42:17] File copied: C:\Finance\Budget_Projections.xlsx -> E:\
[09:43:02] Device disconnected: USB Mass Storage - SanDisk Ultra 64GB
```

The workstation was unattended at the time. Badge records show no authorized IT personnel entered the area.

---

## Question

What do these logs most likely indicate?

---

## Flags (Choose One)

- **A)** An automated backup job ran successfully
- **B)** A software update was being installed from external media
- **C)** Sensitive files were copied to a USB drive without authorization
- **D)** The endpoint antivirus was scanning an external device

---

Correct Flag: **C**

---

# Finished?
[Next Question](PME_medium.md)
[Back to Card's Main Page](../Physical_Medium_as_Exfil.md)
