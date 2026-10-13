## Full Firmware Implant

Your team is conducting a forensic investigation on a high-value target within a corporate network. The machine belongs to an executive and has been behaving strangely for months - occasional unexplained outbound connections, brief performance dips at boot time, and antivirus showing clean every time.

You collect the following artifacts:

**CHIPSEC output:**
```
[!] SMRAM is not locked
[!] SMM security mitigation is not enabled
[*] Checking for known UEFI implant indicators...
    DXE driver hash mismatch detected: SmmAccessDxe.efi
    Expected: 9f3b1c...  Found: 4da72e...
```

**Wireshark capture (boot time, before OS loads):**
```
00:11:22:33:44:55 -> Broadcast  DNS Query: update.legit-vendor-portal.net
192.168.1.10      -> 91.205.188.42  TCP SYN  Port 443
91.205.188.42     -> 192.168.1.10   TCP SYN-ACK
[TLS handshake follows - encrypted payload, 4.2KB outbound]
```

**Threat intel lookup on 91.205.188.42:**
```
ASN:        AS48571 - Unregistered VPS block
Flagged by: 7 threat feeds
Tags:       C2, APT, firmware implant infrastructure
Last seen:  2024-03-09
```

**Timeline note:** The outbound connection happens approximately 4 seconds after power-on, consistently before the Windows boot logo appears.
