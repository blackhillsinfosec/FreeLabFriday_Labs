![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Log Analysis: Outbound BITS Traffic

You are reviewing firewall logs from a company workstation. You notice the following outbound connection:

```
[2024-03-14 02:17:43] OUTBOUND ALLOW
  Process : svchost.exe (BITS)
  Source  : 192.168.1.105:51200
  Dest    : 91.108.56.34:80
  Data    : 4.2 MB
  URL     : http://91.108.56.34/receive/hr_records.zip
```

The IP `91.108.56.34` does not belong to any known Microsoft or vendor update server.

---

## Question

What should this log entry tell you?

---

## Flags (Choose One)

- **A)** BITS was used to exfiltrate data to an unknown external server
- **B)** Windows Update ran successfully overnight
- **C)** A user manually downloaded a zip file from the internet
- **D)** The firewall blocked a suspicious connection attempt

---

Correct Flag: **A**

---

# Finished?
[Next Question](BITS_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/C2E/Backround_Intelligent_Transfer_Service_As_Exfil.md)
