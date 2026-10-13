![image](/FilesForLabs/images/blueantisyphon.png)

## Suspicious Login Pattern

You are reviewing authentication logs inside a SIEM dashboard after an alert about unusual logins.

You notice the following events:

```
08:12:03  user: admin   status: failed   source_ip: 185.22.11.34
08:12:05  user: admin   status: failed   source_ip: 185.22.11.34
08:12:07  user: admin   status: failed   source_ip: 185.22.11.34
08:12:09  user: admin   status: success  source_ip: 185.22.11.34
```

A few minutes later, a new admin account appears.
