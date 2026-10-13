## Service Account Gone Wrong

You are reviewing UEBA alerts for your organization's Active Directory environment.

A service account called **svc_backup** is flagged. Its expected behavior:

- Runs automated backup jobs **nightly between 01:00 - 03:00**
- Only accesses **\\FILESERVER01\backups**
- Never performs interactive logins

The alert shows this activity from earlier today:

```
2024-11-15 11:22:05  Account: svc_backup  Action: Interactive login - SUCCESS
2024-11-15 11:23:41  Account: svc_backup  Action: Accessed \\DC01\SYSVOL
2024-11-15 11:24:10  Account: svc_backup  Action: Ran: whoami /all
2024-11-15 11:24:55  Account: svc_backup  Action: Accessed \\HR-SERVER\employees
```
