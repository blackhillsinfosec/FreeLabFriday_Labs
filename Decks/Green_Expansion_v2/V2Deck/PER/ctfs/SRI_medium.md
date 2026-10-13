## Persistence Through Reboot

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
