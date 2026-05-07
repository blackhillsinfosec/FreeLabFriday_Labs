<img width="300" height="414" alt="BNB_CARDS_v3_28" src="https://github.com/user-attachments/assets/6b6b647d-5348-421a-a6e4-cd67e23ed87e" />


# HTTPS As Exfil

Once an attacker is inside a system, they need to get the data out. The obvious problem: the network is being watched. Firewalls block weird ports. Security tools flag unusual traffic. So attackers don't use weird ports. They use port 443 - the same one your browser uses right now.

This technique is called **data exfiltration over HTTPS**. The stolen data rides inside normal-looking encrypted web traffic, and most defenses don't even blink.

---

## Why HTTPS Makes a Good Cover

HTTPS was built for privacy. The encryption that protects your bank login also protects an attacker sending files out of a network. From the outside, a legitimate HTTPS request and a malicious one look nearly identical.

Defenders can't just block HTTPS - that would break the internet. And because the traffic is encrypted, they can't read the payload to check what's inside. The attacker knows this, and uses it on purpose.

---

## How It Actually Works

The general flow looks like this:

1. The attacker compromises a machine inside the network
2. They collect whatever data they want - credentials, files, configs
3. They encode or compress it (sometimes encrypt it on top of HTTPS)
4. They send it out in small chunks to a server they control, using standard HTTPS requests
5. The server reassembles the data on the other end

The destination is usually a domain the attacker registered themselves, sometimes designed to look legitimate. The requests can look like normal API calls, telemetry, or even browser traffic.

---

## The Tools Attackers Use

Three common frameworks used for HTTPS-based exfiltration are:

**Sliver** - An open-source C2 (command and control) framework built with HTTPS implants in mind. It supports multiplayer operations and is designed to blend into normal web traffic.

**Havok** - A newer C2 framework with flexible HTTPS channeling. It gives operators fine control over how traffic is shaped and when it's sent, making it harder to detect by timing analysis.

**Mythic** - A modular C2 platform where agents and communication profiles are separate. HTTPS is one of several supported channels, and profiles can be customized to mimic real services.

These are red team tools used in legitimate security testing, but they're also the same tools that show up in real-world intrusions.

---

## How Defenders Catch It

Since you can't read encrypted traffic, detection focuses on patterns rather than content:

- **Network Threat Hunting** - Analysts actively look for hosts that are beaconing (making regular, timed outbound connections), which is a classic C2 sign
- **Firewall Log Analysis** - Volume anomalies, connections to new or rare external IPs, and unusual connection timing can stand out even without seeing the payload
- **SIEM Log Analysis** - Correlating endpoint events with network activity can surface the full picture - when a file was accessed, when a process ran, when data left
- **Endpoint Security Protection Analysis** - On the machine itself, the process making the HTTPS calls might be something that has no business touching the internet

Detection is hard. That's the whole point of this technique. But it's not impossible - it just requires looking at the right things.

---

## CTF Challenges

Test what you know with four scenarios built around HTTPS exfiltration:

- [Easy 1 – Spot the Beacon](ctfs/HE_easy-1.md)
- [Easy 2 – Log Pattern Analysis](ctfs/HE_easy-2.md)
- [Medium – C2 Traffic Investigation](ctfs/HE_medium.md)
- [Hard – Full Exfil Hunt](ctfs/HE_hard.md)

---

## Labs

Hands-on practice with each tool from the card:

- [Sliver Lab](labs/sliver.md)
- [Havok Lab](labs/havok.md)
- [Mythic Lab](labs/mythic.md)

---

HTTPS exfiltration is effective precisely because it hides in plain sight. Understanding how it works - and what traces it leaves behind - is one of the more practical skills you can build in network defense.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Cards/C2E/Domain_Name_System_As_C2.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Cards/C2E/HTTP_As_Exfil.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
