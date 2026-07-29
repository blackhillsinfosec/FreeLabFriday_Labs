![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Full Domain Compromise

You are performing a post-incident forensic review. The timeline of events is reconstructed below:

```
Day 1 - 09:12  Responder started on attacker machine (10.0.0.55)
Day 1 - 09:14  NTLMv2 hash captured: CORP\svc_backup
Day 1 - 09:15  Hash relayed to DC01 - SMB signing: NOT enforced
Day 1 - 09:15  Authenticated to DC01 as svc_backup
Day 1 - 09:16  DCSync operation initiated from 10.0.0.55
Day 1 - 09:17  NTLM hash for CORP\Administrator extracted
Day 1 - 09:18  Pass-the-Hash login to all domain-joined hosts
Day 1 - 09:20  All domain machines compromised
```

The svc_backup account was a standard service account with no special privileges listed in AD. SMB signing was disabled on the domain controller.

---

## Question

Which two conditions, both present in this environment, made full domain compromise possible in under 10 minutes?

---

## Flags (Choose One)

- **A)** Weak password policy and no antivirus on the domain controller
- **B)** SMB signing not enforced on the DC, and svc_backup having implicit replication privileges due to its group membership
- **C)** The attacker had physical access to the domain controller
- **D)** The domain controller was running SMBv1 and had RDP exposed to the internet

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](../SMB_Abuse.md)
