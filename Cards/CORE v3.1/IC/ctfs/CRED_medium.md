![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Automation Detection

You are analyzing authentication logs from a SaaS platform.

Observations:

```
- Login attempts come from hundreds of IP addresses
- Each IP tries only 3–4 accounts
- Attempts happen at very regular intervals
- Most failures, but a few successes
```

The security team suspects attackers are distributing traffic to avoid basic rate limits.

---

## Question

What technique are the attackers most likely using?

---

## Flags (Choose One)

- **A)** SQL injection against the login form
- **B)** Manual password guessing by a single attacker
- **C)** Distributed credential stuffing using bot infrastructure
- **D)** Insider account abuse

---

Correct Flag: **C**

---

# Finished?

[Next Question](CRED_hard.md)

[Back to Card's Main Page](/Cards/IC/Credential_Stuffing.md)
