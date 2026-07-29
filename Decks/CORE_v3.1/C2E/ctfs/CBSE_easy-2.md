![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - API Key in the Logs

You are analyzing firewall logs after a security alert. You find a series of outbound HTTPS requests from a workstation that belongs to an intern who left the company two weeks ago.

```
[14:05:11] SRC: 192.168.1.74  DST: api.dropboxapi.com:443  BYTES_OUT: 512
[14:05:44] SRC: 192.168.1.74  DST: api.dropboxapi.com:443  BYTES_OUT: 512
[14:06:17] SRC: 192.168.1.74  DST: api.dropboxapi.com:443  BYTES_OUT: 512
[14:06:50] SRC: 192.168.1.74  DST: api.dropboxapi.com:443  BYTES_OUT: 512
```

The requests repeat every 33 seconds, consistently, for 4 hours straight. The total data sent is roughly 140 MB. The machine has no Dropbox client installed.

---

## Question

What is the most suspicious detail in these logs?

---

## Flags (Choose One)

- **A)** The destination is Dropbox, which is a known malicious domain
- **B)** The traffic is encrypted with HTTPS, which attackers cannot use
- **C)** No Dropbox client is installed, but something is calling the Dropbox API in a regular automated pattern
- **D)** The intern's machine being active is completely normal after offboarding

---

Correct Flag: **C**

---

# Finished?
[Next Question](CBSE_medium.md)  
[Back to Card's Main Page](../Cloud_Based_Services_As_Exfil.md)
