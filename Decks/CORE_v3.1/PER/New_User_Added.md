<img width="300" height="414" alt="BNB_CARDS_v3_21" src="https://github.com/user-attachments/assets/a96fede7-b3b1-457b-93f3-2f8860e6b167" />


# New User Added

When attackers get into a system, their first concern is staying in. One of the simplest ways to do that is creating a new user account - one they control, one that blends in, and one that survives even if the original breach gets patched or discovered.

This technique is called **persistence through account creation**, and it shows up in almost every serious intrusion.

---

## Why Attackers Create New Accounts

Breaking in is hard. Staying in is the goal.

After gaining initial access - whether through a phishing email, a stolen credential, or a vulnerability - attackers know they are on borrowed time. The compromised account might get its password reset. The exploited service might get patched. A suspicious login might trigger an alert.

A new account solves all of that. It can be named to look like a service account, a generic IT user, or something that wouldn't raise questions in a list of 200 employees. If the original foothold disappears, the attacker still has a door.

The new account usually gets:
- Local or domain admin privileges
- A password only the attacker knows
- A name that doesn't stand out at first glance

---

## How It Actually Happens

The attacker doesn't need anything fancy to create a new user - they just need the right level of access. On a Windows machine with admin rights, it's a single command. On Linux, same thing.

The more interesting part is *where* this happens in the attack chain. By the time an attacker is creating accounts, they've usually already:

1. Gained initial access (phishing, credential stuffing, exploitation)
2. Escalated privileges to something useful
3. Moved around the network enough to know where they are
4. Decided this system is worth keeping

Account creation is not the beginning of an attack. It's a sign the attacker already feels comfortable.

---

## How This Gets Detected

Detecting rogue account creation comes down to one thing: **knowing what normal looks like**.

If your organization creates new user accounts through a specific process - and suddenly an account appears outside that process, at 2am, from an unusual machine - that's a flag.

The main detection methods:

- **SIEM log analysis** - Windows Event ID 4720 fires every time a local account is created. Domain controllers log similar events. If nobody is watching these, account creation can go unnoticed for months.
- **Endpoint Security Protection Analysis** - EDR tools can catch the exact commands or API calls used to create accounts, even if logs get cleared afterward.
- **Endpoint Analysis** - Reviewing `/etc/passwd` on Linux systems or the local user list on Windows can reveal accounts that don't belong.
- **Permissions Audit** - Regular audits of who has admin rights will surface accounts that shouldn't exist or shouldn't have the access they do.

The sad reality is that in a lot of real incidents, the rogue account only gets discovered during forensic analysis - long after the damage is done.

---

## The Tools Attackers Use

These aren't exotic tools. They're used in real red team engagements and real attacks.

- **Metasploit** - has modules for adding users post-exploitation, often used after getting a shell
- **Impacket** - a Python library with tools like `addcomputer.py` and others that interact with Windows authentication protocols remotely
- **Havok** - a command-and-control framework that can run post-exploitation tasks including account manipulation
- **Mythic** - another C2 framework, more modular, used to issue commands to implants running on compromised hosts

None of these tools "create a user" in a magic way. They just wrap the same operating system calls an admin would use - they just do it without the admin's permission.

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/persistence/new-user-added?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Spot the Account](ctfs/NUA_easy-1.md)
- [Easy 2 – Log Hunt](ctfs/NUA_easy-2.md)
- [Medium – Persistence Chain](ctfs/NUA_medium.md)
- [Hard – Full Intrusion Timeline](ctfs/NUA_hard.md)
-->
---

## Labs

Hands-on practice with each tool from the card:

- [Metasploit Lab](https://freelabfridays.com/labs/decks/core-v31/labs/metasploit/)
- [Impacket Lab](https://freelabfridays.com/labs/decks/core-v31/per/labs/impacket/)
- [Havok Lab](https://freelabfridays.com/labs/decks/core-v31/labs/havok/)
- [Mythic Lab](https://freelabfridays.com/comingsoon/)

---

Account creation is one of those techniques that looks boring on paper but shows up constantly in real incident reports. It's quiet, it's effective, and it's easy to miss if nobody is watching the right logs. That's exactly why it's worth understanding.