<img width="300" height="414" alt="BNB_CARDS_v3_27" src="https://github.com/user-attachments/assets/07f5b65e-df39-461d-ae73-5c9a081e41a3" />

# HTTP As Exfil


HTTP exfiltration happens when an attacker uses normal web traffic to move stolen data out of a compromised system.  
Instead of using obvious malicious channels, they blend into regular web activity so the traffic looks normal to defenders.

Because HTTP and HTTPS are allowed almost everywhere, this is one of the most common ways attackers quietly remove data after gaining access.

---

## What a Compromised Web Server Has to Do With It

A compromised web server is often the starting point. Once attackers gain control of it, they can:

- collect files, credentials, or database dumps
- stage stolen data on the server
- send that data out using normal web requests
- hide activity inside expected web traffic

The server becomes both an entry point and an exit point.

---

## How Attackers Get to This Stage

Most paths look similar:

- find a vulnerable or exposed web service
- exploit a weakness (outdated software, bad config, weak credentials)
- gain command execution or shell access
- establish persistence
- begin data collection and exfiltration

At this point, attackers try to stay quiet. Large data dumps or strange protocols get noticed — HTTP usually does not.

---

## How HTTP Exfiltration Works

Attackers abuse normal behavior instead of creating new channels. Common patterns include:

- sending data in HTTP POST requests
- hiding data inside headers or parameters
- splitting data into small chunks over time
- using encrypted HTTPS traffic to avoid inspection

From the outside, this can look like ordinary web browsing or API traffic.

---

## Why Detection Is Difficult

HTTP traffic is everywhere, so defenders cannot block it outright. Detection focuses on behavior instead of protocol.

Typical signs include:

- unusual outbound connections from servers
- abnormal request sizes or frequency
- repeated calls to unknown domains
- data transfers that don’t match normal server activity

Security teams usually rely on multiple sources to spot this:

- network threat hunting
- firewall log analysis
- SIEM log correlation
- endpoint security telemetry

---

## CTF Challenges

You will complete four challenges focused on HTTP-based exfiltration scenarios:

- [Easy 1 – Suspicious Outbound Request](ctfs/http-exfil_easy-1.md)  
- [Easy 2 – Log-Based Detection](ctfs/http-exfil_easy-2.md)  
- [Medium – Hidden Data in Traffic](ctfs/http-exfil_medium.md)  
- [Hard – Full Exfiltration Investigation](ctfs/http-exfil_hard.md)

---

## Labs

Hands-on labs using tools commonly seen in red team operations and detection workflows:

- [Sliver Lab](labs/sliver.md)  
- [Havoc Lab](labs/havoc.md)  
- [Mythic Lab](labs/mythic.md)  

---

HTTP exfiltration is not flashy. That is exactly why it works.  
Learning to recognize normal-looking traffic that isn’t normal is a core skill for anyone working in security.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Cards/C2E/HTTPS_As_Exfil.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
