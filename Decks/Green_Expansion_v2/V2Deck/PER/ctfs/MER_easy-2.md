## Forwarding Gone Wrong

You are reviewing a Microsoft 365 audit log after a finance employee reported that a vendor "never received" an invoice they sent last week.

You find this entry in the cloud event log:

```
Event: Set-InboxRule
Timestamp: 2024-10-21 11:47 PM
User: j.morris@company.com
IP Address: 194.87.12.33 (Russia)
Rule Details:
  - Condition: From contains "vendor" OR subject contains "invoice"
  - Action: Forward to external address d.shaw.fin@gmail.com
  - Then: Delete original
```

The employee's normal login location is the United Kingdom.
