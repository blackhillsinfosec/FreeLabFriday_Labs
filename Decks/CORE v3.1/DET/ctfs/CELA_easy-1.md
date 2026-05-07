![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Suspicious Login

You are analyzing cloud audit logs from your company's AWS environment. A security alert fired overnight. You pull the relevant log entry:

```
{
  "eventTime": "2024-11-14T02:47:13Z",
  "eventName": "ConsoleLogin",
  "userIdentity": {
    "type": "IAMUser",
    "userName": "john.doe"
  },
  "sourceIPAddress": "185.220.101.47",
  "userAgent": "Mozilla/5.0",
  "responseElements": {
    "ConsoleLogin": "Success"
  },
  "awsRegion": "eu-central-1"
}
```

John Doe is a developer based in Romania. He works standard business hours. The IP `185.220.101.47` is a known Tor exit node. The login happened at 2:47 AM.

---

## Question

What is the most likely explanation for this login event?

---

## Flags (Choose One)

- **A)** John logged in early to finish a deployment before business hours
- **B)** An attacker used John's credentials and accessed the console through Tor
- **C)** The login failed but was logged anyway due to a misconfiguration
- **D)** AWS automatically rotated John's session token

---

Correct Flag: **B**

---

# Finished?
[Next Question](CELA_easy-2.md)  
[Back to Card's Main Page](/Cards/DET/Cloud_Event_Log_Analysis.md)
