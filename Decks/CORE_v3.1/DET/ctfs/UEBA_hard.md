![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Behavioral Attack Chain

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

---

## Question

Which single action in this chain was the **critical control failure** that made the entire attack possible - and what type of control would have prevented it?

---

## Flags (Choose One)

- **A)** The Tor login by alex.Popescu - prevented by IP blocklisting at the firewall
- **B)** The password resets on privileged accounts performed by a helpdesk user without approval - prevented by Privileged Access Management (PAM) with dual authorization
- **C)** The outbound connection from PROD-SERVER-01 on port 4444 - prevented by egress filtering
- **D)** The base64-encoded PowerShell payload - prevented by an EDR with script-block logging

---

**Correct Flag: B**

---

# Finished?
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/UEBA_Analytics.md)
