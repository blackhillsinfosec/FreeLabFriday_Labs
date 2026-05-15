<img width="300" height="414" alt="image (4)" src="https://github.com/user-attachments/assets/09c398a9-e4b3-4c07-b1d5-b81b5e8f832a" />



# Service Recovery Hijacking

When a Windows service crashes, the OS does not just sit there - it follows a set of recovery instructions you can configure. Those instructions can tell Windows to restart the service, run a program, or reboot the machine. That recovery behavior is exactly what attackers target here.

**Service Recovery Hijacking** is when an attacker modifies those recovery options on an existing service so that when the service fails, their malicious code runs instead of (or alongside) whatever the legitimate recovery action was supposed to be.

---

## Why This Works

Windows services often run with elevated privileges - SYSTEM or LocalSystem in many cases. If you can attach your executable to a service's failure action, your code inherits those privileges when the service crashes.

The key part: the attacker does not need to replace the service binary itself. They just change the recovery settings, which is a much quieter operation and easier to miss.

---

## How Attackers Get Here

This technique is almost never a first step. By the time someone is doing this, they already have a foothold. The typical path looks like this:

- Initial access via phishing, exploitation, or stolen credentials
- Privilege escalation to get write access on service configurations
- Registry edits or sc.exe commands to modify the failure action of a target service
- Wait for the service to crash (or force a crash) -> payload executes

The registry key that matters is under `HKLM\SYSTEM\CurrentControlSet\Services\<ServiceName>\`. The `FailureActions` value is where the payload gets planted.

---

## What the Attacker Gains

- **Persistence** - if the service keeps crashing, the payload keeps running
- **Privilege escalation** - SYSTEM-level execution without touching the service binary
- **Stealth** - no new services created, no obvious new processes at first glance

Because the modification is inside an existing, trusted service, it can blend in with normal system behavior for a long time.

---

## Detection

Two main approaches are used to catch this:

- **Endpoint Security Protection Analysis** - looks at behavioral signals from the endpoint, including unusual process trees and unexpected child processes spawned from service recovery events
- **Endpoint Analysis** - direct inspection of service configurations, registry values, and audit logs for changes to `FailureActions` on sensitive services

Both approaches are covered in the labs and challenges below.

---

## CTF Challenges

Four challenges to test your understanding, from basic to advanced:

- [Easy 1 - Spot the Modified Service](ctfs/SRH_easy-1.md)
- [Easy 2 - Registry Investigation](ctfs/SRH_easy-2.md)
- [Medium - Tracing the Execution Chain](ctfs/SRH_medium.md)
- [Hard - Full Attack Reconstruction](ctfs/SRH_hard.md)

---

## Labs

Hands-on practice with the tool used in this technique:

- [Windows Service Recovery Actions Lab](labs/windows-service-recovery-actions.md)

---

Service Recovery Hijacking is a good example of how attackers abuse legitimate OS features rather than breaking them. The functionality is real and useful - the problem is that it can be pointed at anything. Knowing where to look and what normal recovery configurations look like is what separates a defender who catches this from one who does not.


***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/Green_Expansion_v2/V2Deck/PER/Startup_Registry_Injection.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/Green_Expansion_v2/V2Deck/PER/Malicious_Email_Rules.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
