## Service Account Misuse

You are checking SIEM alerts related to a service account used by a third-party backup provider.

Logs show:

```
service_account=backup_sync
action=create_new_admin
target=it-support-user
time=02:43
```

This account normally only reads storage snapshots.
