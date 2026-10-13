## Stealthy Attack Timeline Reconstruction

You are investigating a possible compromise using SIEM data from multiple sources.

Timeline:

```
01:12:44  VPN login success   user: backup_admin   source_ip: 203.0.113.77
01:13:10  AUTH  privilege escalation detected
01:14:22  FILE  archive created: finance_backup.zip
01:15:03  NETWORK  outbound transfer to 203.0.113.77
01:16:40  LOG  log cleanup command executed
```

The account normally connects only during business hours from internal addresses.
