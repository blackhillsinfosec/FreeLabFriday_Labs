![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - ACL Abuse

You are investigating a security incident. A low-privilege user account named `j.harris` was found to have Domain Admin privileges, but was never manually added to the Domain Admins group.

Reviewing the AD audit logs, you find this entry:

```
EventID: 5136
Object: CN=Administrator,CN=Users,DC=corp,DC=local
Attribute: unicodePwd
Modified By: j.harris
Timestamp: 2024-11-14 03:12:08
```

Running a BloodHound analysis on `j.harris` reveals the following attack path:

```
j.harris -> [GenericWrite] -> helpdesk_group -> [GenericAll] -> Administrator
```

---

## Question

How did `j.harris` most likely gain the ability to modify the Administrator account's password?

---

## Flags (Choose One)

- **A)** The account was added to Domain Admins by a rogue sysadmin
- **B)** The attacker exploited a vulnerability in the Domain Controller's OS
- **C)** The attacker used a phishing email to steal the Administrator's credentials directly
- **D)** A misconfigured ACL gave `j.harris` write permissions over a group that had full control of the Administrator object

---

Correct Flag: **D**

---

# Finished?
[Next Question](WAD_hard.md)  
[Back to Card's Main Page](/Cards/PE/Weaponizing_Active_Directory.md)
