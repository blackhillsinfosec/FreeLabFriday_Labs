## SIEM Alert Triage

Your SIEM fires an alert. You pull the correlated events and see the following timeline for the account `l.ford@company.internal`:

```
08:14 - Successful login from 10.0.2.88 (office network)
08:15 - Successful login from 91.108.56.14 (Tor exit node - RU)
08:16 - Mail forwarding rule created: all incoming mail -> l.ford.backup@proton.me
08:17 - 47 emails sent to contacts in l.ford's address book
08:19 - Attachment opened on workstation: Invoice_2024.docm (macro-enabled)
08:22 - PowerShell execution detected on workstation (encoded command)
```