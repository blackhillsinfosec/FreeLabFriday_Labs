![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Identifying Poisoning Traffic

You are a defender reviewing a Wireshark capture from your internal network. You filter for LLMNR traffic and find the following exchange:

```
No.   Time     Source          Destination      Protocol  Info
----  -------  --------------  ---------------  --------  ------------------------------------
112   0.000s   192.168.1.45    224.0.0.252      LLMNR     Standard query A FILESERV01
113   0.003s   192.168.1.20    192.168.1.45     LLMNR     Standard query response A 192.168.1.20
114   0.004s   192.168.1.80    192.168.1.45     LLMNR     Standard query response A 192.168.1.80
```

You check your asset inventory. `192.168.1.20` is a known file server. `192.168.1.80` is a workstation — it should never be responding to name resolution queries.

---

## Question

What does this capture most likely indicate?

---

## Flags (Choose One)

- **A)** The workstation at 192.168.1.80 is likely running a poisoning tool like Responder
- **B)** The file server at 192.168.1.20 is misconfigured and broadcasting incorrect addresses
- **C)** The query from 192.168.1.45 failed because two responses caused a conflict
- **D)** This is normal behavior - multiple machines can respond to LLMNR queries

---

Correct Flag: **A**

---

# Finished?
[Next Question](BMPP_medium.md)  
[Back to Card's Main Page](../Broadcast-Multicast_Protocol_Poisoning.md)
