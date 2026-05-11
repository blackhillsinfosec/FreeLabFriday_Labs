![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Log Analysis: Something Phoned Home

You are reviewing DNS query logs from a workstation that recently ran an enterprise software update. The logs show normal traffic - except for one recurring entry:

```
Timestamp       Source IP       Query                                   Response
2024-03-01 03:12:44   192.168.1.55    avsvmcloud.com                  34.219.93.73
2024-03-01 03:27:11   192.168.1.55    avsvmcloud.com                  34.219.93.73
2024-03-01 03:42:03   192.168.1.55    avsvmcloud.com                  34.219.93.73
```

The queries happen every 15 minutes, starting at 3 AM, and were not present before the update.

---

## Question

What does this DNS behavior most likely indicate?

---

## Flags (Choose One)

- **A)** The workstation is checking for new software updates on a schedule
- **B)** A developer left in debug telemetry that activates at night
- **C)** The installed software contains a backdoor beaconing to a command-and-control server
- **D)** The DNS server is misconfigured and returning cached results incorrectly

---

Correct Flag: **C**

---

# Finished?

[Next Challenge](SCA_medium.md)
[Back to Main Page](../Supply_Chain_Attack.md)
