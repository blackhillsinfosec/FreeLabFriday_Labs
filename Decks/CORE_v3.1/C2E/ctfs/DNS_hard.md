![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full DNS C2 Reconstruction

Your team responds to an incident at a mid-sized company. You have full packet captures from the affected host over a 2-hour window. You identify the following activity:

**Phase 1 – Initial Check-in**
```
DNS TXT query  ->  init.drop-updates.org
Response:        "sleep=30&jitter=5&key=0xDEADBEEF"
```

**Phase 2 – Tasking (repeating every ~30s)**
```
DNS TXT query  ->  task.drop-updates.org
Response:        "Y21kIC9jIHdob2FtaQ=="   (Base64: "cmd /c whoami")
```

**Phase 3 – Exfiltration**
```
A query  ->  5a0b3c.drop-updates.org
A query  ->  1f4e9d.drop-updates.org
A query  ->  8c2a7f.drop-updates.org
```
The subdomains are hex-encoded chunks of a file. Reassembled and decoded, they produce the contents of `C:\Users\jsmith\Documents\credentials.txt`.

**Phase 4 – Persistence**
```
DNS TXT query  ->  task.drop-updates.org
Response:        "cmVnIGFkZCBIS0xNXC4uLg=="  (Base64: "reg add HKLM\...")
```

---

## Question

The attacker used a `jitter` value of 5 in the initial check-in response. What is the main reason attackers add jitter to beacon intervals?

---

## Flags (Choose One)

- **A)** To reduce bandwidth usage and avoid overloading the C2 server
- **B)** To randomize the timing of beacons so they don't appear as a perfectly regular pattern in logs
- **C)** To ensure the implant only runs during business hours to blend in with normal traffic
- **D)** To re-encrypt the DNS payload with a different key on each request

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](/Cards/C2E/Domain_Name_System_As_C2.md)
