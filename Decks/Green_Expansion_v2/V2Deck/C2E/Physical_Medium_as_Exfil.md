<img width="300" height="414" alt="image (2)" src="https://github.com/user-attachments/assets/409f7865-2106-4ddc-9f79-0e7d67b12b0d" />





# Physical Medium as Exfil

Data exfiltration does not always happen over the internet. Sometimes, the simplest way to steal data is to walk out with it. Physical medium exfiltration is exactly that - using a device you can hold in your hand to copy and carry sensitive data out of a secured environment.

---

## What Is Physical Medium Exfil?

When attackers have physical access to a machine or a network port, they can plug in a device and pull data directly. No need to bypass firewalls or evade network monitoring. The device just looks like a USB drive or a phone charging - and by the time anyone notices, the data is already gone.

Common devices used:
- USB flash drives
- Smartphones (mounted as storage)
- Portable SSDs
- Raspberry Pi's (tiny computers that can run scripts on their own)

This works especially well in environments where physical access is not properly controlled - unlocked workstations, unattended servers, open office areas.

---

## How Attackers Pull It Off

The typical flow looks like this:

- Attacker gets physical access - either as an insider, a visitor, or someone who tailgates through a door
- They plug in a device while the machine is unlocked, or use a tool like Evil Socks that auto-runs on connection
- Data gets copied to the device in seconds or minutes
- They walk out, and the logs show nothing unusual

It is also common to do this during a pentest or a red team engagement, where the goal is to prove that physical security is just as important as digital security.

---

## Why It Is Hard to Catch

Most security tools focus on the network. Firewalls, IDS, SIEM alerts - they are all watching traffic. But if data never leaves through the network, they have nothing to catch. 

Physical exfil is quiet. There are no outbound connections, no suspicious DNS queries, nothing. Unless someone is watching the room or the endpoint is configured to block USB devices, the attack goes undetected.

---

## How It Gets Detected

The detection methods on this card target exactly this blind spot:

- **Physical Security Review** - checking whether access controls, cameras, and policies are actually working
- **Endpoint Security Protection Analysis** - reviewing whether endpoints block or log unauthorized USB connections
- **Endpoint Analysis** - looking at endpoint logs for signs of large file copies or new device mounts
- **Site Walkthrough** - physically walking through the space to spot exposed ports, unattended machines, or weak access controls

---

## CTF Challenges

Test your understanding with these scenarios:

- [Easy 1 - Spot the Device](ctfs/PME_easy-1.md)
- [Easy 2 - Log the Copy](ctfs/PME_easy-2.md)
- [Medium - The Insider](ctfs/PME_medium.md)
- [Hard - Full Exfil Chain](ctfs/PME_hard.md)


---

Physical security is not optional. An attacker who can touch your hardware can often skip every digital control you have in place. The best defenses combine strong access policies, endpoint controls, and people who actually notice when something looks off.


***                                                                 
<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
