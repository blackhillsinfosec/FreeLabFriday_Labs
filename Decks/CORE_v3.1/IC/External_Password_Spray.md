
<img width="300" height="414" alt="BNB_CARDS_v3_05" src="https://github.com/user-attachments/assets/fbe35264-6932-44d3-b3e8-969ed6569c07" />


# External Password Spray

An **external password spray** is a login attack where attackers try a small set of common passwords against many accounts from outside the organization.  
Instead of guessing many passwords for one user, they test one or two likely passwords across hundreds or thousands of users to avoid lockouts and stay quiet.

Because many organizations expose cloud login portals, VPNs, or web apps to the internet, password spraying is a common first step in real-world breaches.

---

## How Password Spraying Works

Most attacks follow a simple flow:

- The attacker finds externally accessible login portals
- Collects or guesses valid usernames
- Tries common passwords (for example seasonal or simple patterns)
- Waits between attempts to avoid detection
- Uses successful logins to access internal resources

This method works because even strong systems can fail if users reuse weak or predictable passwords.

---

## Why Attackers Use This Technique

Password spraying is popular because it is:

- Low noise compared to brute force attacks
- Easy to automate
- Effective against large user populations
- Difficult to notice without good monitoring

Once an account is compromised, attackers often move deeper into the environment, access cloud resources, or escalate privileges.

---

## How Defenders Detect It

Detection usually depends on spotting patterns rather than single failed logins. Common indicators include:

- Large numbers of failed logins across many accounts
- Login attempts from unusual locations or IP ranges
- Repeated authentication attempts with similar timing
- Sudden successful logins after many failures

Security teams often rely on SIEM analysis, behavior analytics, and cloud log monitoring to identify these patterns early.

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/initial-compromise/external-password-spray?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Identifying Spray Behavior](ctfs/EPS_easy-1.md)
- [Easy 2 – Login Pattern Analysis](ctfs/EPS_easy-2.md)
- [Medium – Detecting Low-and-Slow Sprays](ctfs/EPS_medium.md)
- [Hard – Full Attack Chain Investigation](ctfs/EPS_hard.md)
-->
---

## Labs

Hands-on labs using tools commonly associated with password spraying simulations and detection:

- [CredMaster Lab](labs/credmaster.md)
- [MSOLSpray Lab](labs/msolspray.md)
- [FireProx Lab](labs/fireprox.md)
- [FindMeAccess Lab](labs/findmeaccess.md)

---

External password spray attacks are simple but effective. Understanding how they work - and how to spot them early - is essential for both defenders and investigators.





***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/IC/Trusted_Relationship.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/IC/Insider_Threat.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
