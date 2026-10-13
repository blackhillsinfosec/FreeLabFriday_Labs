## Full Exfil Hunt

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
