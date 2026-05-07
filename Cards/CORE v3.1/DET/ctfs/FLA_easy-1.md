![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 – Suspicious Connection Hunt

You are reviewing firewall logs after users reported slow network performance.

You notice the same external IP contacting many internal hosts within a short period:

```
2024-06-10 10:14:02 ALLOW SRC=203.0.113.45 DST=10.0.0.12 DPT=22
2024-06-10 10:14:05 ALLOW SRC=203.0.113.45 DST=10.0.0.18 DPT=22
2024-06-10 10:14:08 ALLOW SRC=203.0.113.45 DST=10.0.0.23 DPT=22
2024-06-10 10:14:11 ALLOW SRC=203.0.113.45 DST=10.0.0.31 DPT=22
```

---

## Question

What does this traffic most likely indicate?

---

## Flags (Choose One)

- **A)** Regular backup traffic  
- **B)** Port scanning or reconnaissance  
- **C)** Internal DNS synchronization  
- **D)** A software update service

---

Correct Flag: **B**

---

# Finished?

[Next Question](FLA_easy-2.md)

[Back to Card's Main Page](/Cards/DET/Firewall_Log_Analysis.md)
