![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - UEFI Boot Anomaly

A technician is investigating a machine that keeps re-infecting itself after full OS reinstalls. They pull the CHIPSEC report and notice the following:

```
[*] Checking UEFI Secure Boot variables...
    SecureBoot: 0 (DISABLED)
    SetupMode:  1 (ENABLED)

[*] Checking SPI Flash write protections...
    BIOSWE  = 1  (BIOS Write Enable: ON)
    BLE     = 0  (BIOS Lock Enable: OFF)

[!] WARNING: BIOS region is writable. No write protection enforced.
```

The machine had its OS reinstalled three times. The malware keeps coming back.

---

## Question

Why does reinstalling the operating system fail to remove the infection?

---

## Flags (Choose One)

- **A)** The malware is stored in the firmware, which the OS installer never touches
- **B)** The OS installer is also infected and reinstalls the malware automatically
- **C)** The hard drive is write-protected, preventing the installer from working
- **D)** The malware is hiding in a second user account that survives reinstalls

---

Correct Flag: **A**

---

# Finished?
[Next Question](MF_medium.md)  
[Back to Card's Main Page](/Cards/PER/Malicious_Firmware.md)
