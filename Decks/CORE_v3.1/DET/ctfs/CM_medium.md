## Containment Decision

You are the lead responder on an active incident. An attacker has been confirmed inside the network for approximately 4 hours. So far you know:

- The initial access point was a phishing email opened on `WKSTN-14`
- The attacker has since moved laterally to `SRV-PROD-02`, a production web server
- `SRV-PROD-02` is currently serving live traffic - taking it offline will cause visible downtime for customers
- There is no backup system ready to replace it immediately
- The attacker appears to still be active on `SRV-PROD-02` based on live connection logs

Management is asking you to make a containment recommendation **right now**.
