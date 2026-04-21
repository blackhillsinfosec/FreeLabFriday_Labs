![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF – Full Server Compromise

During an investigation, you are given these facts:

- The web server was vulnerable to **SQL injection**
- The attacker dumped the **users table**
- One of the **passwords** cracked was reused for **SSH**
- **SSH access** was gained as a normal **user**
- **Privilege escalation** was later detected via a **kernel exploit**

---

## Question

Which **attack chain** best describes what happened?

---

## Flags (Choose One)

- **A)** XSS -> CSRF -> RCE -> Root
- **B)** Brute Force -> DDoS -> Defacement
- **C)** Phishing -> Malware -> Lateral Movement
- **D)** SQLi -> Credential Reuse -> SSH -> Privilege Escalation

---

Correct Flag: **D**


---

# Finished?

[Back to Card's Main Page](/Cards/IC/Compromised_Web_Server.md)
