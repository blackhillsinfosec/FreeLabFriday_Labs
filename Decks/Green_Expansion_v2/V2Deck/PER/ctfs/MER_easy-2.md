![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Forwarding Gone Wrong

You are reviewing a Microsoft 365 audit log after a finance employee reported that a vendor "never received" an invoice they sent last week.

You find this entry in the cloud event log:

```
Event: Set-InboxRule
Timestamp: 2024-10-21 11:47 PM
User: j.morris@company.com
IP Address: 194.87.12.33 (Russia)
Rule Details:
  - Condition: From contains "vendor" OR subject contains "invoice"
  - Action: Forward to external address d.shaw.fin@gmail.com
  - Then: Delete original
```

The employee's normal login location is the United Kingdom.

---

## Question

Which of the following best describes what happened here?

---

## Flags (Choose One)

- **A)** The employee set up automatic forwarding for remote work access
- **B)** The mail server detected spam and rerouted the messages
- **C)** A compromised account was used to silently redirect invoice emails to an attacker
- **D)** The IT team configured forwarding as part of a backup policy

---

Correct Flag: **C**

---

# Finished?

[Next Question](MER_medium.md)  
[Back to Card's Main Page](../Malicious_Email_Rules.md)
