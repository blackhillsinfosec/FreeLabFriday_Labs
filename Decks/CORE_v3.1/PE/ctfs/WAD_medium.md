## ACL Abuse

You are investigating a security incident. A low-privilege user account named `j.harris` was found to have Domain Admin privileges, but was never manually added to the Domain Admins group.

Reviewing the AD audit logs, you find this entry:

```
EventID: 5136
Object: CN=Administrator,CN=Users,DC=corp,DC=local
Attribute: unicodePwd
Modified By: j.harris
Timestamp: 2024-11-14 03:12:08
```

Running a BloodHound analysis on `j.harris` reveals the following attack path:

```
j.harris -> [GenericWrite] -> helpdesk_group -> [GenericAll] -> Administrator
```
