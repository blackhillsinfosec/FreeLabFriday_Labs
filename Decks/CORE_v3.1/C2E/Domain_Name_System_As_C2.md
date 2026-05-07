<img width="300" height="414" alt="BNB_CARDS_v3_29" src="https://github.com/user-attachments/assets/b414e450-31bc-47c3-9091-5f3978891ca2" />





# Domain Name System(DNS) As C2

Every device on the internet needs DNS to function. It's the protocol that translates domain names like `google.com` into IP addresses your computer can actually connect to. Because it's so fundamental, most networks allow DNS traffic to pass through firewalls without much scrutiny.

Attackers know this — and they abuse it.

---

## What DNS C2 Actually Means

C2 stands for **Command and Control**. It's the channel an attacker uses to send instructions to a compromised machine and receive data back from it.

When DNS is used as C2, the attacker's malware doesn't open a suspicious connection to some unknown server. Instead, it makes DNS queries — the exact same kind your browser makes hundreds of times a day. The difference is that those queries are carrying hidden data.

A typical DNS C2 exchange looks something like this:

- The malware on the victim's machine encodes stolen data or a status update into a subdomain, like `aGVsbG8=.attacker-domain.com`
- That query travels through the network and reaches the attacker's DNS server
- The attacker's server decodes the data and responds with encoded commands disguised as a normal DNS answer

From the outside, it just looks like DNS traffic. Nothing obviously wrong.

---

## Why It Works So Well

DNS is almost never blocked outright. Blocking it would break the entire network. This means:

- Firewalls let it through by default
- Many organizations don't log DNS queries at all
- Even when they do, the volume is so high that malicious queries blend in
- Encrypted or obfuscated payloads are hard to distinguish from legitimate subdomains

It's one of the more patient and stealthy techniques in an attacker's toolkit. Not every attack uses it — it's usually slower than a direct connection — but it's extremely hard to detect without the right setup.

---

## How Attackers Get to This Point

DNS C2 isn't usually the initial compromise. It comes after. The typical path is:

1. An attacker gains initial access (phishing, exploiting a vulnerability, stolen credentials)
2. They drop a payload or implant on the compromised machine
3. That implant needs to phone home — but direct connections might get blocked
4. DNS tunneling or DNS C2 becomes the fallback channel to keep the operation alive

Tools like **Havok** and **Mythic** are post-exploitation frameworks that support DNS-based communication. They're designed to be used after a machine is already compromised, helping the attacker maintain access and move through the network quietly.

---

## How It Gets Detected

Catching DNS C2 isn't impossible, but it requires actually looking at DNS traffic — something many teams don't do by default.

The main methods are:

- **Network Threat Hunting** — analysts actively search for anomalies in DNS logs, like unusually long subdomains, high query rates to a single domain, or domains with high entropy names
- **Firewall Log Analysis** — comparing DNS traffic patterns over time to spot outliers
- **SIEM Log Analysis** — correlating DNS events with other indicators to build a fuller picture of suspicious activity

A single weird DNS query probably won't trigger anything. Defenders look for patterns — a machine making hundreds of queries to the same domain, subdomains that look like base64, queries at regular intervals even when the user isn't active.

---

## CTF Challenges

Four challenges to test what you've learned:

- [Easy 1 – DNS Query Analysis](ctfs/DNS_easy-1.md)
- [Easy 2 – Spotting Tunneled Traffic](ctfs/DNS_easy-2.md)
- [Medium – C2 Beacon Identification](ctfs/DNS_medium.md)
- [Hard – Full DNS C2 Reconstruction](ctfs/DNS_hard.md)

---

## Labs

Hands-on practice with the tools referenced on the card:

- [Havok Lab](labs/havok.md)
- [Mythic Lab](labs/mythic.md)

---

DNS as C2 is a good example of how attackers use the infrastructure that keeps networks running against the networks themselves. You can't block DNS. You have to learn to read it.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/C2E/Backround_Intelligent_Transfer_Service_As_Exfil.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/C2E/HTTPS_As_Exfil.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
