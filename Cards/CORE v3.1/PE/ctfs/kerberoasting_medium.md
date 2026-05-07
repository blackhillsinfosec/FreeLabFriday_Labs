![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF – Offline Password Cracking

You extracted a Kerberos service ticket hash from memory and saved it to a file

After running an offline cracking tool, you get the following result:

```
sqlservice : Winter2021!
```

---

## Question

Why is this stage dangerous for defenders?

---

## Flags (Choose One)

- **A)** The attack happens entirely offline and leaves no logs
- **B)** The cracking attempt will trigger account lockouts
- **C)** The password cannot be reused
- **D)** The hash automatically expires

---

Correct Flag: **A**

---

# Finished?

[Next Question](kerberoasting_hard.md)

[Back to Card's Main Page](/Cards/IC/Kerberoasting.md)
