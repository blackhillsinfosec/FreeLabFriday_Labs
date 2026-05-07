![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 – The Forgotten Admin Panel

You’re doing external recon for a permitted engagement. A single public IP is in scope.

A quick service check gives you this:

```
80/tcp   open  http
443/tcp  open  https
8080/tcp open  http-proxy
```

Browsing `http://<TARGET>:8080/` shows a login page titled:

**“Jenkins”**

You also notice the server responds differently depending on the URL:

- `/login` → login page
- `/api/json` → returns data without prompting for login

---

## Goal

Pick the **most likely** initial path to get a foothold **fast** (CTF-style), based on what you see.

---

## Question

What should you try first?

---

## Flags (Choose One)

- **A)** Launch a full credential stuffing campaign against the domain  
- **B)** Check for **unauthenticated exposure** via Jenkins endpoints/API and misconfigurations  
- **C)** Attempt SQL injection against the login form  
- **D)** Pivot internally using ARP spoofing  

---

Correct Flag: **B**

---

# Finished?

[Next Question](ESE_easy-2.md)

[Back to Card's Main Page](/Cards/IC/External_Service_Exploitation.md)
