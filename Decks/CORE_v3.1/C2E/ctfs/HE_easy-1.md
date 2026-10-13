![image](/FilesForLabs/images/blueantisyphon.png)

## Spot the Beacon

A security analyst is reviewing outbound HTTPS traffic from a workstation that was flagged by the firewall.

The logs show the following connections over a 2-hour window:

```
10:00:03  192.168.1.45 -> 185.220.101.12:443  POST /api/v1/sync  200 OK
10:05:03  192.168.1.45 -> 185.220.101.12:443  POST /api/v1/sync  200 OK
10:10:04  192.168.1.45 -> 185.220.101.12:443  POST /api/v1/sync  200 OK
10:15:03  192.168.1.45 -> 185.220.101.12:443  POST /api/v1/sync  200 OK
10:20:03  192.168.1.45 -> 185.220.101.12:443  POST /api/v1/sync  200 OK
```

The destination IP has no known reputation and is not associated with any business software installed on the machine.
