## Full Behavioral Attack Chain

You are the senior analyst on call. At 03:20, your UEBA platform fires a **Critical** alert. You have raw data from four entities. Your job is to reconstruct what happened and answer the question at the end.

---

### Entity 1 - User: `alex.Popescu` (IT Helpdesk)

Baseline: Works 09:00-18:00. Manages password resets. Never touches servers directly.

```
02:58  Successful login from IP 94.102.49.190 (Tor exit node)
03:01  Password reset performed on account: svc_deploy
03:03  Password reset performed on account: admin_backup
03:04  RDP session opened to BUILD-SERVER-03
```

---

### Entity 2 - Account: `svc_deploy` (CI/CD service account)

Baseline: Triggered only by GitLab pipelines. Never runs interactively.

```
03:06  Interactive login to BUILD-SERVER-03 with new credentials
03:08  Pulled latest code from repo: payment-gateway
03:09  Modified file: deploy_config.yml
03:11  Pushed build artifact to PROD-SERVER-01
```

---

### Entity 3 - Server: `PROD-SERVER-01`

Baseline: Receives deployments Friday nights only. No direct logins.

```
03:12  New artifact deployed from BUILD-SERVER-03
03:13  Outbound connection established: 185.220.100.255:4444
03:14  Process spawned: cmd.exe -> powershell.exe -enc [base64 payload]
03:15  Volume of outbound traffic: 820 MB over 6 minutes
```

---

### Entity 4 - User: `alex.Popescu` (same session)

```
03:16  Cleared Windows Event Log on BUILD-SERVER-03
03:17  Deleted RDP session history
03:18  Session terminated
```
