![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Log Digging

You are reviewing application debug logs on a compromised server. The development team left verbose logging enabled in production. You find the following entry:

```
[2024-03-14 09:22:31] DEBUG - Connecting to SMTP server
[2024-03-14 09:22:31] DEBUG - Host: mail.corp.local | Port: 587
[2024-03-14 09:22:31] DEBUG - Auth: user=notifications@corp.local password=Summer2023!
[2024-03-14 09:22:31] DEBUG - Connection successful
```

---

## Question

Which of the following best describes what an attacker would do with this information first?

---

## Flags (Choose One)

- **A)** Report the misconfiguration to the development team
- **B)** Use the credentials to log into the mail server and access internal communications
- **C)** Delete the log file to cover their tracks and stop the investigation
- **D)** Ignore it, since SMTP credentials cannot be used for anything else on the network

---

Correct Flag: **B**

---

# Finished?

[Next Question](CPF_medium.md)  
[Back to Card's Main Page](../Cleartext_Passwords_in_Files.md)
