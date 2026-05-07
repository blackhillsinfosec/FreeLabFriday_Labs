![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Containment Decision

You are the lead responder on an active incident. An attacker has been confirmed inside the network for approximately 4 hours. So far you know:

- The initial access point was a phishing email opened on `WKSTN-14`
- The attacker has since moved laterally to `SRV-PROD-02`, a production web server
- `SRV-PROD-02` is currently serving live traffic - taking it offline will cause visible downtime for customers
- There is no backup system ready to replace it immediately
- The attacker appears to still be active on `SRV-PROD-02` based on live connection logs

Management is asking you to make a containment recommendation **right now**.

---

## Question

Which containment approach best balances stopping the attacker while following sound Incident Response Plan principles?

---

## Flags (Choose One)

- **A)** Do nothing until a backup server is ready so customers are not impacted
- **B)** Wipe `SRV-PROD-02` immediately to remove the attacker, restoring from backup later
- **C)** Isolate `SRV-PROD-02` from the network at the firewall level, accepting the downtime, while preserving the system for forensic analysis
- **D)** Only isolate `WKSTN-14` since that was the original entry point

---

Correct Flag: **C**

---

# Finished?
[Next Question](CM_hard.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Crisis_Management.md)
