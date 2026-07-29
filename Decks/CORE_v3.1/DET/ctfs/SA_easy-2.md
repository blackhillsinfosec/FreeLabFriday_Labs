![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 – Suspicious Process Discovery

During routine monitoring, you run a process listing and find:

```
root   1842  0.0  /usr/sbin/nginx
www-data 2910  0.3  /tmp/.update/checker
www-data 2915  0.2  /tmp/.update/checker
```

You check the system and confirm that nothing in `/tmp` should run as a persistent service.

---

## Question

What is the best initial conclusion?

---

## Flags (Choose One)

- **A)** A temporary system update process
- **B)** Likely malicious process running from a suspicious location
- **C)** Normal web server worker process
- **D)** A harmless developer test script

---

Correct Flag: **B**

---

# Finished?

[Next Question](SA_medium.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Server_Analysis.md)
