<img width="300" height="414" alt="image (11)" src="https://github.com/user-attachments/assets/8885ff22-d21d-4a71-84ad-b5e9a4452dc1" />




# Internal Spearphishing

Most phishing attacks come from outside - random emails, fake domains, obvious scams. Internal spearphishing is different. Here, the attacker already has a foot in the door. They have compromised at least one account inside the organization, and now they use it to attack everyone else.

Because the email comes from a real colleague, on a real internal mail server, it bypasses a lot of the usual filters - and people trust it.

---

## How It Works

The setup is straightforward:

- An attacker compromises one user account (through password reuse, phishing, credential theft, etc.)
- They study the victim's email history - who they talk to, what projects they work on, what their writing style looks like
- They craft a targeted email that looks completely normal - same domain, same name, maybe even a reply to an existing thread
- The target opens it, clicks a link, downloads a file, or hands over credentials
- The attacker now has a second account, then a third, and so on

This is called **lateral movement through social engineering**. Each compromised account becomes a new weapon.

The reason it works so well is context. A random phishing email asks you to reset your bank password. An internal spearphishing email looks like your manager asking you to review a shared document before a meeting you both have tomorrow.

---

## What Attackers Are After

Depending on the goal, the attack can go in different directions:

- **Credential harvesting** - fake login pages that look like internal tools (VPN, HR portal, IT ticketing)
- **Malware delivery** - attachments or links that install backdoors or keyloggers
- **Business Email Compromise (BEC)** - impersonating executives to approve wire transfers or data exports
- **Expanding access** - getting into systems the original compromised account couldn't reach

In many real-world cases, attackers stay in the email environment for weeks before doing anything obvious. They read conversations, wait for the right moment, and then strike.

---

## Known Threat Groups

Two groups are specifically linked to internal spearphishing campaigns:

**Gamaredon Group** - a Russian state-affiliated group known for targeting Ukrainian government and military organizations. They frequently use compromised accounts to send malicious documents to contacts in the victim's address book.

**Midnight Blizzard** (also known as Cozy Bear or APT29) - linked to the Russian SVR. They have been behind some of the highest-profile internal spearphishing campaigns, including attacks on government agencies and technology companies. They are known for patient, low-and-slow intrusions that can last months.

---

## How It Gets Detected

Since the email is coming from a legitimate internal account, signature-based email filters often miss it entirely. Detection usually relies on behavioral analysis:

- **SIEM Log Analysis** - correlates events across systems; an account sending 300 emails in 10 minutes at 2am is a signal worth investigating
- **Cloud Event Log Analysis** - cloud email platforms (like Microsoft 365 or Google Workspace) log every action; unusual access patterns, forwarding rules, or login locations show up here
- **User and Entity Behavior Analytics (UEBA)** - builds a behavioral baseline for each user and flags deviations; if someone who never sends attachments suddenly sends 50 in an hour, that gets flagged

None of these is a magic solution. A skilled attacker who moves slowly and mimics normal behavior is genuinely hard to catch. That is what makes this attack category so dangerous.

---

## CTF Challenges

Four challenges to test what you know:

- [Easy 1 - Suspicious Sender](ctfs/IS_easy-1.md)
- [Easy 2 - Header Hunt](ctfs/IS_easy-2.md)
- [Medium - SIEM Alert Triage](ctfs/IS_medium.md)
- [Hard - Full Campaign Reconstruction](ctfs/IS_hard.md)

---

Internal spearphishing is one of the hardest attack types to stop because it weaponizes trust. The best defenses are behavioral - knowing what normal looks like, so you can spot when something is off.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/Green_Expansion_v2/V2Deck/PE/Access_Token_Manipulation.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/Green_Expansion_v2/V2Deck/PE/SMB_Abuse.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
