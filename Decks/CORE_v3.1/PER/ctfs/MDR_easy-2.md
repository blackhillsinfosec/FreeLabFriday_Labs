## Registry Persistence Hunt

You are investigating a Windows machine after an alert fired on unusual boot behavior. You pull the registry and find this entry:

```
Key:   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetHelper
Type:  Kernel Driver
Start: 0x00000000 (Boot)
ImagePath: \??\C:\Users\Public\nethelper.sys
```

The file `nethelper.sys` is not present in any driver inventory and the path is unusual for a legitimate driver.
