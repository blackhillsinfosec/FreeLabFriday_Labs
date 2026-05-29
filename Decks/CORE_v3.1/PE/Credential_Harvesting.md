<img width="300" height="414" alt="BNB_CARDS_v3_15" src="https://github.com/user-attachments/assets/41914840-6056-4cee-af1d-3296fbd539e2" />





# Credential Harvesting

When attackers get into a network, one of the first things they go after is credentials - usernames and passwords. Not because they need one account, but because one account leads to another, and another, until they reach something worth stealing.

Credential harvesting is exactly what it sounds like: collecting credentials from a system or environment, usually without the victim noticing.

---

## Where Credentials Hide

Most people assume passwords are only stored in login forms or databases. In reality, they end up in a lot of unexpected places:

- Config files left on shared drives
- Scripts and batch files written by admins
- Browser saved passwords
- Memory (RAM) of running processes
- Chat logs, notes, and emails
- Environment variables and `.env` files

Open shares are a goldmine. If a network drive is misconfigured and anyone can read it, attackers will crawl through every file looking for anything that looks like a password.

---

## How Attackers Get to the Credentials

The path usually starts with some level of existing access - either through a phishing email, an exploited vulnerability, or a compromised account. From there:

1. They map out what shares and files are accessible
2. They search for keywords like `password`, `pass`, `cred`, `secret`
3. They dump credentials from memory using tools like Mimikatz
4. They test those credentials against other systems (this is called credential stuffing or lateral movement)

Each new credential gives them a shot at a higher-value system - maybe a domain admin account, a database, or a cloud environment.

---

## Why This Is Dangerous

A single harvested credential can escalate into full network compromise. Attackers don't need to break down every door - they just need one set of keys and enough time to try them everywhere.

This is also why reused passwords are so risky. If the same password shows up in a config file and on the domain admin account, the attacker just won the game.

---

## How It Gets Detected

Defenders look for:

- Unusual file access patterns across shares (lots of reads in a short time)
- Processes accessing `lsass.exe` memory (a classic Mimikatz indicator)
- Authentication attempts from unexpected locations or times (UEBA catches this well)
- SIEM alerts on known credential dumping signatures

The tricky part is that a lot of this activity looks like normal admin behavior on the surface. That's what makes it hard to catch.

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](hhttps://learning.antisyphontraining.com/learn/course/bb-ctf-labs/pivot-escalate/credential-harvesting?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Exposed Config File](ctfs/CH_easy-1.md)
- [Easy 2 – Credential in a Share](ctfs/CH_easy-2.md)
- [Medium – Memory Dump Analysis](ctfs/CH_medium.md)
- [Hard – Full Credential Chain](ctfs/CH_hard.md)
-->
---

## Labs

Hands-on practice with the tools from the card:

- [GraphRunner Lab](labs/graphrunner.md)
- [DonPAPI Lab](labs/donpapi.md)
- [Snaffler Lab](labs/snaffler.md)
- [Mimikatz Lab](labs/mimikatz.md)

---

Credential harvesting is quiet, fast, and hard to reverse once it's happened. By the time you find the harvested credentials being used, the attacker may have already moved on. Understanding how it works is the first step to stopping it.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/PE/New_Service_Creation-Modification.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/PE/Weaponizing_Active_Directory.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
