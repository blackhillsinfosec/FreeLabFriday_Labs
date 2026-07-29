![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Registry Persistence Hunt

You are investigating a Windows machine after an alert fired on unusual boot behavior. You pull the registry and find this entry:

```
Key:   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetHelper
Type:  Kernel Driver
Start: 0x00000000 (Boot)
ImagePath: \??\C:\Users\Public\nethelper.sys
```

The file `nethelper.sys` is not present in any driver inventory and the path is unusual for a legitimate driver.

---

## Question

Why is this registry entry a strong indicator of malicious driver persistence?

---

## Flags (Choose One)

- **A)** Kernel drivers should never use a Boot start value
- **B)** The service name "NetHelper" is on a known blocklist
- **C)** Registry keys in CurrentControlSet cannot be created by users
- **D)** Legitimate drivers are not stored in user-writable paths like C:\Users\Public

---

Correct Flag: **D**

---

# Finished?
[Next Question](MDR_medium.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Driver.md)
