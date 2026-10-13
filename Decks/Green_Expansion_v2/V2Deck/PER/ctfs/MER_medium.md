## Log the Attacker

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
