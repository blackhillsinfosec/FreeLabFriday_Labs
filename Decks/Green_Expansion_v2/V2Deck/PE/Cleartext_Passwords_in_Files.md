<img width="300" height="414" alt="image (8)" src="https://github.com/user-attachments/assets/445efd1f-3a67-4b3d-b388-e9ec8f81a692" />




# Cleartext Passwords in Files

When passwords are stored as plain text inside files on a system - no hashing, no encryption, nothing - they become a free gift to any attacker who manages to get a foothold. Configuration files, scripts, log files, and even documentation often contain credentials that developers or sysadmins left "temporarily" and never cleaned up.

This is not a rare edge case. It is one of the most consistent findings in real-world penetration tests.

---

## Why This Happens

Systems need credentials to work - databases, APIs, services, remote servers. Those credentials have to come from somewhere. The lazy (and unfortunately common) approach is to just drop them into a config file or a shell script and move on.

The result: a file sitting on disk that says something like `password=Admin1234` or `DB_PASS=supersecret`.

Some common sources:

- Application config files (`.env`, `config.xml`, `appsettings.json`, `web.config`)
- Automation and deployment scripts (`.sh`, `.ps1`, `.bat`, `.py`)
- System logs that capture authentication attempts or debug output
- Source code committed to a repository with credentials baked in
- Backup files and exports left on the filesystem

---

## How Attackers Find Them

Once an attacker is on a system - even with limited access - finding cleartext passwords is mostly a search problem. They use tools designed to crawl the filesystem and pull out anything that looks like a credential.

The typical flow looks like this:

- Gain initial access to the target system
- Run a tool like Snaffler to scan network shares and local paths for sensitive files
- Parse the results for anything containing passwords, tokens, or keys
- Use those credentials to authenticate to other services or escalate privileges
- Move laterally across the network using the harvested credentials

The reason this works so well is that credentials found in files are often reused across multiple systems. One config file can open several doors.

---

## Why It Matters Defensively

This technique sits under the **Credential Access** tactic in the MITRE ATT&CK framework (T1552.001). Defenders need to catch it at two levels: prevent credentials from landing in files in the first place, and detect when someone is actively searching for them.

Detection methods used by security teams include:

- **User and Entity Behavior Analytics (UEBA)** - flags unusual file access patterns, like a user suddenly reading dozens of config files across shares
- **Active Defense and Cyber Deception** - planting fake credential files (honeytokens) that trigger alerts when accessed
- **Endpoint Analysis** - reviewing process activity to spot tools like Snaffler or PowerShell running enumeration commands
- **Endpoint Security Protection Analysis** - catching known credential-scraping tools before they complete their run

---

## CTF Challenges

Four challenges to test your understanding:

- [Easy 1 - File Recon](ctfs/CPF_easy-1.md)
- [Easy 2 - Log Digging](ctfs/CPF_easy-2.md)
- [Medium - Credential Pivot](ctfs/CPF_medium.md)
- [Hard - Full Credential Hunt](ctfs/CPF_hard.md)

---

## Labs

Hands-on practice with the tools mentioned on the card:

- [Snaffler Lab](labs/snaffler.md)
- [PowerShellEmpire Lab](labs/powershellempire.md)

---

Cleartext passwords in files are a symptom of a larger problem: credentials being treated as an afterthought. The damage they cause is rarely limited to the system where they were found - they are almost always a stepping stone to something bigger.


***                                                                 
<b><i>Want to go back? </br>[Previous Card](/Decks/Green_Expansion_v2/V2Deck/PE/SNAC_Attack.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
