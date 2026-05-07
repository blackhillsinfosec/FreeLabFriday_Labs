![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Wrong Place, Right Name

A developer reports that after installing a new application, something feels off. You inspect the application folder and find this:

```
C:\Program Files\LegitApp\
    LegitApp.exe
    version.dll        <- placed here by unknown source
    
C:\Windows\System32\
    version.dll        <- the real one
```

The application loads `version.dll` at startup and does not use an absolute path.

---

## Question

Why is the `version.dll` inside the application folder a security concern?

---

## Flags (Choose One)

- **A)** The real DLL in System32 is corrupted and needs replacing
- **B)** DLLs should never be stored in Program Files
- **C)** Windows will load the DLL in the application folder before the one in System32
- **D)** The application folder requires admin rights to read from

---

Correct Flag: **C**

---

# Finished?
[Next Question](DLL_easy-2.md)  
[Back to Card's Main Page](../Dynamic_Link_Library_Hijacking.md)
