## Full Credential Chain

You are a SOC analyst investigating a potential breach. Here is a timeline of events reconstructed from logs across multiple systems:

```
[Day 1 - 10:32 AM]  User "m.santos" logs in from IP 185.220.101.47 (known Tor exit node)
[Day 1 - 10:35 AM]  m.santos reads 47 files across \\FILESERVER\Finance\ in under 3 minutes
[Day 1 - 10:41 AM]  m.santos accesses \\FILESERVER\IT\Scripts\db_connect.py
[Day 1 - 10:44 AM]  New login from service account "svc_db" - source: m.santos workstation
[Day 1 - 10:49 AM]  svc_db authenticates against PRODDB-01 (production database server)
[Day 1 - 10:51 AM]  Large outbound data transfer detected from PRODDB-01 → 185.220.101.47
```

Contents of `db_connect.py` (retrieved from file server):

```python
DB_HOST = "PRODDB-01"
DB_USER = "svc_db"
DB_PASS = "Pr0dDB#Secure99"
```
