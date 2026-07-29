![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Missing DLL Hunt

You are analyzing a process monitor log captured on a workstation. You notice the following entries:

```
[09:14:22]  LegitApp.exe  ->  SearchOrder: C:\Users\john\Downloads\helper.dll  ->  NOT FOUND
[09:14:22]  LegitApp.exe  ->  SearchOrder: C:\Windows\System32\helper.dll      ->  NOT FOUND
[09:14:22]  LegitApp.exe  ->  SearchOrder: C:\Windows\helper.dll               ->  NOT FOUND
```

The next day, after a complaint about slow performance, you run the same capture:

```
[10:02:01]  LegitApp.exe  ->  SearchOrder: C:\Users\john\Downloads\helper.dll  ->  LOADED
```

---

## Question

What most likely happened between the two captures?

---

## Flags (Choose One)

- **A)** The Windows search order was changed by a system update
- **B)** An attacker placed a malicious `helper.dll` in the Downloads folder knowing the app would load it
- **C)** The legitimate `helper.dll` was finally installed into the Downloads folder by the developer
- **D)** The application was patched to look in the Downloads folder first

---

Correct Flag: **B**

---

# Finished?
[Next Question](DLL_medium.md)  
[Back to Card's Main Page](../Dynamic_Link_Library_Hijacking.md)
