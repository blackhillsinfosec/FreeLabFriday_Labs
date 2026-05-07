![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)
# Medium CTF - Lateral Movement Interrupted

You are analyzing a security incident. The timeline below was reconstructed from SIEM logs:

```
08:14 - Host A (192.168.1.10) receives malicious email attachment, user opens it
08:17 - Outbound C2 connection established from Host A to 185.220.x.x
08:31 - Host A begins SMB authentication attempts against Host B and Host C
08:33 - Successful login to Host B (192.168.1.20) using credentials from Host A
08:45 - EDR isolation command pushed to Host A
08:46 - Host A network containment confirmed
08:52 - New outbound C2 connection detected - source: Host B (192.168.1.20)
```

---

## Question

What does the 08:52 event tell you about the state of the incident?

---

## Flags (Choose One)

- **A)** The EDR isolation of Host A was applied too late - the attacker had already moved to Host B before containment
- **B)** The attacker tunneled through Host A's management channel to reach Host B after isolation
- **C)** Host B's C2 connection is unrelated to the incident on Host A
- **D)** Isolating Host A automatically triggered the EDR agent on Host B

---

Correct Flag: **A**

---

# Finished?
[Next Question](ISO_hard.md)
[Back to Card's Main Page](/Cards/DET/Isolation.md)
