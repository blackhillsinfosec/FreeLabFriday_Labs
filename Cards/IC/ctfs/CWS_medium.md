![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF – Post-Exploitation

An attacker exploited a vulnerable web application and obtained a shell as the user `www-data`.

After some enumeration, they discover:

- `sudo` is installed
- A script called `backup.sh` can be run with sudo without a password
- The script calls `/bin/tar` without using a full path

---

## Question

What is the most likely next step for the **attacker**?

---

## Flags (Choose One)

- **A)** Dump the web database
- **B)** Perform a PATH hijacking attack
- **C)** Run a DDoS attack
- **D)** Deface the website

---

Correct Flag: **B**

---

# Finished?

[Next Question](CWS_hard.md)

[Back to Card's Main Page](/Cards/IC/Compromised_Web_Server.md)
