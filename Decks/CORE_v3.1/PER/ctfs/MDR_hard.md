![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Kernel Rootkit Investigation

Your SOC receives an alert from an EDR tool that briefly fired on a host before going silent. You pull what logs you can and piece together the following timeline:

```
[08:14:22]  PowerShell executed:  
            sc.exe create VulnHelper binPath= "C:\Windows\System32\drivers\dbutil_2_3.sys" type= kernel

[08:14:35]  PowerShell executed:  
            sc.exe start VulnHelper

[08:14:38]  EDR process terminated unexpectedly

[08:14:41]  New kernel module loaded: [unnamed, unsigned, 41KB]

[08:15:02]  Outbound connection established to 185.220.xx.xx:443

[08:15:10]  EDR process restart attempt - failed
```

You research `dbutil_2_3.sys` and find it is a legitimate but **known-vulnerable** Dell driver with a CVE that allows arbitrary kernel memory read/write.

---

## Question

Based on the full timeline, which technique did the attacker most likely use to load their unsigned malicious driver?

---

## Flags (Choose One)

- **A)** They disabled Secure Boot from the BIOS to bypass driver signing enforcement
- **B)** They used a known-vulnerable legitimate driver (BYOVD) to gain kernel write access and load their own unsigned driver
- **C)** They exploited a zero-day in the Windows kernel that allowed driver signing to be bypassed entirely
- **D)** They enrolled a fake certificate in the system trust store to sign their driver before loading it

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](/Cards/PER/Malicious_Driver.md)
