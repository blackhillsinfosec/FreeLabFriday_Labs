![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full MITM Attack

You are conducting a post-incident forensic review. An attacker positioned themselves between a victim and the internet on a corporate guest Wi-Fi network. The following is a reconstructed timeline from firewall logs, ARP tables, and traffic captures.

**ARP table anomaly detected at 09:14:**
```
192.168.0.1  ->  aa:bb:cc:dd:ee:ff   (legitimate gateway)
192.168.0.1  ->  11:22:33:44:55:66   (duplicate - attacker's MAC)
```

**SSLStrip output log (recovered from attacker's machine):**
```
[09:15:02] Stripping HTTPS from: https://portal.company-hr.com/login
[09:15:02] Serving HTTP version to client: http://portal.company-hr.com/login
[09:15:44] POST data intercepted:
           username=laura.chen
           password=W!nter2024
[09:15:45] Forwarding request to real server over HTTPS
```

**Server-side HSTS configuration (portal.company-hr.com):**
```
# No Strict-Transport-Security header present in server config
```

**Browser behavior:**  
The victim's browser had never visited the site before, so no cached HSTS policy existed. The browser followed the HTTP redirect without complaint.

---

## Question

Four junior analysts reviewed this incident and each gave a different root cause. Which analyst is correct?

---

## Flags (Choose One)

- **A)** *Analyst 1:* "The attacker broke the server's SSL certificate. The real fix is to renew it more frequently."
- **B)** *Analyst 2:* "The victim's browser is outdated and should have blocked the HTTP connection automatically regardless of server config."
- **C)** *Analyst 3:* "The server never sent an HSTS header, so the browser had no instruction to enforce HTTPS. Combined with ARP poisoning, the attacker intercepted the first HTTP request before a secure channel was established."
- **D)** *Analyst 4:* "The firewall failed to block the attacker's MAC address. HSTS is irrelevant here because the attack happened at Layer 2."

---

Correct Flag: **C**

---

# Finished?
[Back to Card's Main Page](../HSTS_main.md)
