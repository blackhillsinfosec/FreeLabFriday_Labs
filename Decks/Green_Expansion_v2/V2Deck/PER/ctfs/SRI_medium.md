![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Persistence Through Reboot

A SOC analyst receives an alert that a host is beaconing out to an unknown IP every time it reboots. The malware was already removed from disk, but the beaconing keeps coming back. You are brought in to find out why.

You run a full registry query on both Run key locations and find nothing obvious. Then you check a less common persistence location:

```
reg query HKLM\SYSTEM\CurrentControlSet\Services\NetMgrSvc
```

Output:

```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetMgrSvc

    Type                REG_DWORD    0x10
    Start               REG_DWORD    0x2
    ErrorControl        REG_DWORD    0x1
    ImagePath           REG_EXPAND_SZ    C:\ProgramData\netmgr\netmgr.exe
    DisplayName         REG_SZ    Network Manager Service
    Description         REG_SZ    Manages background network operations.
```

The service `NetMgrSvc` is not on the approved software list. The binary at `C:\ProgramData\netmgr\netmgr.exe` is unsigned. The `Start` value of `0x2` means the service starts automatically.

---

## Question

Why did removing the file from disk not stop the persistence?

---

## Flags (Choose One)

- **A)** The attacker had a backup copy stored in the cloud that re-downloaded on reboot
- **B)** The registry service entry still existed and Windows attempted to re-execute it, pulling from a remaining copy in ProgramData
- **C)** The antivirus restored the malware from quarantine automatically
- **D)** The Run key was hidden using a rootkit and the analyst missed it

---

Correct Flag: **B**

---

# Finished?
[Next Question](SRI_hard.md)
[Back to Card's Main Page](../Startup_Registry_Injection.md)
