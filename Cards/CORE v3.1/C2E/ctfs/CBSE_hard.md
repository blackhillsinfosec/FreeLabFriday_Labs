![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Silent Drain

You are a threat hunter investigating a suspected long-term breach. An internal tip suggested data may have been leaving the network for weeks. No alerts fired during that period.

You pull 30 days of SIEM data for a finance workstation and find the following pattern across 18 days:

```
Daily outbound traffic to onedrive.live.com:443 - avg. 2.1 MB/day (normal baseline: 1.9 MB/day)
```

Nothing else stands out in the network logs. The firewall shows no blocks. No malware was detected by the AV.

You then pivot to endpoint telemetry and find:

```
[recurring, 03:00–03:15 daily]
PROCESS: OneDrive.exe (signed, legitimate binary)
PARENT:  schtasks.exe
FILE ACCESS: C:\Finance\Exports\*.csv  (bulk read, ~2 MB each night)
UPLOAD: personal OneDrive account (not the corporate tenant)
```

The legitimate OneDrive client is being used, the binary is signed by Microsoft, and the traffic volume barely exceeds the normal baseline.

---

## Question

Why did this exfiltration go undetected for weeks, and what was the critical indicator that finally revealed it?

---

## Flags (Choose One)

- **A)** The attack was detected because OneDrive.exe is always flagged by SIEM rules as suspicious
- **B)** The upload went to a personal OneDrive account instead of the corporate tenant, and it was spawned nightly by a scheduled task reading finance files - the combination of parent process, destination account, and file access pattern is the real tell
- **C)** The attacker made a mistake by uploading more than 2 MB, which triggered a data loss prevention rule
- **D)** Endpoint AV flagged OneDrive.exe because its hash did not match the expected value

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](../Cloud_Based_Services_As_Exfil.md)
