![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 – Suspicious Connection Hunt

You are reviewing basic network flow logs from a small office network.

One internal workstation suddenly starts making repeated connections every 60 seconds to an external IP that no other machine contacts.

```
src_ip: 10.10.15.23
dst_ip: 185.199.110.5
dst_port: 443
interval: exactly every 60s
bytes_out: very small, consistent
```

The traffic is encrypted and the destination domain is newly registered.

---

## Question

What is the MOST likely explanation for this behavior?

---

## Flags (Choose One)

- **A)** Normal software update traffic
- **B)** Command-and-control beaconing
- **C)** User browsing activity
- **D)** Internal network scanning

---

Correct Flag: **B**

---

# Finished?

[Next Question](NTH_easy-2.md)

[Back to Card's Main Page](/Cards/DET/Network_Threat_Hunting.md)
