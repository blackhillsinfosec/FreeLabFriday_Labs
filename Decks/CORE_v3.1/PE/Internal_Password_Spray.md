<img width="300" height="414" alt="BNB_CARDS_v3_11" src="https://github.com/user-attachments/assets/e9c17db4-7c2a-42aa-b8f9-80bb7c8dd0fb" />




# Internal Password Spray

A password spray attack is when an attacker tries a small set of commonly used passwords across a large number of accounts. Instead of hammering one account with hundreds of guesses (which gets locked out fast), they go wide - one or two attempts per account, thousands of accounts.

The "internal" part matters. By the time this happens, the attacker is already inside your network. They have a foothold somewhere and are now trying to spread.

---

## Why It Works

Most organizations have at least a few users with weak passwords. Patterns like `Summer2024!` or `Welcome1` are incredibly common, and attackers know this. Combined with the fact that spraying avoids account lockouts, it becomes a low-noise, high-reward technique.

The attacker's process usually looks like this:

- They gain an initial foothold (phishing, exploited service, stolen credentials)
- They enumerate valid accounts in the domain
- They pick a handful of common passwords and spray them across every account
- They wait, then try again - slowly enough to stay under the radar
- One hit is enough to escalate access or move laterally

---

## What Makes It Dangerous

Speed and silence. A spray can run against thousands of accounts and generate very little noise if done carefully. By the time someone notices something off in the logs, the attacker may already have valid credentials for a privileged account.

It also targets something hard to fully fix: human behavior. Password policies help, but they don't stop people from choosing `Spring2024!` when the policy forces a special character and a number.

---

## How It Gets Detected

Because spraying is intentionally slow and spread out, traditional brute-force detection often misses it. The detections that actually catch it are:

- **UEBA** - looks for behavioral anomalies across accounts, like multiple accounts failing auth in the same window
- **Active Defense and Cyber Deception** - honeypot accounts with fake credentials; if anything tries to authenticate with them, that's an instant alert
- **SIEM Log Analysis** - correlating failed login events across many accounts over time
- **Endpoint Security Protection Analysis** - catching the tooling being used on the spraying machine itself

---

## CTF Challenges

Put your knowledge of the topic to the test with this online quiz!

>[!Note]
>
>You will be required to **SIGN-IN** or **[CREATE AN ACCOUNT](https://learning.antisyphontraining.com/)** on our LMS platform upon clicking!

[Take me to the CTF Quiz!](https://learning.antisyphontraining.com/learn/course/bb-ctf-labs/pivot-escalate/internal-password-spray?client=bb-box-panorama&page=2)

<!--
- [Easy 1 – Account Enumeration](ctfs/IPS_easy-1.md)
- [Easy 2 – Spray the Lab](ctfs/IPS_easy-2.md)
- [Medium – Evade the Lockout](ctfs/IPS_medium.md)
- [Hard – Full Internal Spray Campaign](ctfs/IPS_hard.md)
-->
---

## Labs

Hands-on practice with the tools from the card:

- [Kerbrute Lab](https://freelabfridays.com/comingsoon/)
- [NetExec Lab](https://freelabfridays.com/labs/decks/core-v31/pe/labs/netexec/netexec/)
- [net use Lab](https://freelabfridays.com/comingsoon/)
- [LOLBins Lab](https://freelabfridays.com/labs/decks/core-v31/pe/labs/lolbins/)

---

Password spraying is one of those techniques that feels simple on paper but causes real damage in practice. Understanding it from both sides - how it's done and how it's caught - is essential for anyone working in security.
