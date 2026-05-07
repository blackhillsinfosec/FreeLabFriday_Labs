![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Memory Forensics

A threat hunter runs a memory dump on a suspected endpoint and uses a tool to list all kernel modules currently loaded. The output shows the following:

```
Offset      Name              Base         Size       
----------  ----------------  -----------  -------
0xfa800...  ntoskrnl.exe      0xfffff800   780288     [SIGNED]
0xfa801...  hal.dll           0xfffff800   163840     [SIGNED]
0xfa802...  tcpip.sys         0xfffff880   1056768    [SIGNED]
0xfa803...  storport.sys      0xfffff880   380928     [SIGNED]
0xfa804...  win32k.sys        0xfffff960   3538944    [SIGNED]
0xfa805...  ????????          0xfffff880   45056      [NOT IN PEB]
```

The last entry has no name, is not listed in the Process Environment Block, and does not appear in the driver list visible from the OS.

---

## Question

What does the `[NOT IN PEB]` tag and missing name most likely indicate?

---

## Flags (Choose One)

- **A)** The driver was unloaded but left a memory artifact
- **B)** This is a standard Windows driver loaded early in boot before logging starts
- **C)** The memory dump is corrupted and this entry should be ignored
- **D)** A rootkit driver is hiding itself from the operating system's own driver list

---

Correct Flag: **D**

---

# Finished?
[Next Question](MDR_hard.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Driver.md)
