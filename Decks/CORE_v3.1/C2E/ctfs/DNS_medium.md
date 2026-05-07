![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - C2 Beacon Identification

During a threat hunt, your SIEM flags a host for unusual DNS behavior. You pull the following log excerpt:

```
Host: DESKTOP-4F9KL
Timeframe: 08:00 – 10:00

08:00:01  TXT query  ->  cmd.beacon-relay.io   Response: "whoami"
08:00:03  A   query  ->  cm9vdA==.beacon-relay.io
08:15:01  TXT query  ->  cmd.beacon-relay.io   Response: "ipconfig /all"
08:15:04  A   query  ->  MTkyLjE2OC4xLjU=.beacon-relay.io
08:30:01  TXT query  ->  cmd.beacon-relay.io   Response: "net user"
08:30:05  A   query  ->  QWRtaW5pc3RyYXRvcg==.beacon-relay.io
```

The subdomains in the A queries decode from Base64 to:
- `cm9vdA==` -> `root`
- `MTkyLjE2OC4xLjU=` -> `192.168.1.5`
- `QWRtaW5pc3RyYXRvcg==` -> `Administrator`

---

## Question

Based on this log, what is the attacker most likely doing?

---

## Flags (Choose One)

- **A)** Scanning the network for open ports using DNS to avoid detection
- **B)** Poisoning the DNS cache to redirect traffic to a malicious server
- **C)** Running a brute force attack against the domain controller
- **D)** Sending commands to an implant and receiving the output back through DNS queries

---

Correct Flag: **D**

---

# Finished?
[Next Question](DNS_hard.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/C2E/Domain_Name_System_As_C2.md)
