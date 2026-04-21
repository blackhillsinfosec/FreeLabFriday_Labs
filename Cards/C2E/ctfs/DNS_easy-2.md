![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Spotting Tunneled Traffic

You are reviewing firewall logs after an alert fires on an internal host.

You notice the following pattern over a 30-minute window:

```
10:02:14  DNS query  ->  c2.exfil-test.net        (subdomain length: 48 chars)
10:02:44  DNS query  ->  c2.exfil-test.net        (subdomain length: 52 chars)
10:03:14  DNS query  ->  c2.exfil-test.net        (subdomain length: 50 chars)
10:03:44  DNS query  ->  c2.exfil-test.net        (subdomain length: 47 chars)
```

Queries are being made every **30 seconds**, even though no user is actively using the machine.

---

## Question

What behavior best explains this DNS traffic pattern?

---

## Flags (Choose One)

- **A)** An implant beaconing to a C2 server on a regular interval
- **B)** A misconfigured application retrying a failed DNS lookup
- **C)** Normal background traffic from a browser keeping tabs alive
- **D)** A Windows update service checking for new packages

---

Correct Flag: **A**

---

# Finished?
[Next Question](DNS_medium.md)  
[Back to Card's Main Page](/Cards/C2E/Domain_Name_System_As_C2.md)
