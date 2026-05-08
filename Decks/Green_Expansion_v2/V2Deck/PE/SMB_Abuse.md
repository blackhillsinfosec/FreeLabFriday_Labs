<img width="300" height="414" alt="image (12)" src="https://github.com/user-attachments/assets/2a71e507-9171-42f4-9458-875844f2c97a" />



# Server Message Block (SMB) Abuse

**Server Message Block (SMB)** is a network protocol used by Windows machines to share files, printers, and other resources across a local network. It is deeply integrated into how Windows environments work, which also makes it a high-value target for attackers.

When SMB is misconfigured, unpatched, or simply trusted too much within a network, attackers can abuse it to move laterally, steal credentials, and take control of machines - without ever touching the internet.

---

## How SMB Gets Abused

SMB abuse usually does not require a direct vulnerability in the protocol itself. More often, attackers take advantage of how SMB is designed to work:

- SMB relies on authentication handshakes (NTLM) that can be intercepted and relayed
- Windows machines automatically try to authenticate to SMB shares they are pointed to
- Internal networks often trust SMB traffic by default, so it blends in
- Many environments still run outdated SMB versions (SMBv1) that have known critical flaws

The two most common techniques are **credential capture** and **NTLM relay attacks**.

In a credential capture attack, the attacker poisons name resolution on the network (using tools like Responder or Inveigh) to trick machines into sending their authentication hashes to the attacker instead of the real server.

In an NTLM relay attack, instead of cracking those hashes, the attacker forwards them in real time to another machine - effectively logging in as the victim without ever knowing their password.

---

## What the Attack Path Usually Looks Like

A typical SMB abuse chain goes like this:

1. Attacker gets a foothold on the internal network (or is already inside)
2. Runs a poisoning tool to intercept authentication attempts
3. Captures NTLMv2 hashes from machines reaching out for shares or printers
4. Either cracks the hashes offline, or relays them directly to another host
5. Gains access to additional machines, potentially with admin rights
6. Uses that access to dump credentials, read sensitive shares, or deploy payloads

The scary part is that steps 2 through 5 can happen in minutes, and they use legitimate Windows behavior to do it.

---

## Why It Is Dangerous in Real Environments

SMB abuse is particularly effective in Active Directory environments because:

- A single captured hash from a privileged account can unlock many machines
- Name resolution poisoning (LLMNR/NBT-NS) works by default on most Windows networks
- NTLM relay can be chained to reach domain controllers in some configurations
- Most of this traffic looks normal to firewalls and even some SIEMs

This is one of the most common techniques used in real-world intrusions and penetration tests alike.

---

## How It Gets Detected

Defenders look for SMB abuse through:

- SIEM alerts on unusual authentication patterns or repeated failures
- Log analysis for unexpected SMB connections between workstations
- Endpoint protection catching tools like Responder or NetExec
- Network monitoring for LLMNR and NBT-NS poisoning traffic

Detection is possible, but it requires proper logging and tuning - environments that do not log SMB authentication events are essentially blind to this.

---

## CTF Challenges

You will solve four challenges related to SMB abuse:

- [Easy 1 - Captured Hash](ctfs/SMB_easy-1.md)
- [Easy 2 - Poisoned Network](ctfs/SMB_easy-2.md)
- [Medium - Relay Attack](ctfs/SMB_medium.md)
- [Hard - Full Domain Compromise](ctfs/SMB_hard.md)

---

## Labs

Hands-on practice with the tools:

- [NTLMRelayX Lab](labs/ntlmrelayx.md)
- [NetExec Lab](labs/netexec.md)
- [Responder Lab](labs/responder.md)
- [Inveigh Lab](labs/inveigh.md)

---

SMB abuse works because it exploits trust - trust between machines, trust in name resolution, and trust in authentication protocols that were not designed with modern threats in mind. Understanding how these attacks work is essential for anyone defending a Windows environment.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/Green_Expansion_v2/V2Deck/PE/Internal_Spearphishing.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
