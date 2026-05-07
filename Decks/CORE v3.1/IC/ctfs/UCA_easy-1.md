![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Suspicious Cloud Login

A SOC analyst notices a successful login to a cloud admin account
outside of normal business hours.

Your goal is to identify what makes this login suspicious.

------------------------------------------------------------------------

## Observation

Cloud audit logs show: - User: `admin@corp.local` - Login time:
`03:17 AM` - Country: `Russia` - MFA: `Not Used`

All previous logins for this user came from the local office network
during work hours.

------------------------------------------------------------------------

## Question

What **security failure** most likely allowed this access?

------------------------------------------------------------------------

## Flags (Choose One)

-   **A)** Missing MFA enforcement
-   **B)** Outdated cloud service
-   **C)** Weak firewall rules
-   **D)** Misconfigured storage bucket

------------------------------------------------------------------------

Correct Flag: **A**

------------------------------------------------------------------------

# Finished?

[Next Question](UCA_easy-2.md)

[Back to Card's Main Page](/Cards/IC/Unauthorized_Cloud_Access.md)
