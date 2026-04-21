![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Spot the Beacon

A security analyst is reviewing outbound HTTPS traffic from a workstation that was flagged by the firewall.

The logs show the following connections over a 2-hour window:

```
10:00:03  192.168.1.45 -> 185.220.101.12:443  POST /api/v1/sync  200 OK
10:05:03  192.168.1.45 -> 185.220.101.12:443  POST /api/v1/sync  200 OK
10:10:04  192.168.1.45 -> 185.220.101.12:443  POST /api/v1/sync  200 OK
10:15:03  192.168.1.45 -> 185.220.101.12:443  POST /api/v1/sync  200 OK
10:20:03  192.168.1.45 -> 185.220.101.12:443  POST /api/v1/sync  200 OK
```

The destination IP has no known reputation and is not associated with any business software installed on the machine.

---

## Question

What behavior in this traffic is the strongest indicator of C2 activity?

---

## Flags (Choose One)

- **A)** The traffic uses HTTPS
- **B)** The connections happen at almost identical intervals every 5 minutes
- **C)** The requests return a 200 OK status
- **D)** The endpoint path contains the word "sync"

---

Correct Flag: **B**

---

# Finished?
[Next Question](HE_easy-2.md)  
[Back to Card's Main Page](/Cards/C2E/HTTPS_As_Exfil.md)
