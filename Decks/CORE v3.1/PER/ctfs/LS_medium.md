![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - GPO Abuse

Your team is investigating unusual activity across multiple machines in a corporate domain. Several users report that a new shortcut appeared on their desktops after logging in. EDR alerts show an unknown process spawning from `logon.bat` on over 30 machines.

You pull the relevant Group Policy Object and find:

```
GPO Name:    IT_Maintenance_Policy
Linked To:   corp.local (Domain Root)
Script Type: Logon
Script Path: \\corp.local\SYSVOL\corp.local\scripts\logon.bat
Modified By: helpdesk_temp
Modified At: 2024-11-03 02:14:33
```

The `helpdesk_temp` account was created three days ago and has no ticket associated with it.

---

## Question

Which of the following best describes what happened?

---

## Flags (Choose One)

- **A)** A legitimate IT admin pushed a maintenance script through standard GPO procedures
- **B)** An attacker used a compromised or rogue account to modify a domain-wide GPO and distribute a malicious logon script to all users
- **C)** The EDR generated a false positive caused by a recently updated antivirus definition
- **D)** A developer accidentally deployed a test script to production via the wrong policy

---

Correct Flag: **B**

---

# Finished?
[Next Question](LS_hard.md)  
[Back to Card's Main Page](../Logon_Scripts.md)
