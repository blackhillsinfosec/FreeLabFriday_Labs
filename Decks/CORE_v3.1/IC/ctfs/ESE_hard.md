## Internet to Internal

This challenge is about turning an external service foothold into **real impact**

You have one public target in scope: `203.0.113.10`

Your recon notes:

### 1) Exposed Services
```
22/tcp   open  ssh
443/tcp  open  https
5000/tcp open  http
```

### 2) What you find on port 5000
A plain web page with a directory listing. One interesting file stands out:

`backup-config.zip`

Inside it, you find:

- `appsettings.json` containing a connection string for an internal database host:  
  `db01.internal.local:5432`
- a username that looks real: `svc_app`
- and a line that suggests SSH access is permitted from the app host to internal systems

### 3) SSH is reachable from the internet
SSH is configured with password auth enabled

---

## Goal

Choose the best red-team path to go from **external exposure** → **internal access**
