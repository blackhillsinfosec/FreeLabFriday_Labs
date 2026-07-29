![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Registry Trail

You are investigating a compromised machine. The user says something feels off every time they log in, but nothing obvious shows on the desktop.

You run a registry query and find the following:

```
HKCU\Environment
  UserInitMprLogonScript = \\10.10.10.5\share\init.vbs
```

The IP `10.10.10.5` does not belong to any known internal server.

---

## Question

What should you conclude from this registry entry?

---

## Flags (Choose One)

- **A)** The machine is pulling a script from an unknown external host at every login
- **B)** The registry entry is a default Windows configuration for roaming profiles
- **C)** A scheduled task is running a backup job to a network share
- **D)** The script is part of a Group Policy push from the domain controller

---

Correct Flag: **A**

---

# Finished?
[Next Question](LS_medium.md)  
[Back to Card's Main Page](../Logon_Scripts.md)
