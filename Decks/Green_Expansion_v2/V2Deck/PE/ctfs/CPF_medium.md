## Credential Pivot

You are on an internal Windows machine as a low-privilege user. You run Snaffler and it comes back with a hit on a network share:

```
[Share]  \\FILESERVER01\deployments
[File]   deploy.ps1
[Match]  Line 14: $adminPass = "Corp@dmin2022"
[Match]  Line 15: $adminUser = "svc_deploy"
```

You check Active Directory and find that `svc_deploy` is a service account. You also notice the account is listed as a member of the `Domain Admins` group.

You attempt to authenticate to the domain controller using these credentials over WinRM:

```
Enter-PSSession -ComputerName DC01 -Credential corp\svc_deploy
```

The session opens successfully.
