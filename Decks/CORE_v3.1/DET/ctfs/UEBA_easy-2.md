![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Service Account Gone Wrong

You are reviewing UEBA alerts for your organization's Active Directory environment.

A service account called **svc_backup** is flagged. Its expected behavior:

- Runs automated backup jobs **nightly between 01:00 - 03:00**
- Only accesses **\\FILESERVER01\backups**
- Never performs interactive logins

The alert shows this activity from earlier today:

```
2024-11-15 11:22:05  Account: svc_backup  Action: Interactive login - SUCCESS
2024-11-15 11:23:41  Account: svc_backup  Action: Accessed \\DC01\SYSVOL
2024-11-15 11:24:10  Account: svc_backup  Action: Ran: whoami /all
2024-11-15 11:24:55  Account: svc_backup  Action: Accessed \\HR-SERVER\employees
```

---

## Question

What does this activity most likely indicate?

---

## Flags (Choose One)

- **A)** The backup job ran early due to a scheduling error
- **B)** An attacker is using the service account to move laterally through the network
- **C)** A sysadmin is testing backup connectivity manually
- **D)** The UEBA engine is misconfigured and generating noise

---

**Correct Flag: B**

---

# Finished?
[Next Question](UEBA_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/UEBA_Analytics.md)
