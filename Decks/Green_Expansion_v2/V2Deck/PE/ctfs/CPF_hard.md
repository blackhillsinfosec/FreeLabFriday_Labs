![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF - Full Credential Hunt

You are a security analyst investigating a breach. The attacker has already been evicted, but you need to reconstruct what happened. You have access to endpoint logs, UEBA alerts, and a snapshot of the affected machine.

The timeline from the SIEM reads as follows:

```
[08:14:02]  User jsmith authenticates to WORKSTATION-04 (normal behavior)
[08:31:17]  Process: snaffler.exe spawned under jsmith - UEBA ALERT: unusual file enumeration
[08:31:45]  Snaffler accessed 47 paths across \\CORP-FS01\shared in 28 seconds
[08:32:10]  File read: \\CORP-FS01\shared\IT\old_scripts\db_migration_2021.bat
[08:32:11]  File content includes string matching password pattern - DLP ALERT
[08:33:05]  New authentication event: svc_dbadmin -> SQL-PROD-01 (first seen in 6 months)
[08:33:09]  SQL-PROD-01: large SELECT query executed against table "customers" (14,200 rows)
[08:33:44]  SQL-PROD-01: outbound connection to 185.220.xx.xx:443 - FIREWALL ALERT
```

The `.bat` file contained:

```bat
sqlcmd -S SQL-PROD-01 -U svc_dbadmin -P "D@taB@se#99" -Q "SELECT * FROM customers"
```

---

## Question

The security team wants to write a detection rule to catch this technique earlier in the kill chain. Looking at the full timeline, at what point could defenders have had the earliest reliable signal that something was wrong - before any data left the network?

---

## Flags (Choose One)

- **A)** The outbound firewall alert at 08:33:44, since that is when data actually left the environment
- **B)** The DLP alert at 08:32:11, when the content of the file matched a password pattern - this is the earliest point where the credential exposure itself was detected
- **C)** The SQL query at 08:33:09, since querying 14,200 rows from a customer table is abnormal and would trigger a volume-based alert
- **D)** The first-seen authentication of svc_dbadmin to SQL-PROD-01 at 08:33:05, since UEBA baselines flag accounts authenticating to systems they have not accessed in 6 months

---

Correct Flag: **D**

---

# Finished?

[Back to Card's Main Page](../Cleartext_Passwords_in_Files.md)
