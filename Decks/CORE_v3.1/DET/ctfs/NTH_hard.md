## Data Exfiltration Investigation

During a hunt focused on outbound traffic, you observe the following:

```
Host: ENG-SRV-04
Destination: cloud-storage.example
Protocol: HTTPS
Transfer size: ~8 GB
Time: 03:12 AM
History: Host usually sends less than 50 MB/day externally
```

No backup jobs are scheduled at this time, and the destination has never been contacted before.
