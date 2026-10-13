## Poisoned Network

You are reviewing SIEM alerts from the past hour. One alert stands out:

```
[ALERT] Unusual LLMNR/NBT-NS response detected
    Responding IP : 192.168.1.99
    Claimed name  : FILESERVER
    Real server   : 192.168.1.10
    Time          : 14:32:07
```

Shortly after, several workstations attempted to authenticate to 192.168.1.99.
