![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 – Simple Web Exploit

A small company hosts a login page for internal staff. During testing, you notice that the login form behaves strangely when special characters are used.

Your goal is to identify what type of vulnerability is present.

---

## Observation

When entering:

`' OR '1'='1`

the application logs you in without valid credentials.

---

## Question

What **vulnerability** is being exploited?

---

## Flags (Choose One)

- **A)** Cross-Site Scripting (XSS)
- **B)** SQL Injection
- **C)** Command Injection
- **D)** Broken Authentication

---

Correct Flag: **B**

---

# Finished?

[Next Question](CWS_easy-2.md)

[Back to Card's Main Page](/Cards/IC/Compromised_Web_Server.md)
