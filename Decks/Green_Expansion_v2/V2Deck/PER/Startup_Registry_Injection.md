<img width="300" height="414" alt="image (3)" src="https://github.com/user-attachments/assets/31695e82-c1da-4ae3-a633-c8c055ab5365" />






# Startup Registry Injection

The Windows Registry is a database that stores low-level settings for the operating system and for applications. Certain registry keys tell Windows what programs to run automatically when the system starts or when a user logs in. Attackers take advantage of this by writing their malicious code into those keys - so every time the machine boots up, the malware runs too, without the user doing anything.

This technique is called **Startup Registry Injection**, and it is one of the most common ways attackers maintain persistent access to a system they have already compromised.

---

## How It Works

The attacker does not need to find a new vulnerability every time they want access. They only need to get in once, then write a registry key that keeps their code running. After that, the malware survives reboots, user logouts, and even some cleanup attempts.

The most commonly abused registry locations are:

- `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run` - runs for the current user on login
- `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run` - runs for all users on login
- `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services` - used for service-based persistence

Writing to `HKLM` keys usually requires administrator privileges. `HKCU` keys, however, can be written by any user - which makes them especially useful for attackers who land with limited access.

---

## The Attack Path

A typical sequence looks like this:

- Attacker gains initial access through phishing, exploitation, or stolen credentials
- Drops a malicious executable or script somewhere on disk
- Writes a registry key pointing to that file under a Run key
- The machine reboots, or the user logs in again
- Windows reads the registry and executes the malware automatically

From that point on, the attacker has a foothold that survives restarts. This is called **persistence**, and it is one of the first things attackers establish after getting in.

---

## Why It Is Hard to Catch

The registry has thousands of legitimate entries. Defenders need to know what is normal before they can spot what is not. A malicious entry that points to a file named `svchost32.exe` or `updater.exe` blends in easily.

Additionally, the actual damage - data theft, lateral movement, command and control traffic - happens after the registry key is already in place. By the time something looks suspicious, the attacker may have been persistent for days or weeks.

---

## How It Gets Detected

Security teams look for registry injection through:

- Endpoint Security Protection Analysis - alerts on suspicious writes to Run keys, especially from unusual processes
- Endpoint Analysis - reviewing registry hives for entries that point to unknown or unsigned executables

Both detection methods rely on baselining what is normal and flagging what deviates from it.

---

## CTF Challenges

You will solve four challenges built around startup registry injection:

- [Easy 1 - Suspicious Run Key](ctfs/SRI_easy-1.md)
- [Easy 2 - Registry Artifact Hunt](ctfs/SRI_easy-2.md)
- [Medium - Persistence Through Reboot](ctfs/SRI_medium.md)
- [Hard - Layered Registry Persistence](ctfs/SRI_hard.md)

---

## Labs

Hands-on practice with the tool from the card:

- [reg command Lab](labs/reg-command.md)

---

Registry-based persistence is not flashy, but it is effective. Attackers use it precisely because it is quiet, it survives reboots, and it hides in a place most users never look. Understanding how it works is a foundational skill for anyone doing endpoint forensics or incident response.


***                                                                 
<b><i>Want to go back? </br>[Previous Card](/Decks/Green_Expansion_v2/V2Deck/PER/Service_Recovery_Hijacking.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
