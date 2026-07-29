![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF – Lateral Movement Discovery

You are analyzing east-west network traffic after an alert from a domain controller.

You find this pattern:

```
Host: FINANCE-PC
Connections:
 - SMB (445) to 12 internal hosts within 5 minutes
 - Followed by authentication attempts
 - No similar behavior in previous baselines
```

---

## Question

What does this activity MOST likely indicate?

---

## Flags (Choose One)

- **A)** Normal file sharing activity
- **B)** Backup software running
- **C)** Lateral movement using stolen credentials
- **D)** Network health monitoring

---

Correct Flag: **C**

---

# Finished?

[Next Question](NTH_hard.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Network_Threat_Hunting.md)
