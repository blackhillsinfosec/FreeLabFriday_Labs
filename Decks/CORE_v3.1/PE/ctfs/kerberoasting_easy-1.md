![image](/FilesForLabs/images/blueantisyphon.png)

## Finding SPNs

You have access to a Windows domain as a **low-privileged domain user**

During basic Active Directory enumeration, you run a command to list Service Principal Names (SPNs) and get the following result:

```
ServicePrincipalName        Name               MemberOf
--------------------------  -----------------  ----------------
MSSQLSvc/db01.lab.local     sqlservice         Domain Users
HTTP/web.lab.local          websvc             Domain Users
```
