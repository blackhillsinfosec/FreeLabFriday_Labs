## Identifying Poisoning Traffic

You are a defender reviewing a Wireshark capture from your internal network. You filter for LLMNR traffic and find the following exchange:

```
No.   Time     Source          Destination      Protocol  Info
----  -------  --------------  ---------------  --------  ------------------------------------
112   0.000s   192.168.1.45    224.0.0.252      LLMNR     Standard query A FILESERV01
113   0.003s   192.168.1.20    192.168.1.45     LLMNR     Standard query response A 192.168.1.20
114   0.004s   192.168.1.80    192.168.1.45     LLMNR     Standard query response A 192.168.1.80
```

You check your asset inventory. `192.168.1.20` is a known file server. `192.168.1.80` is a workstation — it should never be responding to name resolution queries.
