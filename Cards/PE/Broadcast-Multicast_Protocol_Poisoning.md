<img width="300" height="414" alt="BNB_CARDS_v3_13" src="https://github.com/user-attachments/assets/1ffd6909-d0e1-4bf6-a727-1ca036c52a8a" />



# Broadcast / Multicast Protocol Poisoning

Networks rely on broadcast and multicast protocols to do things like resolve hostnames, find services, and route traffic. The problem is that these protocols were designed for convenience, not security. They trust whoever answers first - and attackers know how to answer first.

---

## What's Actually Happening

When a device on a network doesn't know where to send something, it broadcasts a question to everyone: *"Hey, who has this address?"* Any machine on the same network can answer. There's no verification. No signature. Just whoever responds.

Attackers abuse this by listening for those questions and sending back a fake answer pointing to their own machine. Once traffic is redirected their way, they can read it, modify it, or use it to capture credentials.

The most targeted protocols are:

- **LLMNR** (Link-Local Multicast Name Resolution) – falls back to multicast when DNS fails
- **NBT-NS** (NetBIOS Name Service) – older Windows name resolution
- **mDNS** (Multicast DNS) – used in local networks for zero-config service discovery
- **DHCPv6** – attackers can set themselves up as a rogue DHCPv6 server and redirect IPv6 traffic

---

## How Attackers Pull This Off

The attack is straightforward:

1. A device on the network sends a broadcast asking for a hostname or address it can't resolve
2. The attacker's tool (Responder, Inveigh, etc.) is already listening for exactly these requests
3. The attacker responds first with their own IP
4. The victim's machine connects to the attacker instead of the real destination
5. If authentication is involved (like NTLM), the hash is captured and can be cracked offline or relayed

This is a **man-in-the-middle** setup at the network protocol level. It requires no prior access - just being on the same network segment.

---

## Why This Works So Often

These protocols are enabled by default on most Windows environments. LLMNR and NBT-NS exist precisely as fallbacks when DNS fails, meaning they activate every time there's a typo in a UNC path, a misconfigured share, or a script pointing to a hostname that no longer exists. In practice, those happen constantly.

IPv6 poisoning via DHCPv6 works because Windows prefers IPv6 over IPv4 when available, and most networks don't have a legitimate DHCPv6 server - so a rogue one goes uncontested.

---

## What Defenders Look For

Detection focuses on spotting the anomalies these attacks create:

- **Active Defense and Cyber Deception** – honeypot hostnames that should never be queried; if something responds to them, something is wrong
- **User and Entity Behavior Analytics (UEBA)** – unusual authentication patterns, repeated failed lookups, or odd lateral movement from a machine
- **Firewall Log Analysis** – unexpected multicast/broadcast traffic, new listeners on LLMNR/NBT-NS ports
- **Endpoint Security Protection Analysis** – tools like Responder and Inveigh have recognizable signatures

The trickier part is that legitimate broadcast traffic happens all the time. Detection here is about baselining normal and catching deviations.

---

## CTF Challenges

Apply what you've learned:

- [Easy 1 – Capturing a Hash](ctfs/BMPP_easy-1.md)
- [Easy 2 – Identifying Poisoning Traffic](ctfs/BMPP_easy-2.md)
- [Medium – NTLM Relay Attack](ctfs/BMPP_medium.md)
- [Hard – Full Network Takeover via DHCPv6](ctfs/BMPP_hard.md)

---

## Labs

Hands-on practice with the tools from the card:

- [Responder Lab](labs/responder.md)
- [Impacket Lab](labs/impacket.md)
- [MITM6 Lab](labs/mitm6.md)
- [Inveigh Lab](labs/inveigh.md)

---

Broadcast and multicast poisoning attacks are low-effort, high-reward. They often require nothing more than being on the same network and running a script. Understanding how they work - and how to spot them - is essential in any environment running Windows.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Cards/PE/Weaponizing_Active_Directory.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Cards/PE/Kerberoasting.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
