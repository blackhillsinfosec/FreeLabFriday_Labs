![image](/FilesForLabs/images/blueantisyphon.png)

## Suspicious Login

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
