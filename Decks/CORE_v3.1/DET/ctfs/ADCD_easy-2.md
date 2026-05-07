![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 – Finding the Canary

A document containing a hidden tracking link (a canary token) was placed on an internal file share.

Later, an alert appears:

```
Token triggered
Source IP: 185.77.12.90
User-Agent: curl/7.81.0
Location: External network
```

No employee should access this token from outside the company.

---

## Question

What is the best interpretation of this event?

---

## Flags (Choose One)

- **A)** The token shows that data was likely accessed or exfiltrated
- **B)** The monitoring system created a false positive
- **C)** The file server is offline
- **D)** A backup job triggered the alert

---

Correct Flag: **A**

---

# Finished?

[Next Question](ADCD_medium.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Active_Defense_And_Cyber_Deception.md)
