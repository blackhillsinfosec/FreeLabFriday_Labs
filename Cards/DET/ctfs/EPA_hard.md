![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Lateral Movement Chain

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

---

## Question

At `03:19`, `cmd.exe` was spawned by `services.exe` on SERVER-02. What technique does this most likely indicate, and why is the network logon type 3 significant in this context?

---

## Flags (Choose One)

- **A)** It indicates RDP was used to log in interactively; type 3 means the credentials were passed in cleartext
- **B)** It indicates pass-the-hash lateral movement using a stolen NTLM hash; type 3 means no plaintext password was needed, only the hash
- **C)** It indicates a brute-force attack against SMB; type 3 means the account was locked out and reset remotely
- **D)** It indicates a misconfigured service account; type 3 is the default logon type for all local administrator actions

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](/Cards/DET/Endpoint_Security_Protection_Analysis.md)
