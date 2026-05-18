<img width="300" height="414" alt="BNB_CARDS_v3 1_6" src="https://github.com/user-attachments/assets/e5b4047c-db37-48b7-91e0-664282afa56c" />


# Trusted Relationship

A **trusted relationship** issue happens when attackers abuse access that already exists between an organization and a third party - for example a vendor, contractor, or partner. Instead of breaking in directly, they use a trusted account or connection to enter the environment.

These accounts often have service-level privileges and are expected to behave normally, which makes abuse harder to spot.

---

## How Attackers Take Advantage of Trusted Relationships

Most attacks follow a simple pattern:

- The attacker compromises a third-party organization first
- Gains access to a service account or integration used by the target
- Uses that trusted access to log in without triggering obvious alerts
- Moves through systems while appearing legitimate

Common paths include:

- Stolen vendor credentials
- Weak controls around service accounts
- Overly broad permissions granted to partners
- Reused or unmanaged API keys
- Lack of monitoring on third-party activity

The key idea: the trust itself becomes the vulnerability.

---

## What Happens After Access Is Gained

Once inside through a trusted channel, attackers may:

- Access internal systems without exploiting new vulnerabilities
- Collect sensitive data quietly
- Move laterally using existing permissions
- Blend in with normal operational traffic
- Maintain long-term access through service accounts

Because activity looks legitimate, detection often takes longer than in traditional intrusions.

---

## How These Incidents Are Detected

Trusted relationship abuse is usually discovered through behavior and visibility rather than obvious exploits:

- SIEM log correlation showing unusual account behavior
- User and Entity Behavior Analytics (UEBA) identifying anomalies
- Firewall logs revealing unexpected communication patterns
- Cloud event logs showing suspicious API or account actions
- Permission audits exposing excessive or unused access

Detection depends heavily on understanding what “normal” third-party activity looks like.

---

## CTF Challenges

You will complete four challenges focused on trusted relationship abuse:

- [Easy 1 – Suspicious Vendor Login](ctfs/TR_easy-1.md)
- [Easy 2 – Service Account Misuse](ctfs/TR_easy-2.md)
- [Medium – Partner Pivot Scenario](ctfs/TR_medium.md)
- [Hard – Supply Chain Access Abuse](ctfs/TR_hard.md)

---

## Labs

Hands-on labs based on the tools from this card:

- [Gato-X Lab](labs/gato-x.md)

---

Trusted relationships are necessary for modern organizations, but they expand the attack surface. Learning how attackers abuse trust - and how defenders detect subtle misuse - is a core skill in modern defensive security.





***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/IC/Social_Engineering.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/IC/External_Password_Spray.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
