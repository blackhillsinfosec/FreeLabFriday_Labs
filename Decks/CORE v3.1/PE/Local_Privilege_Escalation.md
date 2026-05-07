<img width="300" height="414" alt="BNB_CARDS_v3_17" src="https://github.com/user-attachments/assets/3dbb6b63-78cc-4955-92bd-522c44833621" />


# Local Privilege Escalation (LPE)

**Local Privilege Escalation** happens **after an attacker already has access** to a system, but only as a low-privileged user
The goal is simple: turn limited access into **administrator or root access**

This is one of the most important stages of an attack

Without **LPE**, attackers are often stuck, with it, they fully own the system

---

## What Local Privilege Escalation Means

Operating systems separate users by **privilege** for a reason
Normal users should not be able to:

- **Install** system software  
- **Read** sensitive system files  
- **Control** security settings  

**LPE** is when this separation fails.

Attackers abuse **misconfigurations, weak permissions, or software bugs** to break out of user-level access and gain full control

---

## How Attackers Reach This Stage

LPE is rarely the first step, it usually comes after:

- Exploiting a **web app** or service
- Using stolen credentials
- Getting access through phishing or malware
- Landing a low-privilege shell on a server or workstation

At this point, the attacker asks:  
**“What can I abuse locally to become admin?”**

---

## Common LPE Weaknesses

Most real-world LPE issues fall into a few categories:

- Services running with **high privileges** but **writable** by users
- Scheduled tasks or **cron jobs** with **weak** permissions
- **Misconfigured** sudo or runas rules
- **Vulnerable** drivers or kernel exploits
- **Hardcoded** credentials or secrets in files
- **PATH hijacking** and **DLL search order** issues

These issues are often ignored because the system “works fine”

---

## What Full Privilege Gives an Attacker

Once privilege escalation succeeds, the attacker can:

- **Disable** security tools
- **Dump credentials** and hashes
- **Create** new admin users
- **Move laterally** to other systems
- **Maintain** long-term persistence

At this stage, cleanup becomes much harder

---

## How LPE Is Detected

Privilege escalation is difficult to spot, but defenders rely on:

- **Endpoint monitoring** and behavior analysis
- **Unusual** process execution chains
- **Abuse** of system binaries and services
- **Deception techniques** and **honeytokens**
- Post-incident forensic **analysis**

In many cases, LPE is only found **after** a breach investigation starts

---

## CTF Challenges

You will solve four challenges focused on local privilege escalation:

- [Easy 1 – Insecure Permissions](ctfs/LPE_easy-1.md)
- [Easy 2 – Misconfigured Service](ctfs/LPE_easy-2.md)
- [Medium – Enumeration to Exploit](ctfs/LPE_medium.md)
- [Hard – Chained Escalation](ctfs/LPE_hard.md)

---

## Labs

Hands-on labs using common LPE tools:

- [Impacket Lab](labs/impacket.md)
- [Seatbelt Lab](labs/seatbelt.md)
- [SharpUp Lab](labs/sharpup.md)
- [PEASS-ng Lab](labs/peass-ng.md)

---

Local Privilege Escalation is where many attacks truly succeed or fail
Understanding how it works — and how to prevent it — is a core skill for anyone serious about system security



***                                                                 
<b><i>Want to go back? </br>[Previous Card](/Cards/PE/New_Service_Creation-Modification.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
