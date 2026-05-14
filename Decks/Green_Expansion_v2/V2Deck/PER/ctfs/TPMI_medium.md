![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Backdoor Behavior

Your UEBA platform flags an anomaly on a build server. You pull the relevant logs:

```
[2024-03-14 03:12:44] Process: python3 | PID: 4821 | Parent: ci-runner
[2024-03-14 03:12:44] Network: 4821 -> 91.108.4.200:443 (encrypted)
[2024-03-14 03:12:45] File write: /tmp/.x11/.sock (hidden dir)
[2024-03-14 03:12:46] Cron added: */5 * * * * python3 /tmp/.x11/.sock
[2024-03-14 03:12:46] File read: ~/.ssh/id_rsa
```

The CI runner executed a build job that used a third-party Python package called `build-helpers`. No developer was logged in at the time.

---

## Question

Looking at the log sequence, which two behaviors most clearly indicate this is a backdoor establishing persistence rather than a legitimate build process?

---

## Flags (Choose One)

- **A)** The process ran as python3 and made a network connection
- **B)** The process wrote to a hidden directory and added a cron job scheduled to run every 5 minutes
- **C)** The build job ran at 3 AM and the parent process was ci-runner
- **D)** The process read an SSH key and connected to an external IP over port 443

---

Correct Flag: **B**

---

# Finished?

[Next Question](TPMI_hard.md)
[Back to Card's Main Page](../Third-Party_Malware_Injection.md)
