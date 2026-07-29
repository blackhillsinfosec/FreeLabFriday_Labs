![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Service Account Misuse

You are checking SIEM alerts related to a service account used by a third-party backup provider.

Logs show:

```
service_account=backup_sync
action=create_new_admin
target=it-support-user
time=02:43
```

This account normally only reads storage snapshots.

---

## Question

What should you conclude first?

---

## Flags (Choose One)

- **A)** The service account is being used outside its intended role
- **B)** The action is expected during backups
- **C)** The log entry can be safely ignored
- **D)** The account automatically rotates permissions

---

Correct Flag: **A**

---

# Finished?

[Next Question](TR_medium.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/Trusted_Relationship.md)
