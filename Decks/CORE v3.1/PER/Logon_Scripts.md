<img width="300" height="414" alt="BNB_CARDS_v3_24" src="https://github.com/user-attachments/assets/98d59914-d0dc-4c92-af11-55879d613244" />





# Logon Scripts

Every time a user logs into a system, the OS can automatically run a set of scripts. These are called **logon scripts**, and they exist for legitimate reasons - pushing software, mapping network drives, setting environment variables. The problem is that attackers know this too.

When an attacker plants or modifies a logon script, their code runs every single time someone logs in. No clicks needed, no interaction required from the victim. Just a login event, and the payload executes.

---

## How Attackers Get There

To tamper with logon scripts, an attacker usually already has some level of access to the system. This technique is mostly about **persistence and privilege escalation**, not initial access. Common paths include:

- Exploiting a vulnerability to get a foothold, then modifying scripts to stay persistent
- Abusing Group Policy in Active Directory environments to push malicious scripts domain-wide
- Dropping scripts into user profile directories if file permissions are weak
- Modifying registry keys that point to scripts run at login (`HKCU\Environment`, `UserInitMprLogonScript`)

In Active Directory environments, this is especially dangerous. A compromised domain account with the right permissions can push a logon script to hundreds of machines at once.

---

## What Attackers Can Do With It

Once a logon script is under their control, an attacker can:

- **Maintain persistence** - every login re-executes their code, even after reboots
- **Escalate privileges** - if an admin logs in, the script runs with admin-level rights
- **Steal credentials** - scripts can quietly dump credentials or tokens from active sessions
- **Lateral movement** - scripts can beacon out, connect to C2 infrastructure, or move files across the network

The technique is subtle. The script blends in with normal system behavior, making it easy to miss unless someone is actively looking.

---

## How It Gets Detected

Security teams look for this through:

- **Endpoint Security Protection Analysis** - EDR tools flagging unexpected script modifications or unusual processes spawned at login
- **Endpoint Analysis** - reviewing logon script locations, registry keys, and Group Policy Objects (GPOs) for unauthorized changes

Log review is key here. A script being added or changed in a place it has no reason to be is a major red flag.

---

## CTF Challenges

Put your knowledge to the test:

- [Easy 1 – Suspicious Startup Script](ctfs/LS_easy-1.md)
- [Easy 2 – Registry Trail](ctfs/LS_easy-2.md)
- [Medium – GPO Abuse](ctfs/LS_medium.md)
- [Hard – Domain-Wide Persistence](ctfs/LS_hard.md)

---

## Labs

Hands-on practice with the tools used by attackers and defenders:

- [Metasploit Lab](labs/metasploit.md)
- [Impacket Lab](labs/impacket.md)
- [Havok Lab](labs/havok.md)
- [Mythic Lab](labs/mythic.md)

---

Logon scripts are one of those techniques that fly under the radar until it's too late. They are well-documented, widely used in real attacks, and worth understanding deeply - both to execute in a lab environment and to recognize in the wild.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Cards/PER/Malicious_Firmware.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Cards/PER/Malicious_Browser_Plugins.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
