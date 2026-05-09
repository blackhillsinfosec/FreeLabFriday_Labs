<img width="300" height="414" alt="image (10)" src="https://github.com/user-attachments/assets/158f56b0-bf80-41e0-8176-18a5c3211420" />


# Access Token Manipulation

When you log into a system, it does not keep asking for your password on every request. Instead, it gives you a **token** - a small piece of data that says "this person is authenticated." Access token manipulation is what happens when an attacker alters or forges that token to pretend to be someone else, sometimes even an administrator.

---

## How It Works

Authentication tokens come in many forms - session cookies, JWTs (JSON Web Tokens), Kerberos tickets, OAuth tokens. The idea behind all of them is the same: prove who you are once, carry a token, use it everywhere.

Attackers target tokens because they are easier to steal or fake than actual credentials. The main ways this plays out:

- **Token theft** - stealing a valid token from memory, network traffic, or storage
- **Token forgery** - crafting a fake token if the signing secret is weak or leaked
- **Token replay** - reusing a captured token before it expires
- **Privilege escalation via token modification** - changing a field like `"role": "user"` to `"role": "admin"` when the server does not properly verify the signature

Once an attacker holds a valid-looking token for a privileged account, they move through the system as that user. No brute force, no noisy login attempts.

---

## How Attackers Get There

The path to token manipulation usually starts somewhere else:

- Exploiting a web vulnerability to read tokens from memory or responses
- Stealing tokens from browser storage via XSS
- Intercepting tokens over unencrypted connections
- Cracking a weak JWT secret and re-signing a modified payload
- Abusing misconfigured OAuth flows that hand out overly permissive tokens

The attack is often quiet. Legitimate-looking requests with valid tokens blend right into normal traffic.

---

## What Happens After

Once an attacker has a working token for a privileged user, they can:

- Access data and functionality they should not reach
- Perform actions that get logged under the victim's identity
- Create new accounts or change configurations
- Move laterally by authenticating to other services that trust the same token

The real damage in many breaches comes not from the initial access but from what the attacker does with elevated privileges after the fact.

---

## How It Gets Detected

Token manipulation is caught through behavioral analysis more than signature-based detection. Things that raise flags:

- The same token being used from two different IP addresses at the same time
- Token payloads that do not match expected formats or signatures
- Access to admin endpoints by accounts with no admin history
- Endpoint protection tools catching tools like PowerSploit or Empire running on a host

Detection methods tied to this attack:

- **Endpoint Security Protection Analysis** - watching for suspicious processes and in-memory activity
- **Endpoint Analysis** - reviewing what ran on a host after the fact
- **Active Defense and Cyber Deception** - honeytokens and fake admin accounts that trigger alerts when accessed

---

## CTF Challenges

You will solve four challenges related to access token manipulation:

- [Easy 1 - Weak JWT Secret](ctfs/ATM_easy-1.md)
- [Easy 2 - Token from Local Storage](ctfs/ATM_easy-2.md)
- [Medium - OAuth Token Abuse](ctfs/ATM_medium.md)
- [Hard - Kerberos Silver Ticket](ctfs/ATM_hard.md)

---

## Labs

Hands-on practice with the tools used in real token manipulation attacks:

- [PowerSploit Lab](labs/powersploit.md)
- [Empire Lab](labs/empire.md)
- [PoshC2 Lab](labs/poshc2.md)

---

Token manipulation sits at the intersection of authentication design and attacker creativity. Understanding how tokens are built, where they live, and how they can be abused is essential for both breaking and defending modern systems.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/Green_Expansion_v2/V2Deck/PE/SNAC_Attack.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/Green_Expansion_v2/V2Deck/PE/Internal_Spearphishing.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
