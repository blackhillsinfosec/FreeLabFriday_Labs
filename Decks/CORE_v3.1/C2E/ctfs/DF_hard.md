![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full C2 Takedown

Your team has been tracking a suspected intrusion for 48 hours. Here is what you have confirmed so far:

- A Sliver implant is running on `finance-ws-03`, disguised as a signed Windows service binary
- It is beaconing via domain fronting through Cloudflare, using `cdn.shopify.com` as the SNI
- The real Host header resolves to `update-check.io`, a domain registered 11 days ago
- Beacon interval is **randomized between 20 and 60 seconds** to avoid pattern detection
- The implant survives reboot via a scheduled task
- No lateral movement has been confirmed yet, but the machine has access to an internal file share

You need to contain the threat, preserve evidence for investigation, and disrupt the C2 infrastructure.

---

## Question

Which sequence of actions is the most operationally correct response?

---

## Flags (Choose One)

- **A)** Isolate the host from the network, capture a full memory dump, then report the fronted domain and Host header details to Cloudflare's abuse team
- **B)** Delete the Sliver binary from disk and remove the scheduled task, then monitor for reinfection
- **C)** Block all outbound port 443 traffic at the perimeter firewall until the investigation is complete
- **D)** Reimage the machine immediately to prevent lateral movement before it starts

---

Correct Flag: **A**

---

# Finished?

[Back to Card's Main Page](../Domain_Fronting_As_C2.md)
