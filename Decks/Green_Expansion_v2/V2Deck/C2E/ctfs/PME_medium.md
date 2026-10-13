## The Insider

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
