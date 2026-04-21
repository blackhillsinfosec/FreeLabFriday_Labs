![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF – Data Exfiltration Investigation

During a hunt focused on outbound traffic, you observe the following:

```
Host: ENG-SRV-04
Destination: cloud-storage.example
Protocol: HTTPS
Transfer size: ~8 GB
Time: 03:12 AM
History: Host usually sends less than 50 MB/day externally
```

No backup jobs are scheduled at this time, and the destination has never been contacted before.

---

## Question

What is the MOST likely explanation?

---

## Flags (Choose One)

- **A)** Automated patch download
- **B)** Misconfigured antivirus update
- **C)** Normal user behavior
- **D)** Possible data exfiltration over encrypted traffic

---

Correct Flag: **D**

---

# Finished?

[Back to Card's Main Page](/Cards/DET/Network_Threat_Hunting.md)
