## Lateral Movement Interrupted

You are analyzing a security incident. The timeline below was reconstructed from SIEM logs:

```
08:14 - Host A (192.168.1.10) receives malicious email attachment, user opens it
08:17 - Outbound C2 connection established from Host A to 185.220.x.x
08:31 - Host A begins SMB authentication attempts against Host B and Host C
08:33 - Successful login to Host B (192.168.1.20) using credentials from Host A
08:45 - EDR isolation command pushed to Host A
08:46 - Host A network containment confirmed
08:52 - New outbound C2 connection detected - source: Host B (192.168.1.20)
```
