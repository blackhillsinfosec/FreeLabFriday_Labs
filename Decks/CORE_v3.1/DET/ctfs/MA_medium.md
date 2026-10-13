## Injected Process

You are investigating a memory image from a compromised endpoint. The SOC received an alert about unusual outbound traffic, but no new processes were found on disk.

You run `malfind` in Volatility and get the following output:

```
Process: explorer.exe PID: 1204
VA: 0x00400000 Size: 0x3000
Flags: PAGE_EXECUTE_READWRITE

4d 5a 90 00 03 00 00 00  MZ......
```

You then run `dlllist` on PID 1204 and notice a loaded module with no path on disk:

```
Base         Size     Path
------------ -------- ----
0x00400000   0x3000   (not mapped to any file)
```

Finally, you check active network connections with `netscan`:

```
Proto  Local Addr        Foreign Addr         State    PID   Process
TCP    10.0.0.5:49823    185.220.101.47:443   ESTAB    1204  explorer.exe
```
