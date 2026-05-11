<img width="300" height="414" alt="image (9)" src="https://github.com/user-attachments/assets/72d5abd0-464e-4a79-87fc-5d4a3a9fa8b7" />





# Stale Network Address Configurations (SNAC) Attack

Networks change all the time - servers get decommissioned, IPs get reassigned, services move around. The problem is that the old records pointing to those systems often stick around long after the systems themselves are gone. A **SNAC attack** is what happens when an attacker finds and exploits those leftover references.

Think of it like a package that keeps getting delivered to an old address - except the attacker is the one now living there.

---

## What "Stale" Actually Means

A stale network configuration is any record that no longer reflects reality:

- A DNS entry that still points to a decommissioned server
- A DHCP reservation for a machine that no longer exists
- A static IP in a config file that has since been reassigned to a different host

These leftovers are created constantly - during migrations, cloud transitions, device replacements, or just poor housekeeping. Most teams clean up the systems themselves but forget the records pointing to them.

---

## How Attackers Take Advantage

The attack path is fairly straightforward:

- Attacker scans or monitors the network for unresolved or misconfigured entries
- Identifies a stale record that still gets traffic (DNS queries, DHCP requests, ARP broadcasts)
- Registers or claims the old address/hostname - either by spinning up a new machine or through ARP spoofing
- Traffic intended for the old system now arrives at the attacker's machine
- From there, the attacker can intercept credentials, capture sensitive data, or act as a relay

The dangerous part is that nothing looks obviously broken - the network behaves normally, just traffic ends up in the wrong place.

---

## Why This Happens

SNAC vulnerabilities come down to a few common patterns:

- **No cleanup process** - teams remove systems without auditing the records that reference them
- **Fragmented ownership** - one team manages DNS, another manages DHCP, and nobody has the full picture
- **Long TTLs** - DNS records that cache for hours or days hide the fact that the underlying system is gone
- **Static configs in code** - hardcoded IPs in scripts or application configs that never get updated

---

## How SNAC Attacks Are Detected

Detection focuses on spotting the mismatch between what the network records say and what is actually on the network:

- **Network Threat Hunting** - actively looking for orphaned DNS/DHCP entries and unexpected responses to old hostnames
- **Firewall Log Analysis** - spotting traffic going to addresses that should not be active
- **SIEM Log Analysis** - correlating events across DNS, DHCP, and endpoint logs to flag unusual claim patterns

In many cases, the first sign something is wrong is a credential showing up somewhere unexpected, or a service failing to authenticate because its token was captured in transit.

---

## CTF Challenges

Test your understanding with these four scenarios:

- [Easy 1 - Spotting the Ghost](ctfs/SNAC_easy-1.md)
- [Easy 2 - Dead Record Recon](ctfs/SNAC_easy-2.md)
- [Medium - Address Claim](ctfs/SNAC_medium.md)
- [Hard - Full SNAC Chain](ctfs/SNAC_hard.md)

---

## Labs

Hands-on practice with the detection tool from the card:

- [Eavesarp Lab](labs/eavesarp.md)

---

Stale configurations are not glamorous, but they are everywhere. A network that never gets properly cleaned up is one that quietly hands attackers a way in - no exploit required.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/Green_Expansion_v2/V2Deck/PE/Cleartext_Passwords_in_Files.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/Green_Expansion_v2/V2Deck/PE/Access_Token_Manipulation.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
