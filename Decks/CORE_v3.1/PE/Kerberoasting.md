<img width="300" height="414" alt="BNB_CARDS_v3_12" src="https://github.com/user-attachments/assets/343f81ff-7b7c-45ce-b509-c67d85d4ba46" />





# Kerberoasting

Kerberoasting is an **Active Directory attack technique** that targets service accounts  
It does not rely on malware or exploits. Instead, it abuses how Kerberos authentication is designed to work

If an attacker has **any valid domain user account**, they can attempt Kerberoasting

---

## What Kerberoasting Is

In Active Directory, services (SQL, IIS, backups, apps, etc) often run under **service accounts**
These accounts are linked to **Service Principal Names (SPNs)**

When a user wants to access a service, the domain controller issues a **Kerberos service ticket** for that SPN

**Kerberoasting** is about:
- Requesting those service tickets
- Extracting the encrypted part of the ticket
- Cracking it offline to recover the service account password

No **alerts**, no **lockouts**, no **interaction** with the service itself

---

## Why This Works

Kerberos is doing exactly what it is supposed to do

The problem is:
- Service account **passwords** are often **weak**
- They are **rarely** rotated
- They are sometimes reused or shared
- They often have **high privileges**

Once cracked, a service account can give:
- Local **admin** access
- Domain **admin** paths
- **Lateral movement** opportunities

---

## How Attackers Get There

A typical **Kerberoasting** path looks like this:

- Attacker gets **any domain user credentials**
- Enumerates SPNs in Active Directory
- Requests service tickets for those SPNs
- Dumps the ticket hashes
- Cracks them offline
- Uses recovered credentials to move deeper

This is why Kerberoasting is common **after phishing or initial access**

---

## What Happens After a Successful Crack

With a service account password, an attacker may:

- Log into servers running that service
- Execute commands remotely
- Dump credentials from memory
- Pivot to other systems
- Escalate privileges inside the domain

Many real intrusions escalate to domain compromise through Kerberoasting

---

## How Kerberoasting Is Detected

Detection is hard because the requests are legitimate, but patterns still exist

Common detection methods include:

- SIEM analysis of Kerberos service ticket requests
- UEBA alerts for unusual SPN activity
- Endpoint telemetry showing credential abuse tools
- Deception accounts with fake SPNs

Good detection focuses on **behavior**, not single events.

---

## CTF Challenges

You will solve four challenges related to Kerberoasting:

- [Easy 1 – Finding SPNs](ctfs/kerberoasting_easy-1.md)
- [Easy 2 – Ticket Extraction](ctfs/kerberoasting_easy-2.md)
- [Medium – Offline Cracking](ctfs/kerberoasting_medium.md)
- [Hard – Domain Escalation Path](ctfs/kerberoasting_hard.md)

---

## Labs

Hands-on practice with common Kerberoasting tools:

- [Rubeus Lab](labs/rubeus.md)
- [Impacket Lab](labs/impacket.md)
- [Hashcat Lab](labs/hashcat.md)
- [NetExec Lab](labs/netexec.md)

---

Kerberoasting is not a bug

It is a design tradeoff that becomes dangerous when service accounts are poorly managed

Understanding it is essential for both attackers and defenders working in Active Directory environments






***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Cards/PE/Broadcast-Multicast_Protocol_Poisoning.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Cards/PE/Internal_Password_Spray.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
