![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Account Enumeration

You are a junior analyst reviewing Kerberos traffic on your internal network. A colleague flagged an unusual spike in `AS-REQ` packets coming from a single workstation over a short period of time.

You pull the capture and see hundreds of requests like this, each with a different username:

```
AS-REQ: john.smith@corp.local
AS-REQ: jane.doe@corp.local
AS-REQ: admin@corp.local
AS-REQ: helpdesk@corp.local
AS-REQ: ...
```

Each request comes from `192.168.1.47` within a 3-minute window.

---

## Question

What is the attacker most likely doing at this stage?

---

## Flags (Choose One)

- **A)** Attempting to crack password hashes offline
- **B)** Exploiting a Kerberos delegation misconfiguration
- **C)** Enumerating valid domain accounts before launching a spray
- **D)** Performing a denial of service against the domain controller

---

Correct Flag: **C**

---

# Finished?
[Next Question](IPS_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Internal_Password_Spray.md)
