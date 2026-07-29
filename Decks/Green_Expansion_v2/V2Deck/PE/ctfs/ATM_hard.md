![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Kerberos Silver Ticket

You have compromised a Windows host on a corporate network. Using Mimikatz, you extract the following from memory:

```
[*] Dumping service account credentials
Username : svc_mssql
Domain   : CORP
NTLM     : a87f3a337d73085c45f9416be5787d86
```

The `svc_mssql` account is the service account running the MSSQL database server on `db01.corp.local`. The domain SID is:

```
S-1-5-21-3462339348-1487291261-2085979659
```

You do not have a TGT (Ticket Granting Ticket) and the domain controller is not reachable from this host.

A teammate sends you this note:

> "With a Silver Ticket you can go straight to the service. You do not need the KDC at all - just the service account hash and the SID."

---

## Question

You want to forge a Silver Ticket to authenticate to the MSSQL service on `db01.corp.local` as a domain administrator. Analyzing the situation, which statement is correct?

---

## Flags (Choose One)

- **A)** A Silver Ticket requires the krbtgt hash, so this attack is not possible without reaching the domain controller
- **B)** You can forge the ticket using the svc_mssql NTLM hash and the domain SID, because Silver Tickets are signed with the service account's key - not the KDC's - so the domain controller is never contacted during authentication to that service
- **C)** The attack will fail because MSSQL validates all tickets against Active Directory in real time before granting access
- **D)** You need to first forge a Golden Ticket using the domain SID, then use it to request a Silver Ticket from the KDC normally

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](../Access_Token_Manipulation.md)
