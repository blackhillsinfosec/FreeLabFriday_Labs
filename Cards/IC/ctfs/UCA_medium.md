![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Cloud Privilege Escalation

You have access to a low-privileged cloud user account created for a junior developer

Your goal is to determine how this account can gain higher permissions

---

## Observation

The account has permission to: `iam:PassRole`

A role named `CloudAdminRole` exists in the environment

---

## Question

What **attack technique** allows escalating privileges here?

---

## Flags (Choose One)

-   **A)** Token replay
-   **B)** Role assumption
-   **C)** Lateral movement
-   **D)** Brute force

---

Correct Flag: **B**

---

# Finished?

[Next Question](UCA_hard.md)

[Back to Card's Main Page](/Cards/IC/Unauthorized_Cloud_Access.md)
