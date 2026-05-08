<img width="300" height="414" alt="image (14)" src="https://github.com/user-attachments/assets/5989539e-a190-4506-ae7d-251d25f304e6" />


# Supply Chain Attack

A supply chain attack happens when an attacker does not target your systems directly - they go after the software or tools you already trust. Instead of breaking down your front door, they sneak in through a delivery you were expecting.

The card describes it well: malware gets inserted into the update process of an enterprise management tool. You run the update, you install the malware. You never knew anything was wrong.

---

## How It Works

Most organizations rely on third-party software - monitoring agents, IT management platforms, build tools, you name it. Attackers know this, so they compromise the vendor's infrastructure instead of attacking each target individually.

The general flow looks like this:

- Attacker compromises a software vendor or their build/update pipeline
- Malicious code gets embedded into a legitimate software update
- The update gets signed and distributed normally
- Victims install it, trusting the vendor's signature
- Attacker now has access to every organization that ran the update

The scary part is that everything looks legitimate. The file is signed. The update came from the right server. Your antivirus may not flag it at all.

---

## Real-World Context - SUNBURST

SUNBURST is one of the most well-known supply chain attacks in history. It was embedded into SolarWinds Orion, an IT monitoring platform used by thousands of organizations including U.S. government agencies.

Once installed, SUNBURST would lie dormant for weeks before reaching out to attacker-controlled infrastructure. It was designed to blend in with normal Orion traffic to avoid detection.

SUPERNOVA was a separate piece of malware also found during the same investigation - a backdoor disguised as a legitimate .NET handler inside the Orion platform.

---

## Why This Is Hard to Defend Against

Unlike most attacks, supply chain compromises abuse trust that is supposed to exist. You are not being tricked into downloading something shady - you are installing a routine update from a vendor you pay for.

This makes traditional defenses less effective:

- The update is signed by the real vendor
- The file hashes may be "correct" for the compromised version
- Traffic looks like normal software communication
- Users and admins have no reason to be suspicious

Detection usually relies on behavioral analysis - watching what the software actually does at runtime, rather than what it claims to be.

---

## How These Attacks Get Detected

Given how stealthy supply chain attacks are, detection focuses on behavior rather than signatures:

- Endpoint Security Protection Analysis - looking for unusual process behavior from trusted software
- Endpoint Analysis - examining what files, registry keys, and network connections a tool is creating
- Network Threat Hunting - searching for anomalous outbound connections, especially to unknown external hosts

In the case of SUNBURST, it was eventually detected through DNS traffic analysis by a third-party security firm - months after the initial compromise.

---

## CTF Challenges

Four challenges to test your understanding:

- [Easy 1 - Spotting the Tampered Update](ctfs/SCA_easy-1.md)
- [Easy 2 - Log Analysis: Something Phoned Home](ctfs/SCA_easy-2.md)
- [Medium - Hunting SUNBURST Indicators](ctfs/SCA_medium.md)
- [Hard - Full Supply Chain Compromise Simulation](ctfs/SCA_hard.md)

---

## Labs

Hands-on practice with the detection tools from the card:

- [Endpoint Security Protection Analysis Lab](labs/endpoint-security-protection-analysis.md)
- [Endpoint Analysis Lab](labs/endpoint-analysis.md)
- [Network Threat Hunting Lab](labs/network-threat-hunting.md)
- [SUNBURST & SUPERNOVA IOC Lab](labs/sunburst-supernova.md)

---

Supply chain attacks are a reminder that your security is only as strong as the weakest link in your software supply chain. Understanding how they work - and what to look for - is one of the more important skills in modern threat detection.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/Green_Expansion_v2/V2Deck/IC/Physical_Access.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/Green_Expansion_v2/V2Deck/IC/Exploitation_Of_Missing_HSTS.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
