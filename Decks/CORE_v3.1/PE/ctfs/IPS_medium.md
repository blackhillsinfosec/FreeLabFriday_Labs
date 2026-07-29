![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Evade the Lockout

Your organization has an account lockout policy: **5 failed attempts within 10 minutes** locks the account for 30 minutes.

A UEBA alert fires, flagging "anomalous authentication behavior." You pull the raw logs and find this:

```
[09:00:01] FAILED  alice.chen      Password: Welcome1!       (src: 10.0.0.12)
[09:00:03] FAILED  bob.walker      Password: Welcome1!       (src: 10.0.0.12)
[09:00:05] FAILED  carol.james     Password: Welcome1!       (src: 10.0.0.12)
...
[09:10:02] FAILED  alice.chen      Password: January2024!    (src: 10.0.0.12)
[09:10:04] FAILED  bob.walker      Password: January2024!    (src: 10.0.0.12)
...
[09:20:01] FAILED  alice.chen      Password: Company123!     (src: 10.0.0.12)
```

Each full round through all accounts takes just over 10 minutes.

---

## Question

What technique is the attacker using to avoid lockouts while still trying multiple passwords?

---

## Flags (Choose One)

- **A)** They are resetting the lockout counter by authenticating with a valid service account between attempts
- **B)** They are using a different source IP for every single attempt to distribute the failures
- **C)** They are targeting only service accounts, which typically have no lockout policy
- **D)** They are timing each spray round to fall outside the lockout observation window, cycling passwords slowly across all accounts

---

Correct Flag: **D**

---

# Finished?
[Next Question](IPS_hard.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Internal_Password_Spray.md)
