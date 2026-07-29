![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Credential in a Share

An attacker has gained low-level access to a workstation inside a company network. They run Snaffler to scan accessible file shares. The tool returns the following output:

```
[Share]  \\HR-SERVER\HR-General\  (Readable: YES)
[File]   \\HR-SERVER\HR-General\onboarding_template.xlsx  — INTERESTING: password
[File]   \\HR-SERVER\HR-General\new_hire_credentials.txt  — INTERESTING: plaintext creds
[File]   \\HR-SERVER\HR-General\office_map.pdf            — nothing found
```

---

## Question

Which file should the attacker prioritize and why?

---

## Flags (Choose One)

- **A)** `office_map.pdf` — it is the largest file and most likely contains hidden data
- **B)** `onboarding_template.xlsx` - spreadsheets always contain sensitive macros
- **C)** `new_hire_credentials.txt` - it is flagged as containing plaintext credentials
- **D)** None of the files — Snaffler results are unreliable and need manual verification first

---

Correct Flag: **C**

---

# Finished?
[Next Question](CH_medium.md)  
[Back to Card's Main Page](../Credential_Harvesting.md)
