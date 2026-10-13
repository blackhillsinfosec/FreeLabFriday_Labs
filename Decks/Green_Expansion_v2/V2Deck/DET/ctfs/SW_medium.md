## Wireless Anomaly Hunt

You run a wireless spectrum scan during the walkthrough. The company's authorized access points are all documented in the network inventory. Your scan picks up the following SSIDs in the building:

```
SSID: CorpNet-Internal     | MAC: 00:1A:2B:3C:4D:5E | Signal: -45 dBm | Channel: 6
SSID: CorpNet-Internal     | MAC: 00:1A:2B:3C:4D:5F | Signal: -48 dBm | Channel: 6
SSID: CorpNet-Guest        | MAC: 00:1A:2B:3C:4D:60 | Signal: -50 dBm | Channel: 11
SSID: CorpNet-Guest        | MAC: AA:BB:CC:DD:EE:FF | Signal: -38 dBm | Channel: 11
SSID: HP-Setup             | MAC: F4:CE:46:12:88:01 | Signal: -72 dBm | Channel: 1
```

The network inventory lists exactly two authorized APs for `CorpNet-Internal` and one for `CorpNet-Guest`. The MAC prefixes for all authorized hardware start with `00:1A:2B`.

The `CorpNet-Guest` AP at `AA:BB:CC:DD:EE:FF` is not in the inventory and is broadcasting from a corner of the open office floor with a stronger signal than the legitimate one.
