## Full Internal Spray Campaign

You are a senior analyst on an incident response call. An alert fired from your deception platform — a honeypot account called `svc.legacy` (which has never been used by any real employee) just had a successful login from `10.10.5.88`.

You start digging. Here is what you piece together across three different data sources:

**SIEM - Authentication logs (past 6 hours):**
```
Multiple accounts: 1-2 failed attempts each, spread across 6 hours
Passwords tried: Summer2024!, Welcome1, Company2023!
Total accounts attempted: 312
Successful logins: svc.legacy, p.nguyen
```

**EDR - Endpoint alert on 10.10.5.88:**
```
Process: cmd.exe
Command: net use \\DC01\IPC$ /user:corp\p.nguyen <password>
Followed by: whoami /groups, net localgroup administrators
```

**Firewall - Outbound traffic from 10.10.5.88:**
```
No suspicious outbound connections detected
All traffic is internal
```
