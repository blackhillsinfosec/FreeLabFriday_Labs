![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Spotting the Ghost

Your team decommissioned a server called `filesrv-old.internal` three months ago. The machine was shut down and removed from the rack. During a routine check, a junior analyst notices that `filesrv-old.internal` still resolves to `10.0.1.45` in the internal DNS.

A new workstation was recently assigned `10.0.1.45` via DHCP.

---

## Question

What is the most immediate risk created by this situation?

---

## Flags (Choose One)

- **A)** The DNS server will crash because of the duplicate entry
- **B)** The new workstation could receive traffic intended for the old server
- **C)** DHCP will stop assigning addresses in that range
- **D)** The old server will reboot automatically when traffic reaches it

---

Correct Flag: **B**

---

# Finished?

[Next Question](SNAC_easy-2.md)  
[Back to Card's Main Page](../SNAC_Attack.md)
