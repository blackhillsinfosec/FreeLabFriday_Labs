![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full SNAC Chain

You are a SOC analyst. A SIEM alert fires at 03:14 AM flagging unusual authentication volume from the service account `svc-backup@corp.internal`.

You start pulling data across three sources.

---

### SIEM Alert

```
[ALERT] Unusual auth spike - svc-backup@corp.internal
Authenticated successfully to 14 internal hosts between 03:09 and 03:13
Hosts: fin-srv01, fin-srv02, hr-db, payroll-api, ...
Source IP: 10.1.8.33
```

---

### DNS Records (internal zone)

```
backup-agent.corp.internal    A    10.1.8.20   (TTL 86400)
```

Note: `backup-agent.corp.internal` was the hostname of a backup orchestrator that was decommissioned 60 days ago. IP `10.1.8.20` was released and has since been reassigned to a printer.

---

### DHCP Lease Table (current)

```
10.1.8.20   ->  printer-floor2.corp.internal   (leased 30 days ago)
10.1.8.33   ->  NO ENTRY - no current lease recorded
```

---

### Eavesarp Output (run at 03:20 AM)

```
[*] Stale ARP entry detected
    Hostname:  backup-agent.corp.internal
    Stale IP:  10.1.8.20
    Responder: 10.1.8.33
    First seen: 2d 14h ago
    Note: 10.1.8.33 is responding to ARP requests intended for 10.1.8.20
```

---

## Question

Piecing together all four data sources, which of the following best describes the full attack chain?

---

## Flags (Choose One)

- **A)** An attacker at `10.1.8.33` claimed the stale ARP entry for `backup-agent.corp.internal`, intercepted Kerberos tickets from `svc-backup`, and used them to authenticate laterally across the network
- **B)** A misconfigured printer at `10.1.8.20` is broadcasting credentials from the service account, and `10.1.8.33` is a logging server capturing them
- **C)** The DHCP server assigned `10.1.8.33` to a new backup agent that replaced the old one, and the SIEM alert is a false positive from the re-provisioning
- **D)** The attacker compromised the DNS server directly and injected the `backup-agent.corp.internal` record to redirect traffic

---

Correct Flag: **A**

---

# Finished?

[Back to Card's Main Page](../SNAC_Attack.md)
