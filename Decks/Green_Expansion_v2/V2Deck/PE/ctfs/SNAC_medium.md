## Address Claim

You are reviewing firewall logs after a helpdesk ticket comes in - multiple users report that their credentials stopped working after connecting to the internal HR portal.

You pull the firewall logs and find this:

```
[08:42:11] SRC=10.0.3.17  DST=10.0.3.90  PROTO=TCP  DPT=443  ACTION=ALLOW
[08:42:13] SRC=10.0.3.17  DST=10.0.3.90  PROTO=TCP  DPT=443  ACTION=ALLOW
[08:42:15] SRC=10.0.3.44  DST=10.0.3.90  PROTO=TCP  DPT=443  ACTION=ALLOW
[08:42:18] SRC=10.0.3.91  DST=10.0.3.90  PROTO=TCP  DPT=443  ACTION=ALLOW
```

You then check the asset inventory:
- `10.0.3.90` - listed as `hr-portal.internal`, decommissioned 45 days ago, IP not yet reassigned in DHCP
- `10.0.3.91` - no entry in the inventory at all

You run Eavesarp and find that `10.0.3.91` is actively responding to ARP requests meant for `10.0.3.90`.
