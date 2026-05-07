![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Suspicious Compatibility Entry

During a routine registry review, you notice a new entry under:

```
HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Custom
```

The entry references a recently created `.sdb` file located in `C:\Windows\AppPatch\Custom\`.

---

## Question

What does this most likely indicate?

---

## Flags (Choose One)

-   **A)** A custom shim database was registered
-   **B)** A Windows update was installed
-   **C)** A driver was updated
-   **D)** The firewall configuration changed

---

Correct Flag: **A**

---

# Finished?

[Next Question](AS_easy-2.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Application_Shimming.md)
