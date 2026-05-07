<img width="300" height="414" alt="BNB_CARDS_v3_19" src="https://github.com/user-attachments/assets/9083916b-0e6a-4841-a337-e1a4f2e3f314" />





# Dynamic Link Library(DLL) Hijacking

A **DLL** (Dynamic Link Library) is a file that contains code and data that multiple programs can use at the same time. Think of it like a shared toolbox - instead of every program carrying its own tools, they all reach into the same box when they need something.

**DLL Hijacking** happens when an attacker tricks a legitimate program into loading a malicious DLL instead of the real one. The program runs normally from the outside, but underneath it is executing the attacker's code - often with elevated privileges.

---

## How Programs Load DLLs

When a Windows program needs a DLL, it searches for it in a specific order:

1. The directory the application is running from
2. The Windows system directories
3. Other directories listed in the PATH variable

This search order is the core of the problem. If an attacker can place a malicious DLL earlier in that search path than the legitimate one, the program will load it without question.

---

## How Attackers Pull This Off

The typical flow looks like this:

- The attacker identifies a program that loads a DLL it cannot find (or finds in a writable location)
- A malicious DLL with the same name is crafted and dropped into a directory the program checks first
- The program runs and loads the attacker's DLL instead of the real one
- The malicious code executes, usually with whatever privileges the program has

Common conditions that make this possible:

- Applications running from user-writable directories
- Programs searching for DLLs that do not exist on the system
- Weak folder permissions that allow files to be placed in sensitive locations
- Auto-start programs that get executed at boot with high privileges

---

## Why This Is Dangerous

DLL Hijacking is particularly nasty because it abuses legitimate software. Antivirus and security tools often see a trusted program running, not something obviously malicious. The attacker's code hides inside normal behavior.

It is also a reliable way to maintain persistence. If the hijacked program runs at startup, the attacker's DLL runs at startup too - every single reboot.

---

## How It Gets Detected

Since the technique hides inside legitimate processes, defenders have to look carefully:

- **Endpoint Security Protection Analysis** - behavioral engines that flag unexpected DLL loads or unusual module activity inside trusted processes
- **Memory Analysis** - examining what is actually loaded in memory at runtime, checking for DLLs loaded from unexpected paths
- **Endpoint Analysis** - reviewing file system changes, checking DLL locations against known-good baselines, and auditing folder permissions

---

## CTF Challenges

Put the theory into practice:

- [Easy 1 – Wrong Place, Right Name](ctfs/DLL_easy-1.md)
- [Easy 2 – Missing DLL Hunt](ctfs/DLL_easy-2.md)
- [Medium – Privilege Through a Hijacked Load](ctfs/DLL_medium.md)
- [Hard – Persistence via Boot-Time Hijack](ctfs/DLL_hard.md)

---

## Labs

Hands-on work with the tools from the card:

- [DLLHijackTest Lab](labs/dllhijacktest.md)
- [PowerSploit Lab](labs/powersploit.md)
- [FaceDancer Lab](labs/facedancer.md)
- [PersistBOF Lab](labs/persistbof.md)

---

DLL Hijacking sits at an awkward intersection - it is technically simple, but hard to catch. A single misconfigured directory or a missing DLL can hand an attacker everything they need. Understanding how it works is the first step toward making sure it does not work on your systems.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/PER/Malicious_Driver.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/PER/Malicious_Service.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
