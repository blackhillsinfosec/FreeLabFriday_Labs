<img width="300" height="414" alt="BNB_CARDS_v3_44" src="https://github.com/user-attachments/assets/4265f6f5-a6a9-4e42-bdd9-fd9b0437543f" />





# Cloud Event Log Analysis

Cloud systems generate logs for everything - logins, API calls, file access, configuration changes, network connections. When something goes wrong, those logs are often the only record of what happened.

As a defender, your job is to collect those logs, make sense of them, and catch threats before they cause serious damage.

---

## What Are Cloud Event Logs?

Every time a user logs into a cloud console, spins up a VM, or modifies a firewall rule, the cloud platform records it. These records are called **event logs**.

They typically include:

- Who did something (user, service account, IP address)
- What they did (action or API call)
- When it happened (timestamp)
- Whether it succeeded or failed

On AWS this comes through CloudTrail. On Azure, it's Azure Monitor and Activity Logs. On GCP, it's Cloud Audit Logs. All different names, same concept.

---

## Why Attackers Love the Cloud

Cloud environments are attractive targets for a few reasons:

- They're accessible from anywhere, which means attackers are too
- Misconfigurations are extremely common (an open S3 bucket, a permissive IAM role, MFA not enforced)
- Resources scale automatically - an attacker can spin up crypto miners and the bill goes to you
- Credentials stolen from one place often work in many others

The most common entry points are stolen API keys, phishing, and exposed services with weak or no authentication.

---

## What Attacks Look Like in Logs

Once an attacker is in, they usually follow a pattern:

1. **Reconnaissance** - they list resources, check what permissions they have, explore the environment
2. **Privilege escalation** - they try to get admin access or assume higher-privilege roles
3. **Persistence** - they create backdoor accounts, API keys, or scheduled tasks
4. **Impact** - data exfiltration, ransomware, cryptomining, or destroying resources to cover tracks

In logs, this shows up as things like: failed API calls in bulk, new admin users created at odd hours, large data downloads, unusual regions being accessed, or IAM policies being modified.

---

## How Defenders Find It

You're looking for things that don't fit the normal pattern. That means you need to know what *normal* looks like first.

Common detection approaches:

- **Baseline and alert** - define what normal activity looks like, flag deviations
- **Rule-based detection** - specific patterns like "root login from foreign IP" or "IAM role modified outside business hours"
- **Log correlation** - connecting events across services to see the full picture
- **Threat intelligence** - matching IPs, domains, or behaviors against known attacker infrastructure

The tools listed on this card all help you do one or more of these things.

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/detections/cloud-event-log-analysis?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Suspicious Login](ctfs/CELA_easy-1.md)
- [Easy 2 – Noisy API](ctfs/CELA_easy-2.md)
- [Medium – Privilege Escalation Trail](ctfs/CELA_medium.md)
- [Hard – Full Cloud Intrusion](ctfs/CELA_hard.md)
-->
---

## Labs

Hands-on with the tools from the card:

- [Wazuh Lab](labs/Wazuh/wazuh.md)
- [Security Onion Lab](labs/security-onion.md)
- [Graylog Open Lab](labs/graylog.md)
- [Falco Lab](labs/falco.md)

---

Cloud logs don't lie - but they won't speak up on their own. The work is in knowing what to look for and building systems that surface it fast enough to matter.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/DET/Permissions_Audit.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/DET/Memory_Analysis.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
