![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - NTLM Relay Attack

You are investigating a security incident. A junior analyst flagged some strange authentication logs on an internal file server (`FS01`). You pull the relevant logs and also find a packet capture from the same timeframe.

**Authentication log on FS01:**
```
[2024-11-14 09:22:41] Successful login - User: CORP\svc_backup - Source IP: 192.168.1.80
[2024-11-14 09:22:41] Accessed share: \\FS01\Finance
[2024-11-14 09:22:42] File read: Q3_Payroll.xlsx
```

**Packet capture (same time window):**
```
09:22:39  192.168.1.55 → 224.0.0.252   LLMNR    query: FS01
09:22:39  192.168.1.80 → 192.168.1.55  LLMNR    response: 192.168.1.80
09:22:40  192.168.1.55 → 192.168.1.80  SMB      NTLMSSP_NEGOTIATE
09:22:40  192.168.1.80 → 192.168.1.20  SMB      NTLMSSP_NEGOTIATE  (forwarded)
09:22:41  192.168.1.20 → 192.168.1.80  SMB      NTLMSSP_CHALLENGE
09:22:41  192.168.1.80 → 192.168.1.55  SMB      NTLMSSP_CHALLENGE  (forwarded)
09:22:41  192.168.1.55 → 192.168.1.80  SMB      NTLMSSP_AUTH  [svc_backup hash]
09:22:41  192.168.1.80 → 192.168.1.20  SMB      NTLMSSP_AUTH  (forwarded)
```

`192.168.1.55` is a legitimate workstation. `192.168.1.20` is the real FS01. `192.168.1.80` is a workstation that should not be involved in this exchange at all.

---

## Question

What attack is being carried out, and what makes it different from simply capturing a hash?

---

## Flags (Choose One)

- **A)** The attacker cracked the NTLMv2 hash offline and used the plaintext password to log in
- **B)** The attacker used Responder to capture the hash and saved it for later use
- **C)** The attacker is running a brute force attack against FS01 using common passwords
- **D)** The attacker is relaying the authentication in real time to FS01, gaining access without ever knowing the password

---

Correct Flag: **D**

---

# Finished?
[Next Question](BMPP_hard.md)  
[Back to Card's Main Page](../Broadcast-Multicast_Protocol_Poisoning.md)
