![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)
# Easy CTF 2 - Firewall Rule Reconstruction

You are reviewing firewall rules on a compromised Linux host that was isolated at the host level. A colleague ran the following commands during the incident:

```
iptables -I INPUT -j DROP
iptables -I OUTPUT -j DROP
iptables -I INPUT -s 10.0.0.5 -j ACCEPT
iptables -I OUTPUT -d 10.0.0.5 -j ACCEPT
```

`10.0.0.5` is the IP address of your SOC management server.

---

## Question

What does this ruleset achieve?

---

## Flags (Choose One)

- **A)** It blocks all traffic to and from the host, including the SOC management server
- **B)** It allows all internal network traffic and blocks only internet access
- **C)** It blocks all traffic except communication with the SOC management server
- **D)** It logs all inbound and outbound traffic without dropping any of it

---

Correct Flag: **C**

---

# Finished?
[Next Question](ISO_medium.md)
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Isolation.md)
