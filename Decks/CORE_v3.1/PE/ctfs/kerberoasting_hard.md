## Domain Escalation Path

You successfully cracked a service account password:

```
Account: sqlservice
Password: Winter2021!
```

Further investigation shows:

- The account is local admin on `DB01`
- `DB01` hosts a service running as SYSTEM
- Domain admins regularly log into `DB01`
