![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF – Deception-Based Detection Scenario

During an incident, you see the following timeline:

```
08:12 - Access to decoy AWS credentials stored on a server
08:14 - Outbound connection to an unknown IP
08:16 - Alert from CanaryToken tied to those credentials
08:18 - Attempts to enumerate cloud storage resources
```

The credentials were intentionally fake and only existed for detection purposes.

---

## Question

What is the strongest conclusion you can draw?

---

## Flags (Choose One)

- **A)** The cloud provider leaked credentials
- **B)** A penetration test is automatically running
- **C)** The alerts are unrelated and can be ignored
- **D)** An attacker stole and attempted to use decoy credentials

---

Correct Flag: **D**

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Active_Defense_And_Cyber_Deception.md)
