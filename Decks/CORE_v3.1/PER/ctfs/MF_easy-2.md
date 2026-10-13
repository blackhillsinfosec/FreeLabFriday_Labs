## UEFI Boot Anomaly

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
