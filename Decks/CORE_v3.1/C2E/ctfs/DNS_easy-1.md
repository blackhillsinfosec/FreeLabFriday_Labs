![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - DNS Query Analysis

A security analyst is reviewing DNS logs from a workstation on the internal network.

They notice the following query repeated dozens of times over the last hour:

```
Query: aGVsbG8gd29ybGQ=.update.totallylegit-cdn.com
Type: A
```

The domain `totallylegit-cdn.com` was registered 3 days ago and has never been seen before on this network.

---

## Question

What does the subdomain `aGVsbG8gd29ybGQ=` most likely represent?

---

## Flags (Choose One)

- **A)** A randomly generated subdomain used for load balancing
- **B)** A typo in the application's DNS configuration
- **C)** Data encoded in Base64 being exfiltrated through DNS
- **D)** A standard CDN health check query

---

Correct Flag: **C**

---

# Finished?
[Next Question](DNS_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/C2E/Domain_Name_System_As_C2.md)
