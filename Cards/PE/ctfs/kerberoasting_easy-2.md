![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# Easy CTF 2 – Ticket Extraction

You are monitoring activity from a compromised domain user account

Shortly after login, the following event appears in the logs:

```
Event ID: 4769
Service Name: MSSQLSvc/db01.lab.local
Ticket Encryption Type: RC4-HMAC
```

This event happens multiple times in a short period

---

## Question

What is most likely happening?

---

## Flags (Choose One)

- **A)** Normal database usage by an application
- **B)** A password spray attack
- **C)** Kerberos service tickets are being requested for Kerberoasting
- **D)** A domain controller replication issue

---

Correct Flag: **C**

---

# Finished?

[Next Question](kerberoasting_medium.md)

[Back to Card's Main Page](/Cards/IC/Kerberoasting.md)
