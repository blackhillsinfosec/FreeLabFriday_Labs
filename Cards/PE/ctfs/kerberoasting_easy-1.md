![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 – Finding SPNs

You have access to a Windows domain as a **low-privileged domain user**

During basic Active Directory enumeration, you run a command to list Service Principal Names (SPNs) and get the following result:

```
ServicePrincipalName        Name               MemberOf
--------------------------  -----------------  ----------------
MSSQLSvc/db01.lab.local     sqlservice         Domain Users
HTTP/web.lab.local          websvc             Domain Users
```

---

## Question

Why is this information interesting to an attacker?

---

## Flags (Choose One)

- **A)** These services are misconfigured and will crash  
- **B)** These accounts can be targeted for Kerberoasting  
- **C)** These services are exposed to the internet  
- **D)** These accounts have expired passwords  

---

Correct Flag: **B**

---

# Finished?

[Next Question](kerberoasting_easy-2.md)

[Back to Card's Main Page](/Cards/PE/Kerberoasting.md)
