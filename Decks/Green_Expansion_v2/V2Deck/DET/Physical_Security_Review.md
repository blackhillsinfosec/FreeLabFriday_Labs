<img width="300" height="414" alt="image (1)" src="https://github.com/user-attachments/assets/cd02f812-8a28-4e11-a809-5e53805609d2" />






# Physical Security Review

Physical security is what stands between an attacker and the hardware, people, and data inside a building. When people think about hacking, they usually picture someone behind a keyboard. But a lot of real intrusions start with someone walking through the wrong door.

A **Physical Security Review** is a structured assessment where security professionals look at a location the way an attacker would - not to break in, but to find where someone could.

---

## What Gets Reviewed

There are four main areas that get checked:

**Badge systems** - Who can get in, and where? Are old employee badges still active? Can a badge be cloned with a cheap reader bought online? Is the door actually locked after someone badges in, or does it swing open for ten seconds?

**Surveillance blind spots** - Cameras only help if they cover the right areas. Reviewers map out where cameras are, then find where they are not. Loading docks, stairwells, and side entrances are common gaps.

**Unsecured entry points** - Not every entry point has a camera or a badge reader. Emergency exits, rooftop access, basement doors, and delivery areas are all worth checking. An attacker does not need to find the front door if the side door is always propped open.

**On-site access policies** - Rules matter, but only if people follow them. Do employees hold doors open for strangers? Can a visitor wander the office without an escort? Is the server room locked or just closed?

---

## How Attackers Take Advantage of Physical Gaps

Physical security failures are often used as a starting point rather than an end goal. Here is what a typical physical intrusion might look like:

- Attacker poses as a delivery driver or contractor
- Tailgates an employee through a badge-protected door
- Finds an unlocked workstation or a network jack in a conference room
- Plugs in a small device and walks out

That last step can give remote access to the internal network - no phishing, no exploits, just a door that was not secured properly.

Other common physical attacks include:

- **Badge cloning** - reading the signal from an RFID badge without the owner knowing, then copying it to a blank card
- **Dumpster diving** - pulling sensitive documents from trash that was not shredded
- **Shoulder surfing** - watching someone type their password or PIN
- **USB drops** - leaving infected USB drives in parking lots or lobbies, hoping someone picks one up and plugs it in

---

## What a Review Actually Looks Like

A physical security review is not just a checklist. Reviewers physically walk the site, test doors, check camera coverage, attempt tailgating, and try to access areas they should not be able to reach.

The output is a report that shows:

- Where the gaps are
- How an attacker could realistically exploit each one
- What it would take to fix them

This is the same mindset as a penetration test - find the weaknesses before someone else does.

---

## Why This Matters

Most organizations spend heavily on firewalls and endpoint protection. Physical security is often treated as someone else's problem - facilities, not IT. That separation is exactly what attackers count on.

A five-dollar tailgate through a badge door can bypass a million dollars of network security. The physical and digital worlds are connected, and a review that only looks at one of them is only half a review.

---

## CTF Challenges

You will solve four challenges related to physical security concepts:

- [Easy 1 - Badge and Entry Basics](ctfs/PSR_easy-1.md)
- [Easy 2 - Surveillance Gap Analysis](ctfs/PSR_easy-2.md)
- [Medium - Social Engineering Scenario](ctfs/PSR_medium.md)
- [Hard - Full Physical Intrusion Simulation](ctfs/PSR_hard.md)

---

Physical security is not separate from cybersecurity - it is the first layer of it. An attacker who can walk in does not need to hack in.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/Green_Expansion_v2/V2Deck/DET/Site_Walkthrough.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
