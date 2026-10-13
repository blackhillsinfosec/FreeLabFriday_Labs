## Full MITM Attack

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
