![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Full Domain Takeover

Your SOC receives an alert at 01:30 AM. A UEBA rule fired on a service account called `svc_backup`. The account normally only runs scheduled backup jobs on one server between 11 PM and midnight.

Tonight it did the following:

```
01:12 AM - Kerberos TGT requested for svc_backup
01:14 AM - LDAP query: (objectClass=computer) returned 847 results
01:17 AM - LDAP query: (objectClass=group)(name=*admin*) returned 14 results
01:19 AM - SMB connection to DC01 (Domain Controller)
01:22 AM - EventID 4768: TGS ticket requested for krbtgt account
01:28 AM - DCSync operation detected (replication request from non-DC host)
```

BloodHound data from last week shows:

```
svc_backup -> [GetChangesAll] -> Domain (corp.local)
```

The `GetChangesAll` permission allows a principal to request replication of all AD data, including password hashes.

---

## Question

Based on the full chain of events, what attack was successfully carried out?

---

## Flags (Choose One)

- **A)** Pass-the-Hash attack using a stolen NTLM hash from a local workstation
- **B)** A DCSync attack leveraging a misconfigured ACL on the domain object to extract all password hashes, including the krbtgt account
- **C)** A brute force attack against the Domain Controller's RDP service
- **D)** Kerberoasting - requesting service tickets for offline password cracking

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](/Decks/CORE_v3.1/WAD_main.md)
