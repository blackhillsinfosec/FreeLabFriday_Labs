![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 – Weak File Permissions

You have low-privileged shell access on a Linux server as user `student`

While enumerating the system, you run:

<pre>
ls -l /etc/passwd
</pre>

Output:

<pre>
-rw-rw-r-- 1 root root 2480 /etc/passwd
</pre>

You are able to edit the file

---

## Question

Why is this a serious security issue?

---

## Flags (Choose One)

* **A)** It allows any user to reboot the system
* **B)** It allows users to add or modify system accounts
* **C)** It only affects system logging
* **D)** It has no real impact

---

Correct Flag: **B**

---

[Next Question](LPE_easy-2.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Local_Privilege_Escalation.md)
