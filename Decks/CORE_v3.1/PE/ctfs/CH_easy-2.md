## Credential in a Share

An attacker has gained low-level access to a workstation inside a company network. They run Snaffler to scan accessible file shares. The tool returns the following output:

```
[Share]  \\HR-SERVER\HR-General\  (Readable: YES)
[File]   \\HR-SERVER\HR-General\onboarding_template.xlsx  — INTERESTING: password
[File]   \\HR-SERVER\HR-General\new_hire_credentials.txt  — INTERESTING: plaintext creds
[File]   \\HR-SERVER\HR-General\office_map.pdf            — nothing found
```
