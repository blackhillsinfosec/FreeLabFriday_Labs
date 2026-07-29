![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Reading the Map

You are a junior analyst reviewing endpoint logs. A workstation on the network ran the following command:

```
net group "Domain Admins" /domain
```

Seconds later, the same host ran:

```
net user /domain
```

No admin tasks were scheduled on this machine. The user account on the workstation is a standard employee account.

---

## Question

What is the attacker most likely doing at this stage?

---

## Flags (Choose One)

- **A)** Enumerating domain users and admin group members
- **B)** Attempting to log in to a remote machine
- **C)** Installing malware on the Domain Controller
- **D)** Clearing event logs to hide their presence

---

Correct Flag: **A**

---

# Finished?
[Next Question](WAD_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Weaponizing_Active_Directory.md)
