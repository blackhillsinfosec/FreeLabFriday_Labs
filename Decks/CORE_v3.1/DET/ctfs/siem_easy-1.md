![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 – Suspicious Login Pattern

You are reviewing authentication logs inside a SIEM dashboard after an alert about unusual logins.

You notice the following events:

```
08:12:03  user: admin   status: failed   source_ip: 185.22.11.34
08:12:05  user: admin   status: failed   source_ip: 185.22.11.34
08:12:07  user: admin   status: failed   source_ip: 185.22.11.34
08:12:09  user: admin   status: success  source_ip: 185.22.11.34
```

A few minutes later, a new admin account appears.

---

## Question

What is the most likely explanation?

---

## Flags (Choose One)

- **A)** Normal user forgot their password
- **B)** Brute-force login followed by account creation
- **C)** SIEM parsing error created duplicate logs
- **D)** Scheduled maintenance task

---

Correct Flag: **B**

---

# Finished?

[Next Question](siem_easy-2.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Security_Informations_And_Event_Management_Log_Analysis.md)
