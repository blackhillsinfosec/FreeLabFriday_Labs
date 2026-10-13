## Full Lateral Movement Chain

You are a SOC analyst. An alert fires from your EDR at 03:40 AM. You pull the full timeline for the affected hosts over the last 30 minutes.

---

### Timeline

```
[03:11] WORKSTATION-04   phishing attachment opened: invoice_Q1.docm
[03:11] WORKSTATION-04   winword.exe spawned powershell.exe -nop -w hidden -enc <base64>
[03:12] WORKSTATION-04   outbound connection to 185.220.101.47:443 (C2 beacon)
[03:14] WORKSTATION-04   lsass.exe accessed by powershell.exe
[03:15] WORKSTATION-04   hash extracted: jsmith / NTLM: aad3b435b51404eeaad3b435...
[03:19] SERVER-02        logon event: jsmith (type 3 - network logon) from WORKSTATION-04
[03:19] SERVER-02        cmd.exe spawned by services.exe
[03:20] SERVER-02        schtasks.exe created: "WinUpdate" -> C:\Temp\beacon.exe
[03:21] SERVER-02        beacon.exe executed, outbound connection to 185.220.101.47:443
[03:23] SERVER-02        net.exe: "net group 'Domain Admins' /domain"
[03:27] DC-01            logon event: jsmith (type 3 - network logon) from SERVER-02
[03:28] DC-01            NTDS.dit accessed by cmd.exe
```
