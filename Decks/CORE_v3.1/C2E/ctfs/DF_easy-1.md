![image](/FilesForLabs/images/blueantisyphon.png)

## Spot the Front

A security analyst is reviewing a packet capture from a workstation that flagged a behavioral alert. They inspect an outbound HTTPS connection and notice the following:

```
TLS SNI (visible during handshake):  cdn.legit-software.com
HTTP Host header (inside encrypted request):  updates.totally-not-c2.net
Destination IP:  104.21.x.x  (Cloudflare range)
```
