![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Spray the Lab

You are reviewing authentication logs from your SIEM after it triggered a low-priority alert. You notice the following pattern over a 20-minute window:

```
[08:12:04] FAILED  john.smith      Password: Summer2024!
[08:12:06] FAILED  jane.doe        Password: Summer2024!
[08:12:08] FAILED  helpdesk        Password: Summer2024!
[08:12:10] SUCCESS m.torres        Password: Summer2024!
[08:12:12] FAILED  svc.backup      Password: Summer2024!
```

No single account was attempted more than once.

---

## Question

Why did the attacker use only one password attempt per account instead of trying many passwords on one account?

---

## Flags (Choose One)

- **A)** They did not know any other passwords to try
- **B)** They were only targeting the `m.torres` account specifically
- **C)** The domain controller was blocking all traffic except from that IP
- **D)** To avoid triggering account lockout policies while still finding weak credentials

---

Correct Flag: **D**

---

# Finished?
[Next Question](IPS_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Internal_Password_Spray.md)
