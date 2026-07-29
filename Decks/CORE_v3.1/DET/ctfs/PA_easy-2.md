![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Stale Credentials

You are running an AD audit and export a list of all enabled user accounts. Among the results:

```
User: svc_backup
Type: Service Account
Status: Enabled
Last logon: Never
Created: 2019-03-14
Member of: Backup Operators, Domain Users
Password expires: Never
```

---

## Question

Why is this account a security risk even though it has never been used?

---

## Flags (Choose One)

- **A)** Service accounts should never be in the Domain Users group
- **B)** The account is enabled, has privileged group membership, a non-expiring password, and no logon history - making it an unmonitored attack target
- **C)** The account was created too long ago and should be recreated
- **D)** Backup Operators is not a valid built-in group in Active Directory

---

Correct Flag: **B**

---

# Finished?
[Next Question](PA_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Permissions_Audit.md)
