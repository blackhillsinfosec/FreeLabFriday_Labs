![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)
# Hard CTF - Containment Under Fire

You are the on-call SOC analyst at 02:30. An EDR alert fires on a domain controller (DC01). You begin investigating and collect the following data points within the first five minutes:

- DC01 has active connections to 14 internal hosts over WinRM (port 5985)
- A scheduled task named `SvcHostUpdate` was created 22 minutes ago, running a PowerShell encoded command
- DC01's EDR agent is installed but the isolation command fails — the agent returns: `Containment error: policy override active`
- The attacker appears to still be active; new authentication events are appearing every 30-40 seconds
- You have access to the managed switch and can disable DC01's trunk port, but this will cut domain authentication for the entire office

---

## Question

Given that EDR isolation has failed, what is the most appropriate next action?

---

## Flags (Choose One)

- **A)** Reboot DC01 to force the EDR agent to reload and retry the isolation command
- **B)** Disable DC01's trunk port on the managed switch, accepting the disruption to domain authentication, to stop active lateral movement
- **C)** Wait for the attacker to complete their activity before isolating, to gather more evidence without alerting them
- **D)** Isolate only the 14 hosts connected to DC01 over WinRM and leave DC01 online to monitor the attacker

---

Correct Flag: **D**

---

# Finished?
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Isolation.md)
[Return to Card Directory](/card_navigation.md)
