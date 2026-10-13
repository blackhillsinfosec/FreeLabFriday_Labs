## Kerberos Silver Ticket

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
