![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Captured Hash

You are monitoring network traffic on a Windows corporate network. A new machine just joined the network and almost immediately you see the following in your capture:

```
[*] NTLMv2 hash captured from 192.168.1.45
    User     : CORP\jsmith
    Hash     : jsmith::CORP:aad3b435b51404ee:...
    Client   : 192.168.1.45
    Server   : 192.168.1.200
```

The destination IP (192.168.1.200) does not exist on the network.

---

## Question

Why did the machine at 192.168.1.45 send its credentials to a non-existent host?

---

## Flags (Choose One)

- **A)** The user manually typed the wrong server address
- **B)** The machine was infected with ransomware
- **C)** A poisoning tool responded to a broadcast name resolution request and redirected the authentication
- **D)** The domain controller pushed a bad Group Policy update

---

Correct Flag: **C**

---

# Finished?
[Next Question](SMB_easy-2.md)
[Back to Card's Main Page](/Cards/SMB_Abuse.md)
