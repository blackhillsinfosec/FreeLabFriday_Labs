## Log Pattern Analysis

You are going through firewall logs after an endpoint protection alert fired on a machine in the accounting department.

You notice the following entries over 30 minutes:

```
14:02:11  OUTBOUND  192.168.2.10:52341 -> 91.107.56.33:443   2.1 KB sent
14:07:11  OUTBOUND  192.168.2.10:52342 -> 91.107.56.33:443   2.3 KB sent
14:12:10  OUTBOUND  192.168.2.10:52343 -> 91.107.56.33:443   2.0 KB sent
14:17:11  OUTBOUND  192.168.2.10:52344 -> 91.107.56.33:443   2.2 KB sent
14:22:12  OUTBOUND  192.168.2.10:52345 -> 91.107.56.33:443   2.1 KB sent
```

The machine's user was on lunch break during this entire window. No browser or known application was open.
