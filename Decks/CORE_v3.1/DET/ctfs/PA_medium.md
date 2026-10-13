## AD Attack Path

You run BloodHound against the domain and it highlights the following attack path:

```
p.stone (compromised account)
  └─ Member of: IT-Support
       └─ IT-Support has GenericAll on: svc_deploy
            └─ svc_deploy is Member of: Domain Admins
```

`p.stone` is a regular support employee. Their workstation was hit by a phishing email earlier today.
