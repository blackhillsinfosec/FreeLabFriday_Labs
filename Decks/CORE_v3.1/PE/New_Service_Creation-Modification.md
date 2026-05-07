<img width="300" height="414" alt="BNB_CARDS_v3_16" src="https://github.com/user-attachments/assets/3564d2ab-1904-448d-86b3-a10840162d50" />




# New Service Creation / Modification

Services are background processes that run on a system - usually starting automatically when the machine boots. They handle things like networking, logging, antivirus, and much more. Because they run quietly in the background with high privileges, they are a prime target for attackers who already have a foothold on a machine.

---

## What Attackers Actually Do Here

Once an attacker has access to a system, they need a way to *stay* there. Reboots happen. Sessions close. Connections drop. Services solve that problem.

There are two main ways this plays out:

**Creating a new service** - The attacker registers a brand new service that points to their malicious payload. Every time the machine starts, the payload runs. It blends in with the dozens of other services already on the system, and most users never look at that list.

**Modifying an existing service** - Instead of creating something new, the attacker changes what a legitimate service points to. The name stays the same, the description stays the same, but the binary it executes is now theirs. This is harder to spot because the service itself looks familiar.

Either way, the goal is the same: run malicious code with minimal friction, and keep running it.

---

## How Attackers Get There

This technique isn't usually the first step - it comes *after* initial access. A common path looks like:

1. Initial access through phishing, an exposed service, or a vulnerability
2. Privilege escalation to get admin or SYSTEM-level rights
3. Service creation or modification to lock in persistence
4. Payload executes silently on every boot

The tools that make this easy are already on most Windows machines. `sc.exe`, PowerShell, and PsExec can all create or modify services without installing anything extra. That's part of what makes this technique effective - it's mostly living off the land.

---

## How It Gets Detected

Because service changes leave traces, there are a few reliable ways to catch this:

- **Endpoint Analysis** - Security agents on the machine can flag new or modified service entries, especially ones pointing to unusual paths like temp folders or user directories
- **Endpoint Security Protection Analysis** - EDR tools watch for service-related API calls and can correlate them with suspicious parent processes
- **SIEM Log Analysis** - Windows Event logs (especially Event IDs 7045 and 7040) record service installs and configuration changes. If your SIEM is tuned for these, it will alert when something unusual gets registered

The honest reality: a lot of organizations *have* this logging, but nobody is watching it. Attackers count on that.

---

## CTF Challenges

Four challenges to test what you've learned:

- [Easy 1 – Spot the Rogue Service](ctfs/NSC_easy-1.md)
- [Easy 2 – Event Log Digging](ctfs/NSC_easy-2.md)
- [Medium – Modified Service Investigation](ctfs/NSC_medium.md)
- [Hard – Full Persistence Chain](ctfs/NSC_hard.md)

---

## Labs

Hands-on practice with the tools from the card:

- [PsExec Lab](labs/psexec.md)
  
---

Service-based persistence is one of those techniques that shows up constantly in real incident reports. It's not flashy, but it works - and it works because defenders often underestimate how much noise is already in their service list. Knowing how to create it means you know how to find it.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/PE/Local_Privilege_Escalation.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/PE/Credential_Harvesting.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
