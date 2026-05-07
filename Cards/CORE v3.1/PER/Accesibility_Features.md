<img width="300" height="414" alt="BNB_CARDS_v3_26" src="https://github.com/user-attachments/assets/1e154b5f-4055-4563-a254-8f2985fb9d57" />




# Accesibility Features

Operating systems ship with built-in accessibility tools meant to help users with disabilities. Things like Sticky Keys, the On-Screen Keyboard, and Magnifier are there for good reasons. Attackers know this, and they abuse them.

The core idea is simple: these tools run with high privileges, they can be triggered before a user even logs in, and most security teams never think to check them.

---

## How the Attack Works

Windows accessibility shortcuts are tied to specific executables. For example, pressing Shift five times launches `sethc.exe` (Sticky Keys), even from the login screen.

Attackers replace or modify those executables with something else, usually a command prompt or a backdoor. When the shortcut is triggered, instead of the accessibility tool opening, the attacker's payload runs, often as SYSTEM.

This is commonly done after an attacker already has some level of access to the machine, for example through a malicious USB device. It gives them a persistent way back in that survives reboots and doesn't require credentials.

Common targets:

- `sethc.exe` - Sticky Keys (Shift x5)
- `osk.exe` - On-Screen Keyboard
- `utilman.exe` - Ease of Access menu (Win + U)
- `narrator.exe` - Narrator
- `magnify.exe` - Magnifier

---

## How Attackers Get to This Point

Physical access is the most direct path. Tools like the Bash Bunny, USB Rubber Ducky, and OMGCable are designed to automate attacks the moment they are plugged in. They can run scripts in seconds, replacing accessibility binaries before anyone notices.

Remote access works too. Once an attacker has a foothold through any other method, they can make these changes remotely and leave themselves a backdoor that looks completely legitimate.

---

## What Happens After

Once the swap is done, the attacker can:

- Open a SYSTEM-level shell from the login screen without credentials
- Create new admin accounts
- Disable security tools
- Move laterally through the network

Because the accessibility executables are signed by Microsoft in their original form, swapping them out is detectable, but only if someone is looking.

---

## How It Gets Detected

This technique is not invisible. It leaves traces:

- File integrity monitoring catches changes to accessibility binaries
- Endpoint security tools flag unexpected modifications to system executables
- Process analysis can show a command prompt spawned from an accessibility shortcut
- Registry changes used to redirect these tools are also logged

Detection usually comes down to whether endpoint monitoring is properly configured and whether anyone is reviewing the alerts.

---

## CTF Challenges

Put what you learned to the test:

- [Easy 1 - Spot the Swap](ctfs/AF_easy-1.md)
- [Easy 2 - USB Drop Investigation](ctfs/AF_easy-2.md)
- [Medium - Persistence via Sticky Keys](ctfs/AF_medium.md)
- [Hard - Full Physical Attack Simulation](ctfs/AF_hard.md)

---

## Labs

Hands-on practice with the tools from this card:

- [Bash Bunny Lab](labs/bash-bunny.md)
- [USB Rubber Ducky Lab](labs/usb-rubber-ducky.md)
- [OMGCable Lab](labs/omgcable.md)

---

Accessibility feature hijacking is one of those techniques that feels obscure until you realize how effective it is. A cheap USB device, thirty seconds of physical access, and an attacker has a persistent SYSTEM shell waiting for them. Physical security is not separate from cybersecurity - it is part of it.

***                                                                 
<b><i>Want to go back? </br>[Previous Card](/Cards/PER/Malicious_Firmware.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
