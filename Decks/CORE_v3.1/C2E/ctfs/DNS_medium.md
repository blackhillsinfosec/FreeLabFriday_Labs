## C2 Beacon Identification

During a threat hunt, your SIEM flags a host for unusual DNS behavior. You pull the following log excerpt:

```
Host: DESKTOP-4F9KL
Timeframe: 08:00 – 10:00

08:00:01  TXT query  ->  cmd.beacon-relay.io   Response: "whoami"
08:00:03  A   query  ->  cm9vdA==.beacon-relay.io
08:15:01  TXT query  ->  cmd.beacon-relay.io   Response: "ipconfig /all"
08:15:04  A   query  ->  MTkyLjE2OC4xLjU=.beacon-relay.io
08:30:01  TXT query  ->  cmd.beacon-relay.io   Response: "net user"
08:30:05  A   query  ->  QWRtaW5pc3RyYXRvcg==.beacon-relay.io
```

The subdomains in the A queries decode from Base64 to:
- `cm9vdA==` -> `root`
- `MTkyLjE2OC4xLjU=` -> `192.168.1.5`
- `QWRtaW5pc3RyYXRvcg==` -> `Administrator`
