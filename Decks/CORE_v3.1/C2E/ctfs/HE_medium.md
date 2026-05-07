![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - C2 Traffic Investigation

A SIEM alert fired on a developer workstation. You pull the relevant logs and find the following sequence of events:

```
[09:14:22]  svchost.exe        spawned child process: powershell.exe
[09:14:23]  powershell.exe     read file: C:\Users\dev01\Documents\credentials.txt
[09:14:24]  powershell.exe     read file: C:\Users\dev01\AppData\Roaming\ssh\known_hosts
[09:14:25]  powershell.exe     made HTTPS connection to: update-cdn.delivery-net.com:443
[09:14:26]  powershell.exe     POST /telemetry/report  body size: 14.7 KB
[09:14:27]  powershell.exe     received response: 200 OK
[09:14:27]  powershell.exe     exited
```

A quick WHOIS on `update-cdn.delivery-net.com` shows the domain was registered 4 days ago.

---

## Question

You need to write a one-line summary for your incident report. Based on the evidence above, which summary is most accurate?

---

## Flags (Choose One)

- **A)** A scheduled telemetry task ran and reported system diagnostics to a Microsoft CDN
- **B)** powershell.exe crashed after attempting to access protected files
- **C)** An analyst manually ran a script to export SSH configuration for review
- **D)** A malicious process read sensitive files and exfiltrated them via HTTPS to a recently registered domain

---

Correct Flag: **D**

---

# Finished?
[Next Question](HE_hard.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/C2E/HTTPS_As_Exfil.md)
