![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Spot the Front

A security analyst is reviewing a packet capture from a workstation that flagged a behavioral alert. They inspect an outbound HTTPS connection and notice the following:

```
TLS SNI (visible during handshake):  cdn.legit-software.com
HTTP Host header (inside encrypted request):  updates.totally-not-c2.net
Destination IP:  104.21.x.x  (Cloudflare range)
```

---

## Question

What does the mismatch between the SNI and the Host header most likely indicate?

---

## Flags (Choose One)

- **A)** A DNS misconfiguration on the workstation
- **B)** Normal behavior - CDNs always rewrite headers this way
- **C)** The connection was intercepted by a proxy
- **D)** Domain fronting is being used to hide the real C2 destination

---

Correct Flag: **D**

---

## Explanation

The SNI field is what the network sees during the TLS handshake - it points to a legitimate CDN domain. But once the connection is encrypted, the Host header inside tells the CDN where to *actually* forward the request. When these two values differ and the real destination is attacker-controlled, that is domain fronting. The CDN becomes an unwitting relay.

---

# Finished?

[Next Question](DF_easy-2.md)  
[Back to Card's Main Page](../Domain_Fronting_As_C2.md)
