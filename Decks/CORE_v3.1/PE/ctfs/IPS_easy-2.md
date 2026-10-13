## Spray the Lab

You are reviewing authentication logs from your SIEM after it triggered a low-priority alert. You notice the following pattern over a 20-minute window:

```
[08:12:04] FAILED  john.smith      Password: Summer2024!
[08:12:06] FAILED  jane.doe        Password: Summer2024!
[08:12:08] FAILED  helpdesk        Password: Summer2024!
[08:12:10] SUCCESS m.torres        Password: Summer2024!
[08:12:12] FAILED  svc.backup      Password: Summer2024!
```

No single account was attempted more than once.
