## Full C2 Takedown

Your team has been tracking a suspected intrusion for 48 hours. Here is what you have confirmed so far:

- A Sliver implant is running on `finance-ws-03`, disguised as a signed Windows service binary
- It is beaconing via domain fronting through Cloudflare, using `cdn.shopify.com` as the SNI
- The real Host header resolves to `update-check.io`, a domain registered 11 days ago
- Beacon interval is **randomized between 20 and 60 seconds** to avoid pattern detection
- The implant survives reboot via a scheduled task
- No lateral movement has been confirmed yet, but the machine has access to an internal file share

You need to contain the threat, preserve evidence for investigation, and disrupt the C2 infrastructure.
