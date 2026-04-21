![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Suspicious Vendor Login

You are reviewing authentication logs after a partner account triggered an alert.

You find the following entries:

```
03:12  login_success  account=vendor_sync
03:13  download       file=finance_export.csv
03:14  login_success  account=vendor_sync
03:14  source_ip=185.77.21.44
03:15  disable_mfa    account=vendor_sync
```

The vendor normally connects from a fixed corporate IP range and never changes security settings.

---

## Question

What is the most likely explanation?

---

## Flags (Choose One)

- **A)** Normal scheduled vendor activity
- **B)** The account was likely compromised and abused
- **C)** A firewall update caused false logs
- **D)** A routine password reset

---

Correct Flag: **B**

---

# Finished?

[Next Question](TR_easy-2.md)

[Back to Card's Main Page](/Cards/IC/Trusted_Relationship.md)
