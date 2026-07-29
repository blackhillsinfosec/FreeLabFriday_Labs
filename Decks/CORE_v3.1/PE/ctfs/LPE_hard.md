![image](/FilesForLabs/images/blueantisyphon.png)


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

[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Local_Privilege_Escalation.md)
