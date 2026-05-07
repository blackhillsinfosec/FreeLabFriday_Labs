![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 – First Interaction with a Decoy

You are reviewing alerts from a deception platform.

A fake SSH server was deployed inside the network. It is not used by any real employees.

The alert shows:

```
Source IP: 10.10.22.45
Destination: decoy-ssh.internal
Action: Successful login attempt
Username: admin
Password: admin123
```

No legitimate automation or users should ever connect to this system.

---

## Question

What does this alert most likely indicate?

---

## Flags (Choose One)

- **A)** A system administrator ran a normal maintenance task
- **B)** An attacker or unauthorized user interacted with a decoy
- **C)** The deception server failed to start correctly
- **D)** The SSH service automatically tested itself

---

Correct Flag: **B**

---

# Finished?

[Next Question](ADCD_easy-2.md)

[Back to Card's Main Page](/Cards/DET/Active_Defense_And_Cyber_Deception.md)
