## Evade the Lockout

Your organization has an account lockout policy: **5 failed attempts within 10 minutes** locks the account for 30 minutes.

A UEBA alert fires, flagging "anomalous authentication behavior." You pull the raw logs and find this:

```
[09:00:01] FAILED  alice.chen      Password: Welcome1!       (src: 10.0.0.12)
[09:00:03] FAILED  bob.walker      Password: Welcome1!       (src: 10.0.0.12)
[09:00:05] FAILED  carol.james     Password: Welcome1!       (src: 10.0.0.12)
...
[09:10:02] FAILED  alice.chen      Password: January2024!    (src: 10.0.0.12)
[09:10:04] FAILED  bob.walker      Password: January2024!    (src: 10.0.0.12)
...
[09:20:01] FAILED  alice.chen      Password: Company123!     (src: 10.0.0.12)
```

Each full round through all accounts takes just over 10 minutes.
