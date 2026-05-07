![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Log Pattern Analysis

You are going through firewall logs after an endpoint protection alert fired on a machine in the accounting department.

You notice the following entries over 30 minutes:

```
14:02:11  OUTBOUND  192.168.2.10:52341 -> 91.107.56.33:443   2.1 KB sent
14:07:11  OUTBOUND  192.168.2.10:52342 -> 91.107.56.33:443   2.3 KB sent
14:12:10  OUTBOUND  192.168.2.10:52343 -> 91.107.56.33:443   2.0 KB sent
14:17:11  OUTBOUND  192.168.2.10:52344 -> 91.107.56.33:443   2.2 KB sent
14:22:12  OUTBOUND  192.168.2.10:52345 -> 91.107.56.33:443   2.1 KB sent
```

The machine's user was on lunch break during this entire window. No browser or known application was open.

---

## Question

What does the consistent small payload size combined with the user being away most likely suggest?

---

## Flags (Choose One)

- **A)** A background Windows update was running
- **B)** The firewall is logging duplicate entries by mistake
- **C)** A user accidentally left a file sync running
- **D)** A process on the machine is automatically sending data without user interaction

---

Correct Flag: **D**

---

# Finished?
[Next Question](HE_medium.md)  
[Back to Card's Main Page](/Cards/C2E/HTTPS_As_Exfil.md)
