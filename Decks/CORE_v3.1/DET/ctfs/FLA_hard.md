![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF – Incident Timeline Reconstruction

You are given firewall logs collected during a suspected breach:

```
09:01:13 ALLOW SRC=198.51.100.77 DST=10.0.0.20 DPT=443
09:04:22 ALLOW SRC=10.0.0.20 DST=10.0.3.15 DPT=3389
09:06:41 ALLOW SRC=10.0.3.15 DST=203.0.113.200 DPT=53
09:07:03 ALLOW SRC=10.0.3.15 DST=203.0.113.200 DPT=443
```

Host `10.0.0.20` is a public-facing web server.  
Host `10.0.3.15` is an internal workstation.

---

## Question

What is the most likely sequence of events?

---

## Flags (Choose One)

- **A)** Normal user browsing followed by software updates  
- **B)** DNS cache refresh activity
- **C)** Backup replication between servers  
- **D)** External access to web server, then pivot to internal host and outbound communication  

---

Correct Flag: **D**

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Firewall_Log_Analysis.md)
