![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 – Default Creds, Real Consequences

You find an externally reachable service on a target host

A banner grab shows:

```
80/tcp open  http
Server: Apache Tomcat/9.0.XX
Title: "Tomcat Manager Application"
```

When you visit `/manager/html`, you get a browser authentication prompt (Basic Auth)

---

## Goal

Pick the most likely way a red team gets in **first**, before spending time on anything fancy

---

## Question

What most likely leads to access here?

---

## Flags (Choose One)

- **A)** The service is only vulnerable to a zero-day  
- **B)** The manager interface is exposed and protected by **weak/default credentials**  
- **C)** The page is harmless because it uses HTTPS  
- **D)** The correct approach is to phish an employee first  

---

Correct Flag: **B**

---

# Finished?

[Next Question](ESE_medium.md)

[Back to Card's Main Page](/Cards/IC/External_Service_Exploitation.md)
