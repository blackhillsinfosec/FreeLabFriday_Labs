![image](/FilesForLabs/images/blueantisyphon.png)

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

[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Local_Privilege_Escalation.md)
