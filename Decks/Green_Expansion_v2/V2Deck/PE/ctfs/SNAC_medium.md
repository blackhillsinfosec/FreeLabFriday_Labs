![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Address Claim

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

---

## Question

Based on this evidence, what most likely happened?

---

## Flags (Choose One)

- **A)** A misconfigured switch is duplicating packets to `10.0.3.91`
- **B)** The HR portal was moved to `10.0.3.91` and DNS was not updated
- **C)** An attacker registered `10.0.3.91` and is intercepting traffic meant for the old HR portal
- **D)** The firewall is blocking traffic to `10.0.3.90` and rerouting it automatically

---

Correct Flag: **C**

---

# Finished?

[Next Question](SNAC_hard.md)  
[Back to Card's Main Page](../SNAC_Attack.md)
