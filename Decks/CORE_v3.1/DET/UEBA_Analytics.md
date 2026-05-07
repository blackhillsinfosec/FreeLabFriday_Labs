<img width="300" height="414" alt="BNB_CARDS_v3_39" src="https://github.com/user-attachments/assets/6de13976-f05f-4e32-a2fb-c9dbc74810b3" />




# User And Entity Behavious(UEBA) Analytics


Most security tools work by matching known bad things - a signature, a rule, a hash. UEBA works differently. It watches how people and systems normally behave, and flags when something stops making sense.

That shift matters. Attackers are good at avoiding signatures. They're not as good at acting like the people they're impersonating.

---

## What UEBA Actually Tracks

The "entity" part gets overlooked. UEBA is not just about users - it also monitors:

- Servers and workstations
- Service accounts
- Applications and processes

A service account that suddenly starts reading files it has never touched, or a user logging in from two countries within an hour, shows up as an anomaly. No signature needed.

---

## The Threats It's Built For

UEBA exists because some threats are nearly invisible to traditional tools:

**Insider threats** - a legitimate employee misusing access. No exploit, no malware. Just someone doing things they shouldn't.

**Compromised accounts** - an attacker using stolen credentials. From the network's perspective, it looks like a normal login.

**Unusual activity patterns** - privilege escalation, lateral movement, data staging. Each step might look harmless on its own. Behavior analytics connects the dots.

---

## How the Detection Works

The engine builds a baseline for every user and entity. What hours do they log in? What systems do they access? How much data do they move?

Once the baseline is solid, deviations get scored. A small deviation scores low. A pattern of deviations - especially ones that resemble known attack sequences - scores high enough to trigger an alert.

This is what makes UEBA useful: it catches things that don't match a rule, because the rule is the person's own behavior.

---

## Where It Fits in the SOC

UEBA is not a replacement for a SIEM. It feeds into it. The alerts it generates are higher quality than raw log alerts - they already have context, a risk score, and a timeline.

For a defender, this means less noise and more signal. Instead of chasing hundreds of low-fidelity alerts, you investigate the five accounts that deviated the most this week.

---

## CTF Challenges

Four challenges, each one tied to a real UEBA scenario:

- [Easy 1 – Spot the Anomalous Login](ctfs/UEBA_easy-1.md)
- [Easy 2 – Service Account Gone Wrong](ctfs/UEBA_easy-2.md)
- [Medium – Insider Threat Investigation](ctfs/UEBA_medium.md)
- [Hard – Full Behavioral Attack Chain](ctfs/UEBA_hard.md)

---

## Labs

One lab per tool. Each one is hands-on and self-contained:

- [LogonTracer Lab](labs/logontracer.md)
- [DeepBlueCLI Lab](labs/deepbluecli/deepbluecli.md)
- [OpenUBA Lab](labs/openuba.md)
- [Hayabusa Lab](labs/hayabusa.md)

---

Behavior doesn't lie the way logs can. An attacker can delete a file - they can't easily fake two years of normal login patterns. That's the core idea behind UEBA, and it's why it catches what everything else misses.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/DET/Endpoint_Analysis.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/DET/Endpoint_Security_Protection_Analysis.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
