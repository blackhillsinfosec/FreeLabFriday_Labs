<img width="300" height="414" alt="image" src="https://github.com/user-attachments/assets/e9e93055-b8cb-4cba-9e02-d955957800b9" />




# Site Walkthrough

A **site walkthrough** is when the defenders physically go to the location being investigated. They walk through the space, inspect hardware, check logs on-site, and look for anything that does not belong - things that a remote investigation would simply miss.

It sounds basic. It is also one of the most effective things you can do when something feels off.

---

## Why Physical Presence Matters

A lot of incident response happens remotely - logs are pulled, alerts are reviewed, network traffic is analyzed. That works most of the time. But some threats live in the physical world:

- A rogue device plugged into a switch
- A wireless access point hidden behind a cabinet
- A badge reader that was tampered with
- An unlocked server room with no record of who entered

None of these show up cleanly in a SIEM. You have to go look.

---

## What Defenders Are Looking For

During a site walkthrough, the team is trying to answer a few simple questions:

- Are there devices connected to the network that should not be there?
- Are there wireless signals being broadcast that nobody authorized?
- Does the physical access trail in the logs match what actually happened?
- Is anything in the equipment stack missing, modified, or added?

The process is part investigation, part observation. You are looking for things that are out of place - even slightly.

---

## How It Usually Goes

A typical walkthrough follows this rough path:

- Review written logs before arriving - know what you are expecting to find
- Check physical ingress points - doors, badge readers, server room access
- Scan for wireless signals using a spectrum analyzer - rogue APs are common
- Inspect equipment stacks visually - look for unfamiliar hardware
- Document everything with a recording device and written notes
- Cross-reference what you found against what the logs say

The goal is not to fix anything during the walkthrough. The goal is to gather information without disturbing evidence.

---

## Common Findings

Things that get flagged during walkthroughs include:

- Raspberry Pi or similar devices plugged into switch ports
- Wireless repeaters installed without authorization
- Badge reader logs that do not match CCTV footage
- Equipment moved or missing from racks
- Physical damage or tampering on network hardware

Any of these alone could be nothing. In combination, they usually mean something.

---

## CTF Challenges

You will solve four challenges related to site walkthroughs and physical security investigations:

- [Easy 1 - Spotting the Rogue Device](ctfs/SW_easy-1.md)
- [Easy 2 - Reading the Badge Logs](ctfs/SW_easy-2.md)
- [Medium - Wireless Anomaly Hunt](ctfs/SW_medium.md)
- [Hard - Full Physical Intrusion Timeline](ctfs/SW_hard.md)

---

A site walkthrough is not glamorous work. But physical security gaps are real, they are exploited regularly, and they are almost impossible to detect without someone actually showing up and looking around.


***                                                                 
<b><i>Want to go back? </br>[Previous Card](/Decks/Green_Expansion_v2/V2Deck/DET/Physical_Security_Review.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
