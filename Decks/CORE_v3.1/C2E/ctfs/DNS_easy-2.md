## Spotting Tunneled Traffic

You are reviewing firewall logs after an alert fires on an internal host.

You notice the following pattern over a 30-minute window:

```
10:02:14  DNS query  ->  c2.exfil-test.net        (subdomain length: 48 chars)
10:02:44  DNS query  ->  c2.exfil-test.net        (subdomain length: 52 chars)
10:03:14  DNS query  ->  c2.exfil-test.net        (subdomain length: 50 chars)
10:03:44  DNS query  ->  c2.exfil-test.net        (subdomain length: 47 chars)
```

Queries are being made every **30 seconds**, even though no user is actively using the machine.
