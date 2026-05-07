<img width="300" height="414" alt="BNB_CARDS_v3_23" src="https://github.com/user-attachments/assets/31ce9023-f278-45c7-9ba4-4231c460e663" />





# Malicious Browser Plugins

Browser plugins - also called extensions - are small pieces of software that add functionality to your browser. They can do a lot of useful things, like blocking ads or managing passwords. But that same level of access is exactly what makes them dangerous when they are malicious.

A malicious browser plugin is one that has been designed or tampered with to execute code on the victim's machine, steal data, or help an attacker maintain access to a compromised environment - all while looking completely harmless to the user.

---

## How Attackers Get Plugins onto a System

Unlike most malware, a browser plugin does not need to exploit an OS-level vulnerability to get installed. There are several ways this can happen:

- A user is tricked into installing a fake or trojanized extension (phishing, typosquatting on extension stores, or bundled with other software)
- An attacker who already has some level of access pushes the extension silently via PowerShell or enterprise policy abuse
- A legitimate extension gets acquired or compromised, and a malicious update is pushed to existing users
- The attacker abuses browser sync features to propagate the extension across devices

Once installed, most users never question it. Extensions run in the background with little visibility.

---

## What a Malicious Plugin Can Actually Do

This is where it gets serious. Browser extensions sit in a privileged position - they can read everything you type, see every page you visit, modify web content on the fly, and make network requests. A well-written malicious extension can:

- Capture credentials as they are typed into login forms
- Intercept session cookies and relay them to an attacker (session hijacking)
- Modify banking pages to redirect transactions
- Act as a persistent foothold that survives reboots
- Communicate with a command-and-control server while blending in with normal browser traffic
- Bypass MFA by stealing tokens directly from authenticated sessions

Some of these attacks are nearly invisible to the victim. The page looks right, the login worked, nothing seems wrong.

---

## How These Are Detected

Because the plugin lives inside the browser, traditional endpoint tools sometimes miss it. Detection usually comes from a combination of sources:

- **Endpoint Security Protection Analysis** - some EDR and AV solutions can flag suspicious extensions or unusual browser process behavior
- **Endpoint Analysis** - manually reviewing installed extensions, browser profiles, and startup items
- **Firewall Log Analysis** - malicious plugins often beacon out to external C2 infrastructure; unusual outbound connections from browser processes can surface this
- **Memory Analysis** - in more advanced cases, analysts pull browser memory to find injected code or live credentials that have not yet been exfiltrated

In practice, these compromises are frequently caught late - often only after credentials have already been stolen.

---

## Tools Associated with This Attack

The tools listed on this card are used both by attackers and by red teamers simulating this attack pattern:

- **Metasploit** - exploitation framework used to gain initial access or generate payloads that can be delivered through a browser
- **PowerShell** - commonly used to silently install extensions via command line, especially in Windows enterprise environments
- **Chromebackdoor** - a tool specifically designed to create malicious Chrome extensions with backdoor capabilities
- **Browser Exploitation Framework (BeEF)** - hooks browsers and allows an attacker to run commands inside the browser context, pivoting through the victim's session
- **Evilginx** - a reverse proxy framework used for phishing with real-time credential and session token interception, often paired with browser-based persistence

---

## CTF Challenges

Four challenges to test your understanding of this attack vector:

- [Easy 1 – Suspicious Extension](ctfs/MBP_easy-1.md)
- [Easy 2 – Stolen Cookie](ctfs/MBP_easy-2.md)
- [Medium – BeEF Hooked Session](ctfs/MBP_medium.md)
- [Hard – Full Plugin Compromise Chain](ctfs/MBP_hard.md)

---

## Labs

Hands-on exercises with the tools from the card:

- [Metasploit Lab](labs/metasploit.md)
- [PowerShell Lab](labs/powershell.md)
- [BeEF Lab](labs/beef.md)
- [Evilginx Lab](labs/evilginx.md)

---

Malicious browser plugins are a good example of how attackers move up the stack - instead of breaking into the OS, they compromise the application layer where users spend most of their time. The access they get is limited in scope but extremely high in value. Knowing how they work is half the battle in detecting and stopping them.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Cards/PER/Logon_Scripts.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Cards/PER/Application_Shimming.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
