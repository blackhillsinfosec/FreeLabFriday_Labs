![image](/FilesForLabs/images/blueantisyphon.png)

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

[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Local_Privilege_Escalation.md)
