![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Spot the Suspicious Driver

A junior analyst is reviewing the list of installed drivers on a Windows endpoint that triggered an alert. The system looks clean at first glance, but one entry stands out:

```
Driver Name:    sysmon64.sys
Display Name:   System Monitor
Start Type:     Boot
Signature:      Unsigned
Path:           C:\Windows\System32\drivers\sysmon64.sys
```

Everything else on the system is properly signed by Microsoft or known vendors.

---

## Question

What is the most significant red flag in this entry?

---

## Flags (Choose One)

- **A)** The driver is located in the System32 folder
- **B)** The driver is unsigned despite having a trusted-looking name
- **C)** The driver uses a Boot start type
- **D)** The display name contains the word "Monitor"

---

Correct Flag: **B**

---

# Finished?
[Next Question](MDR_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Driver.md)
