![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF – Internet to Internal

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

---

## Question

What most likely completes the “internet-to-internal pivot” here?

---

## Flags (Choose One)

- **A)** Use the leaked configuration to obtain credentials, then use SSH to establish a tunnel/pivot to reach `db01.internal.local`  
- **B)** Keep refreshing the web page until the database appears  
- **C)** Run a DDoS to distract defenders and hope the DB opens up  
- **D)** Email the database admin asking for access  

---

Correct Flag: **A**

---

# Finished?

[Back to Card's Main Page](/Cards/IC/External_Service_Exploitation.md)
