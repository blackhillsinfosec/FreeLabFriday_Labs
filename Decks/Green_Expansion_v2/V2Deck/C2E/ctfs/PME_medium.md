![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - The Insider

An employee at a healthcare company has been giving notice of resignation. On his last week, the DLP system flags an unusual spike in local file access on his workstation. You pull the endpoint logs:

```
[14:03:55] Device connected: USB Mass Storage - Kingston DataTraveler 128GB
[14:04:01] File accessed: C:\PatientRecords\2024\records_export.zip (2.3 GB)
[14:04:48] File copied: C:\PatientRecords\2024\records_export.zip -> F:\
[14:05:10] File accessed: C:\Internal\HR\salaries_all_staff.xlsx
[14:05:12] File copied: C:\Internal\HR\salaries_all_staff.xlsx -> F:\
[14:06:30] Device disconnected: USB Mass Storage - Kingston DataTraveler 128GB
```

The employee's role gives him read access to patient records for legitimate work, but policy prohibits copying them to external media. No alerts fired at the time because USB devices are not blocked on this workstation profile.

---

## Question

Which control failure is the PRIMARY reason this exfiltration went unblocked?

---

## Flags (Choose One)

- **A)** The firewall did not inspect outbound HTTPS traffic
- **B)** The SIEM did not have enough log storage
- **C)** USB mass storage devices were not blocked or restricted on the endpoint policy
- **D)** The DLP system was not configured to scan zip files

---

Correct Flag: **C**

---

# Finished?
[Next Question](PME_hard.md)
[Back to Card's Main Page](../Physical_Medium_as_Exfil.md)
