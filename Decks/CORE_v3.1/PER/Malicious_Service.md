<img width="300" height="414" alt="BNB_CARDS_v3_18" src="https://github.com/user-attachments/assets/accacbce-fe23-4102-bd41-f6b45727fc13" />

# Malicious Service

A **malicious service** is a system service that an attacker has either created from scratch or modified after gaining access to a machine. The goal is simple: survive reboots and keep access alive without being noticed.

Services run in the background, start automatically, and are trusted by the operating system. That makes them one of the most effective hiding spots for attackers once they're already inside.

---

## How Attackers Get There First

You don't plant a malicious service on a machine you don't control. The service comes *after* the initial breach - it's a persistence mechanism, not an entry point.

Getting to this stage usually looks like:

- Exploiting a vulnerable application (web app, VPN, remote desktop)
- Phishing a user with enough privileges
- Credential stuffing or brute-forcing an exposed service
- Chaining multiple small vulnerabilities together

Once the attacker has a foothold, they move quickly. Planting a persistent service is often one of the first things they do.

---

## What a Malicious Service Actually Does

After installation, the service can do almost anything the OS user context allows:

- Open a reverse shell back to the attacker's server
- Drop additional tools or payloads on disk
- Exfiltrate data on a schedule
- Disable security tools
- Act as a relay point deeper into the network

The key advantage over other persistence methods is that **services are expected to be there**. A list of 200 running services is hard to audit manually, and one suspicious entry blends in easily - especially if the attacker names it something generic like `WindowsUpdateHelper` or `svchost32`.

---

## How This Gets Detected

Catching a malicious service isn't always obvious, but defenders have several angles:

- **Endpoint Security Protection Analysis** - EDR and AV tools flag unusual service binaries, unsigned executables, or services pointing to temp directories
- **Memory Analysis** - the service process might load injected code or behave differently than its binary suggests
- **Endpoint Analysis** - reviewing the service list against a known-good baseline reveals new or modified entries
- **SIEM Log Analysis** - service creation events (e.g., Windows Event ID 7045) leave traces that get correlated with other suspicious activity

The tricky part is that most of this only works if you know what *normal* looks like on that system.

---

## Tools Used in This Module

Attackers and red teamers use dedicated tools to plant and manage persistent services:

- **SharpStay** - a .NET tool for creating various persistence mechanisms including services
- **SharPersist** - similar approach, focused on Windows persistence techniques
- **StayKit** - a Cobalt Strike plugin that automates persistence setup
- **PsExec** - a legitimate sysadmin tool from Microsoft that is frequently abused to create remote services

Each of these has a lab below where you can see how they work in a controlled environment.

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/persistence/malicious-service?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Spot the Service](ctfs/MS_easy-1.md)
- [Easy 2 – Event Log Dig](ctfs/MS_easy-2.md)
- [Medium – Registry and Service Abuse](ctfs/MS_medium.md)
- [Hard – Full Persistence Chain](ctfs/MS_hard.md)
-->
---

## Labs

Hands-on walkthroughs for each tool:

- [SharpStay Lab](https://freelabfridays.com/comingsoon/)
- [SharPersist Lab](https://freelabfridays.com/labs/decks/core-v31/labs/sharpersist/)
- [PsExec Lab](https://freelabfridays.com/labs/decks/core-v31/labs/psexec/)
- **StayKit** is basically just an extension of [**SharpStay**](https://freelabfridays.com/comingsoon/)

---

Malicious services are a classic persistence technique because they work. They've been used in ransomware deployments, nation-state intrusions, and commodity malware alike. Understanding how they're built is the first step toward catching them.