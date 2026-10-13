## GPO Abuse

Your team is investigating unusual activity across multiple machines in a corporate domain. Several users report that a new shortcut appeared on their desktops after logging in. EDR alerts show an unknown process spawning from `logon.bat` on over 30 machines.

You pull the relevant Group Policy Object and find:

```
GPO Name:    IT_Maintenance_Policy
Linked To:   corp.local (Domain Root)
Script Type: Logon
Script Path: \\corp.local\SYSVOL\corp.local\scripts\logon.bat
Modified By: helpdesk_temp
Modified At: 2024-11-03 02:14:33
```

The `helpdesk_temp` account was created three days ago and has no ticket associated with it.
