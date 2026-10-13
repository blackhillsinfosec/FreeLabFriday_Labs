![image](/FilesForLabs/images/blueantisyphon.png)

## Spot the Account

You are reviewing the local user list on a Windows workstation after an alert fired on the endpoint. The machine belongs to a regular employee - no admin work is scheduled for it.

You run the following command and get this output:

```
net user

User accounts for \\WORKSTATION-04

-------------------------------------------------------------------------------
jsmith               mlopez               k.anderson
svc_backup           helpdesk             support_temp01
```

You check your HR system. The active employees on this machine are: `jsmith`, `mlopez`, and `k.anderson`. The account `svc_backup` is a known service account managed by IT. `helpdesk` is a shared account used occasionally by the support team.
