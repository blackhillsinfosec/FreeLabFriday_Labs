![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Internal Spray Campaign

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

---

## Question

Based on all three sources, what is the most accurate description of what happened and what stage the attacker is currently at?

---

## Flags (Choose One)

- **A)** The attacker successfully sprayed credentials, but the honeypot alert is a false positive — `svc.legacy` was probably a scheduled task
- **B)** The attacker completed a spray, gained two valid accounts, used `p.nguyen` to authenticate to the domain controller, and is now performing privilege enumeration — lateral movement is actively in progress
- **C)** The attacker only compromised the honeypot account and has not moved anywhere yet; the `net use` command is unrelated
- **D)** The spray was detected and blocked before any credentials were confirmed, and the EDR alert is from a previous unrelated incident

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](/Cards/PE/Internal_Password_Spray.md)
