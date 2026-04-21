![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Login Pattern Analysis

Security monitoring shows multiple failed sign-ins across different accounts.

```
09:14  user.tina   FAILED_LOGIN   203.0.113.44
09:17  user.raj    FAILED_LOGIN   203.0.113.44
09:20  user.mike   FAILED_LOGIN   203.0.113.44
09:23  user.lina   FAILED_LOGIN   203.0.113.44
```

Each attempt happens every few minutes, and there are no lockouts triggered.

---

## Question

Why would an attacker space out authentication attempts like this?

---

## Flags (Choose One)

- **A)** To speed up brute-force attempts  
- **B)** To test MFA enrollment  
- **C)** To crash the authentication server  
- **D)** To avoid detection and account lockouts  

---

Correct Flag: **D**

---

# Finished?

[Next Question](EPS_medium.md)

[Back to Card's Main Page](/Cards/IC/External_Password_Spray.md)
