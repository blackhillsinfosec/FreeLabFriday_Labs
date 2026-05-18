<img width="300" height="414" alt="image (5)" src="https://github.com/user-attachments/assets/0dda98d6-3519-4d13-84c4-bbabc692167d" />



# Malicious Email Rules

When an attacker gets into someone's email account, the first thing they usually do is not read the emails. They set up rules.

Email rules are a built-in feature of almost every mail platform. You use them yourself, maybe without thinking about it - "move newsletters to this folder", "mark anything from my boss as important". Attackers use the exact same feature, but with very different goals.

---

## What Attackers Actually Do

Once inside an account, an attacker will typically create rules that do one or more of the following:

- Move incoming emails to folders the victim never checks (like "RSS Feeds" or "Archive")
- Auto-delete emails matching certain keywords - things like "suspicious login", "password reset", "security alert"
- Forward emails silently to an external address the attacker controls
- Mark messages as read so the victim never notices something arrived

The goal is control without visibility. The victim keeps using their account normally, never knowing that certain emails are being intercepted or erased. This is especially dangerous in business contexts, where attackers use it to intercept invoices, approval requests, or communications with IT and security teams.

---

## How People End Up Here

Malicious email rules don't appear out of nowhere. They are almost always the result of a prior compromise:

- A phishing attack tricked the user into entering their credentials somewhere fake
- The account password was weak or reused from a leaked site
- The attacker had access to a device and grabbed the session token
- An OAuth app was granted access to the mailbox

Once the attacker has access - even briefly - they can configure rules that persist long after the initial entry point is closed. So even if the victim changes their password, the rules stay active.

---

## Why This Is Hard to Catch

The main problem is that rules are supposed to be there. They don't look like malware. A rule that says "move emails containing 'Your account' to Deleted Items" won't trigger an antivirus. It just looks like something the user set up.

This is why detection focuses on behavior and logs, not signatures:

- **Cloud Event Log Analysis** - Most cloud email platforms (Microsoft 365, Google Workspace) log rule creation events. If a new rule appears outside of normal working hours, from an unusual IP, or the user has no history of creating rules before - that's a signal worth investigating.
- **SIEM Log Analysis** - A Security Information and Event Management system can correlate multiple signals. For example: a login from an unusual country, followed immediately by a rule creation event, followed by forwarding being enabled. Each event alone might be ignored; together they tell a clear story.
- **Server Analysis** - On-premise mail servers expose rule data through logs and admin interfaces. Reviewing mailbox rules at the server level can catch things that users would never notice on their own.

---

## CTF Challenges

You will work through four scenarios built around this attack:

- [Easy 1 - Spot the Rule](ctfs/MER_easy-1.md)
- [Easy 2 - Forwarding Gone Wrong](ctfs/MER_easy-2.md)
- [Medium - Log the Attacker](ctfs/MER_medium.md)
- [Hard - Full Inbox Takeover](ctfs/MER_hard.md)

---

Malicious email rules are one of the quietest persistence techniques in the attacker playbook. No malware, no alerts, no noise - just a few lines of configuration that let someone watch your inbox indefinitely. Knowing how to detect them is a practical skill that comes up in real incident response, not just on exams.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/Green_Expansion_v2/V2Deck/PER/Service_Recovery_Hijacking.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/Green_Expansion_v2/V2Deck/PER/Third-Party_Malware_Injection.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
