![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - BYOD Pivot Into Internal Network

An infected personal laptop connects to the corporate VPN.

Timeline:

1. Device authenticates successfully.
2. Within 5 minutes, authentication attempts appear across multiple internal servers.
3. Shortly after, a domain admin account logs in from the same VPN IP.
4. Logs show credential dumping activity on the device before the VPN session.

---

## Question

What most likely allowed the attacker to move from the personal device into the internal network?

---

## Flags (Choose One)

- **A)** A firewall misconfiguration allowed all traffic
- **B)** The attacker exploited an unpatched web server
- **C)** Stolen credentials collected from the compromised device
- **D)** A denial-of-service attack distracted defenders

---

Correct Flag: **C**

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/Bring_Your_Own_Exploited_Device.md)
