![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


# Hard CTF – Chained Escalation

You have a low-privileged shell on a Linux server.

Enumeration reveals:

* A writable script executed by a root cron job
* The script calls `tar` without using an absolute path
* Your user controls the `PATH` variable

---

## Question

What technique allows you to escalate privileges?

---

## Flags (Choose One)

* **A)** Kernel exploitation
* **B)** PATH hijacking
* **C)** Password spraying
* **D)** SQL injection

---

Correct Flag: **B**

---

[Back to Card's Main Page](/Cards/PE/Local_Privilege_Escalation.md)
