<img width="300" height="414" alt="BNB_CARDS_v3_14" src="https://github.com/user-attachments/assets/e376e6fb-1d12-48f5-8b73-1ce1d058dbe7" />





# Weaponizing Active Directory

**Active Directory (AD)** is Microsoft's directory service. It's what most corporate networks use to manage users, computers, permissions, and policies in one place. If you've ever logged into a school or work computer and had access to shared drives and printers automatically, that was AD doing its job.

The problem? When an attacker gets a foothold inside a network, AD becomes their best friend. It's basically a map of everything: who exists, what they can access, and how systems trust each other. Attackers don't just break things - they read the map and walk through the front door.

---

## What Attackers Are Actually Looking For

Once inside a network, attackers focus on four main things AD exposes:

**Domain Trust Relationships** - companies often link multiple AD domains together so users can move between them. If one domain is compromised, those trust relationships can be a bridge to others.

**Group Policies (GPOs)** - these are settings pushed to machines across the domain. Misconfigured GPOs can allow attackers to run code on other systems or modify security settings silently.

**User and Group Privileges** - AD stores who belongs to what group. Finding a misconfigured privilege (like a regular user having admin rights somewhere they shouldn't) is often how attackers escalate.

**Object Access Control Lists (ACLs)** - every object in AD (users, computers, groups) has an ACL that says who can do what to it. A poorly set ACL can let an attacker reset a Domain Admin's password or take over an account without ever touching a password file.

The goal of all of this recon is to reach **Domain Admin** - full control over the entire domain. From there, the attacker owns every machine, every user, and every resource on the network.

---

## How Attackers Get There

The typical path looks like this:

- Compromise one low-privilege account (phishing, password spray, leaked creds)
- Run enumeration tools to map out the domain silently
- Find a misconfigured ACL, over-privileged group, or exploitable trust
- Move laterally to a higher-privilege account
- Reach Domain Admin and establish persistence

Tools like BloodHound make this process visual - attackers literally see attack paths laid out as graphs and follow the shortest one.

---

## How This Gets Detected

Because AD attacks rely heavily on querying directory objects and authenticating to systems, they leave traces:

- **SIEM Log Analysis** - tools like Splunk or Microsoft Sentinel can flag unusual LDAP queries, bulk user enumeration, or suspicious Kerberos ticket requests
- **User and Entity Behavior Analytics (UEBA)** - if an account that normally logs in from one machine suddenly starts touching fifty others, that's flagged as anomalous
- **Endpoint Security Protection Analysis** - EDR tools catch tools like BloodHound being executed or unusual AD enumeration happening on a host
- **Active Defense and Cyber Deception** - honeypot accounts or fake AD objects (canary tokens) can alert defenders the moment an attacker touches something they shouldn't know exists

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/pivot-escalate/weaponizing-active-directory?page=2)

<!--
- [Easy 1 – Reading the Map](ctfs/WAD_easy-1.md)
- [Easy 2 – Trust Issues](ctfs/WAD_easy-2.md)
- [Medium – ACL Abuse](ctfs/WAD_medium.md)
- [Hard – Full Domain Takeover](ctfs/WAD_hard.md)
-->
---

## Labs

Hands-on practice with the tools used by both attackers and defenders:

- [BloodHound Lab](labs/bloodhound.md)
- [PlumHound Lab](labs/plumhound.md)
- [Adminer Lab](labs/adminer.md)
- [SCCMHunter Lab](labs/sccmhunter.md)

---

AD attacks are some of the most common techniques seen in real-world breaches. Understanding how attackers map and abuse directory services is just as important for defenders as it is for red teamers. The goal isn't just to know the tools - it's to understand why the misconfigurations exist in the first place.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/PE/Credential_Harvesting.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/PE/Broadcast-Multicast_Protocol_Poisoning.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
