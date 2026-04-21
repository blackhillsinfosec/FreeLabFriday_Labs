![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Password Reuse Discovery

You are reviewing authentication logs from a web application after users reported account lockouts.

You notice the following events:

```
10:01 - Login failed - user: alice@example.com
10:02 - Login failed - user: bob@example.com
10:02 - Login failed - user: charlie@example.com
10:03 - Login failed - user: diana@example.com
10:04 - Login successful - user: bob@example.com
```

All login attempts came from the same IP address within a few minutes.

---

## Question

What is the most likely explanation?

---

## Flags (Choose One)

- **A)** A normal user forgot their password
- **B)** Credential stuffing using leaked passwords
- **C)** A scheduled system health check
- **D)** Website maintenance caused logins to fail

---

Correct Flag: **B**

---

# Finished?

[Next Question](CRED_easy-2.md)

[Back to Card's Main Page](/Cards/IC/Credential_Stuffing.md)
