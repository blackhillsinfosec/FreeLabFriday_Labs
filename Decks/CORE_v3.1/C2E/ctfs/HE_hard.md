![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Exfil Hunt

You are a SOC analyst. An alert fired overnight and you are reconstructing what happened using logs from three different sources.

---

### Endpoint Log (from the affected machine)

```
[02:11:04]  explorer.exe         spawned: rundll32.exe  args: C:\Windows\Temp\upd.dll,Init
[02:11:05]  rundll32.exe         created file: C:\Windows\Temp\~stage.bin
[02:11:06]  rundll32.exe         read: C:\Users\finance01\Desktop\Q3_report.xlsx
[02:11:06]  rundll32.exe         read: C:\Users\finance01\AppData\Local\Google\Chrome\User Data\Default\Login Data
[02:11:07]  rundll32.exe         wrote 38 KB to: C:\Windows\Temp\~stage.bin
```

---

### Network Log (from the perimeter firewall)

```
[02:11:08]  192.168.10.22 -> 104.21.88.47:443   POST /cdn-api/v2/push   38.2 KB   200 OK
[02:11:09]  192.168.10.22 -> 104.21.88.47:443   GET  /cdn-api/v2/status  0.1 KB   200 OK
```

---

### Threat Intel Feed (pulled automatically by SIEM)

```
104.21.88.47  - flagged in 2 prior incidents as Mythic C2 infrastructure
              - associated domain: cdn-assets-delivery.net
              - first seen: 6 days ago
```

---

## Question

Based on all three log sources combined, which conclusion best describes the full attack chain?

---

## Flags (Choose One)

- **A)** A finance user manually uploaded a report to a cloud CDN, which happens to share an IP with a known bad actor
- **B)** rundll32.exe staged and exfiltrated a financial report and saved browser credentials to a known Mythic C2 server over HTTPS, likely as part of a coordinated intrusion
- **C)** The SIEM generated a false positive - rundll32.exe is a legitimate Windows process and HTTPS traffic to port 443 is normal
- **D)** The endpoint was running a backup agent that compressed and uploaded files on a schedule

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](/Decks/CORE_v3.1/C2E/HTTPS_As_Exfil.md)
