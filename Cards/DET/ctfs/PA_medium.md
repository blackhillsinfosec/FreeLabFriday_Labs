![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - AD Attack Path

You run BloodHound against the domain and it highlights the following attack path:

```
p.stone (compromised account)
  └─ Member of: IT-Support
       └─ IT-Support has GenericAll on: svc_deploy
            └─ svc_deploy is Member of: Domain Admins
```

`p.stone` is a regular support employee. Their workstation was hit by a phishing email earlier today.

---

## Question

The attacker now controls `p.stone`. What is the most likely next step in the attack chain, and why does this path lead to full domain compromise?

---

## Flags (Choose One)

- **A)** The attacker logs in as `p.stone` directly to a domain controller using RDP
- **B)** The attacker uses the `GenericAll` permission on `svc_deploy` to reset its password, then authenticates as `svc_deploy` - which has Domain Admin rights
- **C)** The attacker exploits a vulnerability in the BloodHound agent installed on the domain controller
- **D)** The attacker adds `p.stone` directly to Domain Admins using a local admin account

---

Correct Flag: **B**

---

# Finished?
[Next Question](PA_hard.md)  
[Back to Card's Main Page](/Cards/DET/Permissions_Audit.md)
