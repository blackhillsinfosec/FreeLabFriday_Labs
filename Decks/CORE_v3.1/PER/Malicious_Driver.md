<img width="300" height="414" alt="BNB_CARDS_v3_20" src="https://github.com/user-attachments/assets/e751aea6-bce6-4bd3-82b0-b27b4de949ea" />





# Malicious Driver

A **malicious driver** is a device driver that has been installed or tampered with by an attacker to maintain control over a system - even after it reboots. Because drivers run at the kernel level, they sit deeper in the operating system than most security tools can see.

This makes them one of the stealthiest persistence techniques out there.

---

## What Is a Device Driver

Drivers are small programs that let the operating system talk to hardware - your keyboard, network card, graphics chip. The OS trusts them completely, and they run with the highest privileges on the system.

That trust is exactly what makes them attractive to attackers.

---

## How Attackers Get There

Before installing a malicious driver, an attacker needs to already be on the system. From there, the typical path looks like this:

- They escalate privileges to get admin or SYSTEM access
- They find a way to load an unsigned or weakly signed driver (often by abusing a known vulnerable legitimate driver first)
- The malicious driver gets registered as a service, so it loads automatically on boot
- From that point, it can hide processes, intercept data, or keep a backdoor open indefinitely

The key thing to understand is that this is a **post-exploitation** technique. It is not how attackers get in - it is how they make sure they stay in.

---

## Why It Is Hard to Detect

Normal antivirus and EDR tools run in user space or as kernel-level processes that the malicious driver can see coming. A well-written rootkit driver can hide files, registry keys, network connections, and even itself from the tools trying to find it.

Detection usually requires looking at things like:

- **Endpoint Security Protection Analysis** - checking for gaps or blind spots in your security tooling, which a driver-level implant might create
- **Memory Analysis** - inspecting raw memory for unsigned code or unexpected kernel modules
- **Endpoint Analysis** - reviewing loaded drivers, services, and boot configuration for anything that does not belong

---

## Tools Involved

Attackers use a mix of tools to pull this off:

- **Impacket** - for moving laterally and deploying payloads remotely over SMB or other protocols
- **PowerShell** - for staging, downloading, and registering the driver as a service without touching too many files
- **Metasploit** - provides modules for driver-based privilege escalation and persistence
- **Kernel Driver Utility (KDU)** - a real tool that abuses legitimate vulnerable drivers to load unsigned kernel code
- **SharpStay** - a .NET persistence toolkit that includes driver-based persistence options alongside others

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/persistence/malicious-driver?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Spot the Suspicious Driver](ctfs/MDR_easy-1.md)
- [Easy 2 – Registry Persistence Hunt](ctfs/MDR_easy-2.md)
- [Medium – Memory Forensics](ctfs/MDR_medium.md)
- [Hard – Full Kernel Rootkit Investigation](ctfs/MDR_hard.md)
-->
---

## Labs

Hands-on practice with each tool:

- [Impacket Lab](labs/impacket.md)
- [PowerShell Lab](labs/powershell.md)
- [Metasploit Lab](labs/metasploit.md)
- [KDU Lab](labs/kdu.md)
- [SharpStay Lab](labs/sharpstay.md)

---

Malicious drivers are not common in every attack, but when they show up, they signal a serious and skilled threat. Defenders who understand how kernel-level persistence works are far better equipped to catch it before the damage compounds.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/PER/New_User_Added.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/PER/Dynamic_Link_Library_Hijacking.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
