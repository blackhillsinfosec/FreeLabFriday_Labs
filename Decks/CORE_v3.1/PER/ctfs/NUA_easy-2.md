![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Log Hunt

You are reviewing Windows Security event logs on a domain controller. The logs were pulled after a threat hunter flagged unusual activity overnight.

You find the following log entry:

```
Event ID: 4720
Time:      2024-11-14 02:47:33
Message:   A user account was created.

  Subject:
    Account Name:   SYSTEM
    Account Domain: WORKSTATION-11

  New Account:
    Account Name:   net_svc_mgr
    Account Domain: WORKSTATION-11
```

You also notice that five minutes later, Event ID **4732** fires - the new account was added to the **Administrators** group.

---

## Question

What should you conclude from these two log events?

---

## Flags (Choose One)

- **A)** A scheduled task created a temporary service account as expected
- **B)** An IT technician provisioned a new account during emergency maintenance
- **C)** An attacker created a backdoor admin account using SYSTEM-level access
- **D)** The domain controller automatically generated a recovery account

---

Correct Flag: **C**

---

# Finished?

[Next Question](NUA_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/New_User_Added.md)
