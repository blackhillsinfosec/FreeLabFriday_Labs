![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF – Domain Escalation Path

You successfully cracked a service account password:

```
Account: sqlservice
Password: Winter2021!
```

Further investigation shows:

- The account is local admin on `DB01`
- `DB01` hosts a service running as SYSTEM
- Domain admins regularly log into `DB01`

---

## Question

What is the most realistic next step for an attacker?

---

## Flags (Choose One)

- **A)** Reset all domain user passwords
- **B)** Dump credentials from DB01 to capture a domain admin
- **C)** Disable Kerberos authentication
- **D)** Exfiltrate database backups only

---

Correct Flag: **B**

---

# Finished?

[Back to Card's Main Page](/Cards/IC/Kerberoasting.md)
