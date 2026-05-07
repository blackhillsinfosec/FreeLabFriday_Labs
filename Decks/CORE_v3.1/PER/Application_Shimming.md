<img width="300" height="414" alt="BNB_CARDS_v3_22" src="https://github.com/user-attachments/assets/20b07626-0ffe-40fc-8f7f-edbefbf45fb6" />


# Application Shimming

Application shimming is a Windows technique that was originally created for compatibility. It allows software to run even if it was built for older versions of the operating system.

Attackers abuse this same feature to hide activity and evade detection.

Instead of changing the target application directly, they insert a “shim” layer between the application and the operating system. This layer can intercept system calls and modify what the application sees.

For example, a shim can:

- Hide specific files or directories  
- Hide running services  
- Hide open ports  
- Redirect API calls  
- Change how the application behaves  

Because this mechanism is built into Windows, it often blends in with legitimate system behavior.

---

## Why This Matters

Shimming is commonly used for **defense evasion**.

An attacker who already has access to a machine may use shims to:

- Prevent security tools from seeing certain files  
- Hide malicious services  
- Mask persistence mechanisms  
- Avoid detection during incident response  

This makes post-compromise investigation more difficult. The system may look clean from a normal user perspective, while the malicious components remain hidden underneath.

---

## How Attackers Get to This Point

Application shimming is rarely the first step of an attack.

Typically, the path looks like this:

- Initial access (phishing, exploit, stolen credentials)  
- Privilege escalation  
- Persistence setup  
- Defense evasion using shims  

Once administrative privileges are obtained, attackers can register custom shim databases and load them into the system.

---

## How It Is Detected

Shimming activity can be discovered through:

- Endpoint security monitoring  
- Registry analysis  
- Suspicious `.sdb` files  
- Memory analysis  
- Unusual use of compatibility tools  

Because legitimate administrators may also use compatibility features, context matters.

---

## CTF Challenges

You will complete four challenges focused on identifying and abusing application shimming techniques:

- [Easy 1 – Suspicious Compatibility Entry](ctfs/AS_easy-1.md)  
- [Easy 2 – Hidden File Trick](ctfs/AS_easy-2.md)  
- [Medium – Malicious Shim Database](ctfs/AS_medium.md)  
- [Hard – Full Defense Evasion Scenario](ctfs/AS_hard.md)  

---

## Labs

Hands-on practice with tools related to this technique:

- [Metasploit Lab](labs/metasploit.md)  
- [PowerShell Lab](labs/powershell.md)  
- [Shim Generator (shimgen) Lab](labs/shimgen.md)  
- [sdb-explorer Lab](labs/sdb-explorer.md)
- [Atomic Red Team Lab](labs/atomic-red-team.md)

---

Application shimming shows how built-in operating system features can be abused.  
Understanding it helps you recognize when normal functionality is being used in abnormal ways.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/PER/Malicious_Browser_Plugins.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/PER/New_User_Added.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
