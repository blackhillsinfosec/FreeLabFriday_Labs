![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Dead Record Recon

You are doing a security audit and run a DNS zone dump on your internal domain. You find the following records still present:

```
vpn-old.corp.internal       A     192.168.10.22
backup-srv.corp.internal    A     192.168.10.55
test-db.corp.internal       A     192.168.10.81
```

After checking the asset inventory, none of these three IPs are assigned to any active system. All three were decommissioned over six months ago.

---

## Question

From an attacker's perspective, what makes these records useful?

---

## Flags (Choose One)

- **A)** They reveal the internal IP range and give the attacker valid hostnames to target or impersonate
- **B)** They allow the attacker to directly access the decommissioned servers
- **C)** They prove the firewall is misconfigured
- **D)** They can be used to crash the DNS server

---

Correct Flag: **A**

---

# Finished?

[Next Question](SNAC_medium.md)  
[Back to Card's Main Page](../SNAC_Attack.md)
