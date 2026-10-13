![image](/FilesForLabs/images/blueantisyphon.png)

## Suspicious Connection Hunt

You are reviewing basic network flow logs from a small office network.

One internal workstation suddenly starts making repeated connections every 60 seconds to an external IP that no other machine contacts.

```
src_ip: 10.10.15.23
dst_ip: 185.199.110.5
dst_port: 443
interval: exactly every 60s
bytes_out: very small, consistent
```

The traffic is encrypted and the destination domain is newly registered.
