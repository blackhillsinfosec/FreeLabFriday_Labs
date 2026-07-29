![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Spot the Account

You are reviewing the local user list on a Windows workstation after an alert fired on the endpoint. The machine belongs to a regular employee - no admin work is scheduled for it.

You run the following command and get this output:

```
net user

User accounts for \\WORKSTATION-04

-------------------------------------------------------------------------------
jsmith               mlopez               k.anderson
svc_backup           helpdesk             support_temp01
```

You check your HR system. The active employees on this machine are: `jsmith`, `mlopez`, and `k.anderson`. The account `svc_backup` is a known service account managed by IT. `helpdesk` is a shared account used occasionally by the support team.

---

## Question

Which account is most likely the one created by an attacker to maintain persistence?

---

## Flags (Choose One)

- **A)** `svc_backup`
- **B)** `helpdesk`
- **C)** `support_temp01`
- **D)** `k.anderson`

---

Correct Flag: **C**

---

# Finished?

[Next Question](NUA_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/New_User_Added.md)
