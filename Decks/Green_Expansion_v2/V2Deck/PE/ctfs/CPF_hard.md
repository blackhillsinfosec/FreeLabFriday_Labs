## Full Credential Hunt

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
