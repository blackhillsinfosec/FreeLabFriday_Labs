![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Log the Attacker

You are a SOC analyst. Your SIEM fired an alert for unusual mailbox activity on the account `c.hayes@corp.net`. You pull the full event timeline for that account over the past 24 hours:

```
09:02 AM - Successful login | IP: 82.144.67.201 (Netherlands) | Device: Unknown
09:03 AM - Successful login | IP: 10.0.1.45 (Corporate VPN) | Device: Work Laptop
09:04 AM - Set-InboxRule | IP: 82.144.67.201 | Rule: Move emails where subject contains
           "alert", "suspicious", "security", "IT" to folder "RSS Subscriptions"
09:06 AM - Accessed folder: Sent Items | IP: 82.144.67.201
09:09 AM - Accessed folder: RSS Subscriptions | IP: 82.144.67.201
09:11 AM - Successful login | IP: 10.0.1.45 (Corporate VPN) | Device: Work Laptop
```

The user `c.hayes` reports they were at their desk from 9 AM and noticed nothing unusual.

---

## Question

Based on the log, what most likely occurred between 9:02 and 9:09 AM?

---

## Flags (Choose One)

- **A)** The user logged in from two devices simultaneously - this is normal behavior for remote workers
- **B)** An attacker logged in from a foreign IP, created a rule to hide security alerts, and browsed the mailbox before the legitimate user noticed
- **C)** The SIEM alert was a false positive caused by a VPN misconfiguration splitting the session
- **D)** IT remotely accessed the account to perform maintenance and forgot to log out

---

Correct Flag: **B**

---

# Finished?

[Next Question](MER_hard.md)  
[Back to Card's Main Page](../Malicious_Email_Rules.md)
