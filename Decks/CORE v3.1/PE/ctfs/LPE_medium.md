![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF – Service Abuse

On a Windows system, you enumerate services using an automated tool.

One service stands out:

* Runs as **SYSTEM**
* Binary path: `C:\Program Files\Backup Service\backup.exe`
* The directory is writable by standard users

---

## Question

What is the most effective way to escalate privileges?

---

## Flags (Choose One)

* **A)** Replace the service binary with a malicious one
* **B)** Restart the system repeatedly
* **C)** Dump LSASS directly
* **D)** Disable antivirus

---

Correct Flag: **A**

---

[Next Question](LPE_hard.md)

[Back to Card's Main Page](/Cards/PE/Local_Privilege_Escalation.md)
