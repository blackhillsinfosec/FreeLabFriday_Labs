![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Partner Pivot Scenario

A trusted partner has VPN access to a restricted network segment.

You notice the following timeline:

```
09:02  partner_vpn_connected
09:06  internal_scan_detected 10.0.12.0/24
09:09  SMB_login_attempts multiple_hosts
09:11  data_transfer outbound
```

The partner normally accesses only one application server.

---

## Question

Which statement best describes what is happening?

---

## Flags (Choose One)

- **A)** Normal partner troubleshooting activity
- **B)** Malware scanning from inside the network
- **C)** A potential pivot using trusted access
- **D)** Scheduled vulnerability scanning

---

Correct Flag: **C**

---

# Finished?

[Next Question](TR_hard.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/Trusted_Relationship.md)
