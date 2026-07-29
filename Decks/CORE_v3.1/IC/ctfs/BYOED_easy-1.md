![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Suspicious BYOD Connection

A firewall alert shows a personal laptop connecting to the company VPN for the first time.

Minutes later, the device starts making connections to an external IP address every 60 seconds.

Firewall logs show:

```
Source: 10.8.14.23  
Destination: 185.203.119.44  
Protocol: HTTPS  
Interval: 60 seconds (consistent)
```

No employee applications are known to contact this IP.

---

## Question

What is the most likely explanation?

---

## Flags (Choose One)

- **A)** Normal software update traffic
- **B)** DNS caching behavior
- **C)** Video streaming activity
- **D)** Command-and-control communication from malware

---

Correct Flag: **D**

---

# Finished?

[Next Question](BYOED_easy-2.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/Bring_Your_Own_Exploited_Device.md)
