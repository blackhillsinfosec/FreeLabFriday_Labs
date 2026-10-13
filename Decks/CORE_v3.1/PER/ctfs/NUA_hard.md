## Full Intrusion Timeline

You are conducting a post-incident investigation. An alert fired four days after the initial compromise - meaning you are working backward from limited artifacts. Logs have been partially cleared, but enough remains.

---

**Available Evidence**

**Firewall logs (Day 1, external traffic):**
```
08:34:11  ALLOW  TCP  185.220.101.47:54312  ->  10.0.1.15:443   [POST /login]
08:34:19  ALLOW  TCP  185.220.101.47:54312  ->  10.0.1.15:443   [POST /login]
08:34:21  ALLOW  TCP  185.220.101.47:54312  ->  10.0.1.15:443   [POST /login - 200 OK]
```

**IIS logs (Day 1, same server):**
```
08:41:03  POST /admin/import.aspx  200  185.220.101.47
08:41:55  GET  /admin/temp_upload/update.aspx  200  185.220.101.47
08:42:11  POST /admin/temp_upload/update.aspx  200  185.220.101.47
```

**Windows Security Events (Day 1):**
```
08:42:15  Event 4720  -  Account created:    itops_automation
08:42:16  Event 4732  -  Added to group:     Domain Admins
08:42:20  Event 4624  -  Logon type 3 (network) by: itops_automation  from: 185.220.101.47
```

**Active Directory (queried on Day 4 during investigation):**
```
Account:        itops_automation
Created:        Day 1, 08:42:15
Last logon:     Day 4, 01:17:03
Password set:   Day 1, 08:42:15
Member of:      Domain Admins, Enterprise Admins
Group added:    Enterprise Admins - Day 3, 23:58:41
```

**SIEM alert that triggered the investigation (Day 4):**
```
ALERT: Unusual Kerberos TGT request - itops_automation - 01:17:03
Source IP: 10.0.8.44  (internal - workstation belonging to: H.Pereira, Finance Dept.)
```
