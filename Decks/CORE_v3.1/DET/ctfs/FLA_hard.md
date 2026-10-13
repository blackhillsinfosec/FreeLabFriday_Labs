## Incident Timeline Reconstruction

You are given firewall logs collected during a suspected breach:

```
09:01:13 ALLOW SRC=198.51.100.77 DST=10.0.0.20 DPT=443
09:04:22 ALLOW SRC=10.0.0.20 DST=10.0.3.15 DPT=3389
09:06:41 ALLOW SRC=10.0.3.15 DST=203.0.113.200 DPT=53
09:07:03 ALLOW SRC=10.0.3.15 DST=203.0.113.200 DPT=443
```

Host `10.0.0.20` is a public-facing web server.  
Host `10.0.3.15` is an internal workstation.
