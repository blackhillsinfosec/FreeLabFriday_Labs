<img width="300" height="414" alt="BNB_CARDS_v3_32" src="https://github.com/user-attachments/assets/d1fa7c20-9dba-4643-8137-bb6b0d004399" />


# Domain Fronting as C2

Once an attacker has a foothold inside a network, they need a way to communicate with their tools remotely. That communication channel is called **Command and Control**, or C2. The problem is that firewalls and network monitors are watching for suspicious outbound traffic. So attackers hide their C2 traffic inside connections that look completely normal.

Domain fronting is one of the cleaner ways to do that.

---

## What Is Domain Fronting

The idea is simple. Big cloud providers and CDNs (Content Delivery Networks) like Cloudflare, AWS CloudFront, or Azure serve thousands of legitimate domains. When your browser connects to one of them, the actual destination is hidden inside an encrypted HTTPS request.

Here is what happens:

- The attacker sets up their C2 server behind a CDN
- The victim machine makes an HTTPS request that *looks* like it is going to a trusted domain (say, `legit-company.com`)
- But inside the encrypted request, the `Host` header points somewhere else entirely — the attacker's server
- The CDN forwards it without the network seeing the real destination

From the outside, you just see traffic going to a legitimate CDN. The real C2 communication is tucked inside.

---

## Why It Works

Blocking CDN traffic is not really an option for most organizations. Stripe, Microsoft 365, countless SaaS tools — they all live behind CDNs. So defenders are left in a tough spot.

The attacker's traffic blends in with business-critical traffic. No weird domains, no suspicious IPs, often no obvious pattern. This is what makes domain fronting particularly nasty as a C2 technique — it abuses infrastructure that defenders *need* to keep open.

---

## How Defenders Catch It

It is not impossible to detect, but it requires looking closer than most teams do by default.

**Network Threat Hunting** means actively going through traffic logs looking for anomalies — unusual request frequencies, odd timing, connections that talk to CDN nodes but never load anything a browser would. If a workstation is beaconing to Cloudflare every 30 seconds, that is worth investigating.

**Firewall Log Analysis** can surface mismatches between the SNI (the domain visible in TLS handshakes) and the actual Host header inside the request. Some next-gen firewalls can inspect this. When they differ in a suspicious way, that is a signal.

**SIEM Log Analysis** ties it together. By aggregating logs from firewalls, DNS, proxies, and endpoints, a SIEM can spot patterns over time — unusual volumes, repeated beaconing intervals, or traffic to CDN endpoints that your inventory has no legitimate reason to use.

---

## Tools Attackers Use

Three frameworks commonly seen with domain fronting:

- **Sliver** — open source C2 framework with built-in support for redirectors and domain fronting profiles
- **Havok** — newer C2 framework designed with evasion in mind, often seen in red team engagements
- **Mythic** — modular C2 platform that supports various transport options including HTTP/S through CDNs

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/c2-exfiltration/domain-fronting-as-c2?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Spot the Front](ctfs/DF_easy-1.md)
- [Easy 2 – Log Analysis Basics](ctfs/DF_easy-2.md)
- [Medium – Hunting the Beacon](ctfs/DF_medium.md)
- [Hard – Full C2 Takedown](ctfs/DF_hard.md)
-->
---

## Labs

Hands-on time with the tools from the card:

- [Sliver Lab](labs/sliver.md)
- [Havok Lab](labs/havok.md)
- [Mythic Lab](labs/mythic.md)

---

Domain fronting is a good example of how attackers do not always break things — sometimes they just use existing infrastructure in ways it was not designed to prevent. Understanding the technique is the first step to catching it.


***                                                                 
<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/C2E/Cloud_Based_Services_As_Exfil.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
