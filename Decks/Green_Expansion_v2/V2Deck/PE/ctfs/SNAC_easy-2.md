## Dead Record Recon

You are doing a security audit and run a DNS zone dump on your internal domain. You find the following records still present:

```
vpn-old.corp.internal       A     192.168.10.22
backup-srv.corp.internal    A     192.168.10.55
test-db.corp.internal       A     192.168.10.81
```

After checking the asset inventory, none of these three IPs are assigned to any active system. All three were decommissioned over six months ago.
