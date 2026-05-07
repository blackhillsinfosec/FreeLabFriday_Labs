<img width="300" height="414" alt="BNB_CARDS_v3_41" src="https://github.com/user-attachments/assets/d5b3beac-734b-43ff-b015-98dfc3e274f3" />




# Isolation

When a system gets compromised, the first instinct is to pull the plug. That instinct is right - but the execution matters a lot. Isolation is the act of cutting a compromised system or network segment off from everything else, fast enough to stop the spread, but carefully enough to preserve evidence.

Done wrong, attackers keep moving. Done right, you contain the damage and buy time to investigate.

---

## What Isolation Actually Means

Isolation does not mean turning the machine off. It means severing its ability to communicate while keeping it alive for forensics.

A properly isolated system:

- Cannot reach the internet or internal network
- Cannot be reached by other hosts
- Is still running, so you can collect logs, memory, and processes
- Is still accessible to you through a controlled channel (like a management VLAN or EDR console)

The goal is to stop lateral movement and data exfiltration without destroying the evidence you need.

---

## Why Attackers Depend on Free Movement

Most real-world intrusions are not single-system events. Attackers compromise one machine and use it to reach others - this is called lateral movement.

If you do not isolate quickly:

- Credentials stolen from one host get used on others
- Malware spreads through shared drives or services
- The attacker establishes persistence on multiple systems
- Evidence gets wiped or overwritten remotely

Isolation breaks this chain. It forces the attacker to work with what they already have instead of expanding.

---

## How Isolation Is Applied

Depending on the situation, isolation can happen at different layers:

**Network level** - a switch or router drops traffic from the affected device, either by disabling the port, removing it from a VLAN, or applying an ACL that blocks all traffic.

**Host level** - the firewall on the compromised machine itself is reconfigured to block inbound and outbound connections, except for specific management traffic.

**Endpoint level** - EDR tools can push an isolation command remotely, which activates containment on the agent without anyone touching the machine physically.

In most SOC environments, the EDR route is the fastest and most reliable one.

---

## What Happens During Isolation

Isolation is not the end of the process. It is the beginning of a controlled response:

- Logs and memory are collected from the isolated system
- Active connections and running processes are documented
- The scope of the compromise is assessed (what else did this host talk to?)
- Remediation is planned before the system is restored to the network

Restoring a system before the root cause is understood is one of the most common mistakes in incident response.

---

## CTF Challenges

You will solve four challenges related to network isolation and containment:

- [Easy 1 – Blocked but Not Gone](ctfs/ISO_easy-1.md)
- [Easy 2 – Firewall Rule Reconstruction](ctfs/ISO_easy-2.md)
- [Medium – Lateral Movement Interrupted](ctfs/ISO_medium.md)
- [Hard – Containment Under Fire](ctfs/ISO_hard.md)

---

Isolation is a time-sensitive decision. The longer a compromised host stays connected, the more damage compounds. Understanding how to apply it quickly and correctly - at the network, host, or endpoint level - is one of the most practical skills you can build as a defender.

***                                                                 
<b><i>Continuing the course? </br>[Next Card](/Decks/CORE_v3.1/DET/Crisis_Management.md)</i></b>

<b><i>Want to go back? </br>[Previous Card](/Decks/CORE_v3.1/DET/Endpoint_Analysis.md)</i></b>

<b><i>Looking for a different Card? </br>[Card Directory](/card_navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/labdestruction.md)

---
