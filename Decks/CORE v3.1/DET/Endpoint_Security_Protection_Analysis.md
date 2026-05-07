<img width="300" height="414" alt="BNB_CARDS_v3_38" src="https://github.com/user-attachments/assets/8f89e5c8-7aee-4dd4-8e75-22243760a159" />



# Endpoint Security Protection Analysis

An **endpoint** is any device that connects to a network - laptops, workstations, servers, phones. Endpoints are one of the most targeted surfaces in real attacks because they hold files, credentials, and access to internal systems.

Endpoint security is about making sure that if an attacker tries to do something on a device, they either get stopped or at least get noticed.

---

## What Attackers Actually Do on Endpoints

Most endpoint compromises follow a pattern:

- The attacker lands on the machine (phishing, exploit, stolen credentials)
- They run recon to figure out what they have access to
- They escalate privileges to get admin or SYSTEM level access
- They dump credentials so they can move to other machines
- They establish persistence so they survive reboots
- They start moving laterally across the network

The endpoint is usually not the final target - it's the starting point. What happens *after* initial access is where defenders either win or lose.

---

## Why Endpoint Visibility Matters

Logs from firewalls and network devices tell you about traffic. Endpoint logs tell you what actually *ran* on a machine.

Without endpoint visibility, you can see that a connection happened but not what caused it. With it, you can see the process, the parent process, the command line arguments, the file that was created, and the user who triggered it.

This is the difference between knowing a door opened and knowing who opened it, what they were carrying, and where they went next.

---

## What Defenders Are Looking For

- Unusual processes spawning from legitimate ones (e.g. Word spawning PowerShell)
- Scripts running in memory without touching disk
- New scheduled tasks or services being created
- Credential access tools like Mimikatz
- Lateral movement over SMB or RDP
- Persistence mechanisms in registry keys or startup folders

These patterns are called **TTPs** - Tactics, Techniques, and Procedures. Most endpoint security tools map detections to the MITRE ATT&CK framework, which catalogs how real attackers behave.

---

## CTF Challenges

Four challenges to test what you know:

- [Easy 1 – Suspicious Process Hunt](ctfs/EPA_easy-1.md)
- [Easy 2 – Registry Persistence](ctfs/EPA_easy-2.md)
- [Medium – Credential Dumping Investigation](ctfs/EPA_medium.md)
- [Hard – Full Lateral Movement Chain](ctfs/EPA_hard.md)

---

## Labs

Hands-on time with the tools defenders actually use:

- [Elastic Security Lab](labs/elasticSecurity/elastic-security.md)
- [OpenEDR Lab](labs/openedr.md)
- [Velociraptor Lab](labs/Velociraptor/velociraptor.md)
- [Wazuh Lab](labs/wazuh.md)

---

Attackers spend the most time on endpoints. That's where they run tools, steal data, and build persistence. Getting good at endpoint analysis means you can follow their trail - and cut it off.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE%20v3.1/DET/UEBA_Analytics.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE%20v3.1/DET/Active_Defense_And_Cyber_Deception.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
