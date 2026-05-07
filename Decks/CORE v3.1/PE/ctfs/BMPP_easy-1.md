![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Capturing a Hash

You are on a penetration test inside a corporate Windows network. You run Responder on your machine and wait. A few minutes later, you see the following output in your terminal:

```
[*] [LLMNR] Poisoned answer sent to 192.168.1.45 for name FILESERV01
[*] [SMB] NTLMv2-SSP Client   : 192.168.1.45
[*] [SMB] NTLMv2-SSP Username : CORP\jsmith
[*] [SMB] NTLMv2-SSP Hash     : jsmith::CORP:4a3b1c...<truncated>
```

---

## Question

What happened after Responder answered the LLMNR query?

---

## Flags (Choose One)

- **A)** The victim's machine was fully compromised
- **B)** Responder blocked the victim from accessing the real file server
- **C)** The victim's machine sent its NTLMv2 authentication hash to the attacker
- **D)** The attacker gained direct access to jsmith's account

---

Correct Flag: **C**

---

# Finished?
[Next Question](BMPP_easy-2.md)  
[Back to Card's Main Page](../Broadcast-Multicast_Protocol_Poisoning.md)
