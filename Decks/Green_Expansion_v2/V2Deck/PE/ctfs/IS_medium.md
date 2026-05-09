![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - SIEM Alert Triage

Your SIEM fires an alert. You pull the correlated events and see the following timeline for the account `l.ford@company.internal`:

```
08:14 - Successful login from 10.0.2.88 (office network)
08:15 - Successful login from 91.108.56.14 (Tor exit node - RU)
08:16 - Mail forwarding rule created: all incoming mail -> l.ford.backup@proton.me
08:17 - 47 emails sent to contacts in l.ford's address book
08:19 - Attachment opened on workstation: Invoice_2024.docm (macro-enabled)
08:22 - PowerShell execution detected on workstation (encoded command)
```

---

## Question

Looking at this sequence, what is the correct order of events as the attacker carried them out?

---

## Flags (Choose One)

- **A)** Malware ran first, then the attacker used it to steal credentials and log in remotely
- **B)** The attacker logged in using stolen credentials, set up email forwarding to maintain visibility, sent phishing emails to new targets, and the macro execution indicates a second-stage payload was triggered on the workstation
- **C)** A legitimate user logged in from two locations due to a VPN split-tunnel, and the PowerShell alert is a false positive from a software update
- **D)** The forwarding rule was created by the mail server automatically as part of a backup policy

---

Correct Flag: **B**

---

# Finished?
[Next Question](IS_hard.md)
[Back to Card's Main Page](../Internal_Spearphishing.md)
