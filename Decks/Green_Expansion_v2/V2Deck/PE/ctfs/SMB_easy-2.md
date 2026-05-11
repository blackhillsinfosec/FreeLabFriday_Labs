![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Poisoned Network

You are reviewing SIEM alerts from the past hour. One alert stands out:

```
[ALERT] Unusual LLMNR/NBT-NS response detected
    Responding IP : 192.168.1.99
    Claimed name  : FILESERVER
    Real server   : 192.168.1.10
    Time          : 14:32:07
```

Shortly after, several workstations attempted to authenticate to 192.168.1.99.

---

## Question

What is the attacker at 192.168.1.99 most likely trying to do?

---

## Flags (Choose One)

- **A)** Perform a denial of service attack against the file server
- **B)** Intercept NTLM authentication hashes by impersonating a known network resource
- **C)** Scan the network for open SMB ports
- **D)** Brute force the administrator account on FILESERVER

---

Correct Flag: **B**

---

# Finished?
[Next Question](SMB_medium.md)
[Back to Card's Main Page](../SMB_Abuse.md)
