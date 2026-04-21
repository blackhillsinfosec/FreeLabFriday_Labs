![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 – Misconfigured Sudo

You gain access to a server as a regular user

Running the following command:

```
sudo -l
```

You see:

```
(ALL) NOPASSWD: /usr/bin/nano
```

---

## Question

Why does this configuration allow privilege escalation?

---

## Flags (Choose One)

* **A)** Nano can be used to edit system files as root
* **B)** Nano exposes the kernel to exploits
* **C)** Nano automatically spawns a root shell
* **D)** This configuration is safe

---

Correct Flag: **A**

---

[Next Question](LPE_medium.md)

[Back to Card's Main Page](/Cards/PE/Local_Privilege_Escalation.md)
