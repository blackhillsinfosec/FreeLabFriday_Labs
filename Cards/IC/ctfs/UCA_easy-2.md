![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Exposed API Key

A developer pushed a project to a public repository. While reviewing the
files, you suspect sensitive cloud credentials were exposed.

Your goal is to identify the risky mistake.

---

## Observation

Inside a configuration file you find:

`CLOUD_API_KEY=AKIAIOSFODNN7EXAMPLE`

The repository is public and indexed by search engines.

---

## Question

What **security issue** does this represent?

---

## Flags (Choose One)

-   **A)** Insecure deserialization
-   **B)** Credential leakage
-   **C)** Privilege escalation
-   **D)** Broken access control

---

Correct Flag: **B**

---

# Finished?

[Next Question](UCA_medium.md)

[Back to Card's Main Page](/Cards/IC/Unauthorized_Cloud_Access.md)
