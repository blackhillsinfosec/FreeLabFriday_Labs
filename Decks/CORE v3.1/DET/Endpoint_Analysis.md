<img width="300" height="414" alt="BNB_CARDS_v3_40" src="https://github.com/user-attachments/assets/db2def7e-7b0b-487d-b7fe-4cb495baac98" />






# Endpoint Analysis

An **endpoint** is any device connected to a network - a laptop, a workstation, a server, a phone. When something goes wrong on a network, the endpoint is usually where the story starts or ends. Endpoint analysis is the process of examining those devices to figure out what happened, when, and how.

It is one of the most important skills in incident response. Logs do not lie, and most attackers leave traces whether they mean to or not.

---

## What a Compromised Endpoint Looks Like

Not every compromise announces itself. In most real cases, the device keeps working normally while something malicious runs quietly in the background.

Signs that an endpoint may be compromised include:

- Processes running that should not be there
- New scheduled tasks or startup entries that were not set by an admin
- Outbound connections to unknown or suspicious addresses
- Changes to files in sensitive directories
- User accounts created or modified outside of normal activity
- Security tools disabled or tampered with

The tricky part is that many of these signs look like normal system behavior at first glance. That is why defenders need to know what *normal* looks like before they can spot what is not.

---

## How Attackers Get on an Endpoint

The path onto an endpoint usually starts with one of a few common techniques:

- **Phishing** - a user opens a malicious attachment or link and runs something they should not have
- **Exploitation** - a vulnerability in software running on the machine gets abused remotely
- **Credential theft** - an attacker uses stolen or guessed credentials to log in directly
- **Lateral movement** - the attacker is already on the network and moves from one machine to another

Once on the device, they will typically try to establish persistence so they survive a reboot, escalate privileges to get more control, and avoid detection for as long as possible.

---

## What Defenders Are Looking For

When analysts investigate an endpoint, they are asking a few core questions:

- Was anything executed that should not have been?
- Were any files created, modified, or deleted in suspicious locations?
- Did anything try to connect out to an external address?
- Were any accounts or permissions changed?
- Is there evidence of tools commonly used by attackers (credential dumpers, port scanners, remote access tools)?

The answers are usually buried in event logs, running process lists, registry keys, file system metadata, and network connection records. Pulling that picture together is what endpoint analysis is all about.

---

## CTF Challenges

Test what you have learned with these four challenges:

- [Easy 1 – Suspicious Process Hunt](ctfs/EA_easy-1.md)
- [Easy 2 – Event Log Review](ctfs/EA_easy-2.md)
- [Medium – Persistence Mechanism](ctfs/EA_medium.md)
- [Hard – Full Endpoint Compromise](ctfs/EA_hard.md)

---

## Labs

Hands-on practice with the tools from the card:

- [DeepBlueCLI Lab](labs/deepbluecli/deepbluecli.md)
- [Velociraptor Lab](labs/Velociraptor/velociraptor.md)
- [Incident Response Cheat Sheets Lab](labs/ir-cheatsheets.md)
- [osquery Lab](labs/osquery.md)

---

Endpoint analysis is not glamorous work. It is methodical, detail-oriented, and sometimes slow. But it is how real incidents get understood and contained. The attacker only needs to get lucky once - the defender needs to find them anyway.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE%20v3.1/DET/Isolation.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE%20v3.1/DET/UEBA_Analytics.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
