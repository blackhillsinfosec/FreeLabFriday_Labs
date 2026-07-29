![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Log Triage

Your company's SIEM just fired an alert at 2:14 AM. You pull up the logs and see the following activity on a domain controller:

```
2:11 AM – Failed login attempt: admin@corp.local (source: 192.168.4.77)
2:11 AM – Failed login attempt: admin@corp.local (source: 192.168.4.77)
2:11 AM – Failed login attempt: admin@corp.local (source: 192.168.4.77)
2:12 AM – Failed login attempt: admin@corp.local (source: 192.168.4.77)
2:13 AM – Successful login: admin@corp.local (source: 192.168.4.77)
2:14 AM – New local admin account created: svc_backup2
```

---

## Question

Based on these logs alone, what is the **first action** you should take according to an Incident Response Plan?

---

## Flags (Choose One)

- **A)** Reboot the domain controller to kick out the attacker
- **B)** Wait for more evidence before doing anything
- **C)** Disable the compromised account and isolate the affected system
- **D)** Delete the newly created account and close the ticket

---

Correct Flag: **C**

---

# Finished?
[Next Question](CM_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Crisis_Management.md)
