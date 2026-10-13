## Containment Under Fire

You are the on-call SOC analyst at 02:30. An EDR alert fires on a domain controller (DC01). You begin investigating and collect the following data points within the first five minutes:

- DC01 has active connections to 14 internal hosts over WinRM (port 5985)
- A scheduled task named `SvcHostUpdate` was created 22 minutes ago, running a PowerShell encoded command
- DC01's EDR agent is installed but the isolation command fails — the agent returns: `Containment error: policy override active`
- The attacker appears to still be active; new authentication events are appearing every 30-40 seconds
- You have access to the managed switch and can disable DC01's trunk port, but this will cut domain authentication for the entire office
