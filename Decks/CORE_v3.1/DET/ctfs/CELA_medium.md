## Privilege Escalation Trail

You are investigating a potential insider threat. A developer account triggered several alerts in your SIEM over two hours. Below is the condensed event timeline:

```
[09:12] IAMUser: dev-maria  ->  ListRoles            (Success)
[09:13] IAMUser: dev-maria  ->  ListPolicies          (Success)
[09:15] IAMUser: dev-maria  ->  GetPolicyVersion      (Success)
[09:31] IAMUser: dev-maria  ->  CreatePolicyVersion   (Success) <- new policy version sets Action: "*", Resource: "*"
[09:32] IAMUser: dev-maria  ->  SetDefaultPolicyVersion (Success)
[09:33] IAMUser: dev-maria  ->  AttachUserPolicy      (Success) <- policy attached to dev-maria
[09:47] IAMUser: dev-maria  ->  CreateUser            (Success) <- new user: "svc-backup-temp"
[09:48] IAMUser: dev-maria  ->  CreateAccessKey       (Success) <- key created for svc-backup-temp
[10:02] IAMUser: svc-backup-temp -> AssumeRole: AdminRole (Success)
```

The `dev-maria` account was supposed to have read-only access to EC2 resources only.
