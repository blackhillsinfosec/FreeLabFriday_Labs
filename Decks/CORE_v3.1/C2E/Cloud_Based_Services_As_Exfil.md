<img width="300" height="414" alt="BNB_CARDS_v3_31" src="https://github.com/user-attachments/assets/5d223717-7793-4f21-bfd4-7a1921fa75db" />


# Cloud-Based Services as Exfil

Once an attacker is inside a network, they need to get the data out. The problem for them is that moving files to some unknown server in another country tends to raise alarms fast. So instead, they use services you already trust - Google Drive, Dropbox, OneDrive, Slack, even Twitter. Traffic going to those domains looks completely normal, which makes it one of the harder exfiltration methods to catch.

This technique is called **cloud-based exfiltration**, and it is more common than most people expect.

---

## Why Cloud Services Work So Well for This

Most organizations allow cloud storage and communication tools by default. Blocking them would break legitimate work. Attackers know this.

When a compromised machine starts uploading files to Google Drive, that traffic goes out over HTTPS on port 443, to a domain your firewall likely has whitelisted. There are no obvious red flags at the network level. The data just blends in.

The key advantage for the attacker is **legitimacy by association** - the destination is trusted, so the connection is trusted.

---

## How Attackers Pull It Off

The general flow looks like this:

- Attacker already has a foothold on a machine (via malware, a shell, credentials, etc.)
- They identify sensitive files worth stealing - documents, credentials, source code, configs
- A tool or script is used to quietly stage and upload that data to a cloud service the attacker controls
- The upload happens over normal HTTPS, often in small chunks to avoid size-based alerts
- The attacker retrieves the data from their own account on the same service

Some tools even use legitimate cloud APIs, making the traffic nearly identical to a real user syncing files.

---

## What Makes This Hard to Detect

Standard firewall rules won't block it - the destination is legitimate. Volume-based alerts might miss it if the attacker is patient and uploads slowly. Even endpoint tools can be fooled if the exfil tool mimics normal application behavior.

Detection usually requires looking at patterns rather than individual connections:

- A process that does not normally use the internet suddenly making outbound API calls
- Unusual upload volumes to cloud storage at odd hours
- Endpoint telemetry showing file access followed by network activity
- SIEM correlating file reads with outbound traffic spikes

This is why the detection methods on the card lean heavily on log analysis and threat hunting rather than simple blocking.

---

## Detection Methods

**Network Threat Hunting** - Actively looking through network traffic for patterns that do not fit normal behavior, even when nothing has triggered an alert yet.

**Firewall Log Analysis** - Reviewing outbound connection logs for unusual volume, frequency, or timing to cloud service endpoints.

**Endpoint Analysis** - Looking at what processes are running, what files they are touching, and where they are sending data.

**SIEM Log Analysis** - Correlating events across multiple sources (network, endpoint, authentication) to spot exfiltration patterns that would be invisible when looking at any single log source.

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/c2-exfiltration/cloud-based-services-as-exfil?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Spot the Upload](ctfs/CBSE_easy-1.md)
- [Easy 2 – API Key in the Logs](ctfs/CBSE_easy-2.md)
- [Medium – Hunting the Exfil Channel](ctfs/CBSE_medium.md)
- [Hard – Silent Drain](ctfs/CBSE_hard.md)
-->
---

## Labs

Hands-on practice with the tools from the card:

- [Gcat Lab](https://freelabfridays.com/comingsoon/)
- [Sneaky Creeper Lab](https://freelabfridays.com/comingsoon/)
- [Gost Lab](https://freelabfridays.com/labs/decks/core-v31/c2e/labs/gost/)

---

Cloud-based exfiltration is a good example of attackers using your own infrastructure against you. The harder part is not blocking the attack - it is even noticing it happened. That is what this module is really about.
