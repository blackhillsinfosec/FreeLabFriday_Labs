## Memory Forensics

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
