![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Supply Chain Compromise Simulation

You are the lead incident responder. A Fortune 500 company has called you in after their SOC noticed unusual activity. You need to reconstruct the full attack chain and identify the correct containment priority.

Here is everything collected so far:

---

### Timeline of Events

```
Day 0   - SolarWinds Orion 2020.2.1 update installed across 300 endpoints
Day 14  - Orion process begins resolving subdomains of avsvmcloud.com (HTTPS, port 443)
Day 17  - A single workstation (HOST-22) receives a unique subdomain response resolving
          to attacker infrastructure instead of the CNAME sinkhole
Day 17  - HOST-22: SolarWinds process writes a new file to a temp directory
Day 18  - HOST-22: Lateral movement detected - WMIC used to query domain controllers
Day 19  - DC-01: New admin account "svc_helpdesk2" created outside normal provisioning
Day 20  - DC-01: Large LDAP query dumps entire Active Directory structure
Day 21  - Exfiltration - 4.3 GB outbound to 185.225.69[.]xx over HTTPS
```

---

### Current State

- 300 endpoints have the compromised Orion binary
- Only HOST-22 received active C2 tasking (the rest got sinkholed)
- "svc_helpdesk2" account exists on DC-01 with Domain Admin privileges
- Exfiltration already occurred

---

## Question

You can only take ONE immediate action before the attacker is likely to detect your response and go dark. What is it?

---

## Flags (Choose One)

- **A)** Immediately reimage all 300 endpoints running the compromised Orion binary
- **B)** Block outbound traffic to avsvmcloud.com at the perimeter firewall
- **C)** Disable the "svc_helpdesk2" account and revoke its active sessions on DC-01
- **D)** Isolate HOST-22 from the network and preserve its memory for forensic analysis

---

Correct Flag: **C**

---

# Finished?

[Back to Main Page](../Supply_Chain_Attack.md)
