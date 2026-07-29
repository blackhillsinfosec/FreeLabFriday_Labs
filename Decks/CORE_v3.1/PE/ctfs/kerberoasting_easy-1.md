![image](/FilesForLabs/images/blueantisyphon.png)

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

[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Kerberoasting.md)
