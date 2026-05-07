![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 – Unusual Login Pattern

You are reviewing authentication logs from a Linux web server after a security alert.

You notice the following entries:

```
sshd[2211]: Failed password for admin from 185.22.10.4 port 49822
sshd[2211]: Failed password for admin from 185.22.10.4 port 49822
sshd[2211]: Failed password for admin from 185.22.10.4 port 49822
sshd[2230]: Accepted password for admin from 185.22.10.4 port 49822
```

The server normally only allows internal administrators to log in.

---

## Question

What is the most likely explanation?

---

## Flags (Choose One)

- **A)** A scheduled backup job logged in
- **B)** An administrator mistyped their password once
- **C)** A brute-force attack successfully guessed credentials
- **D)** Normal automated monitoring activity

---

Correct Flag: **C**

---

# Finished?

[Next Question](SA_easy-2.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Server_Analysis.md)
