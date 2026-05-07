![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Persistence Chain

You are responding to an alert on a Windows Server 2019 machine that handles internal file sharing. The SIEM correlated four events across a 20-minute window. Your job is to reconstruct what happened and identify the attacker's final objective at this stage of the intrusion.

---

## Timeline of Events

**03:02:11** - Successful RDP login from internal IP `10.10.4.88` using the account `svc_backup`. This account normally authenticates only via scheduled tasks, never interactively.

**03:06:44** - Process creation: `cmd.exe` spawned by `mstsc.exe`. Child process runs:
```
sc.exe create BackupSyncSvc binPath= "C:\ProgramData\bsync\bsync.exe /auto" start= auto
```

**03:08:19** - Outbound connection from `bsync.exe` to `185.220.101.47:443`. The connection stays open.

**03:09:55** - `sc.exe` runs again:
```
sc.exe failure BackupSyncSvc reset= 0 actions= restart/5000/restart/5000/restart/5000
```

---

## Supporting Context

- `svc_backup` has local administrator rights on this machine
- `185.220.101.47` is a known Tor exit node
- `bsync.exe` is unsigned, 61 KB, created at 03:06:40
- The failure recovery command causes the service to restart automatically if it crashes

---

## Question

Considering the full chain of events, what is the attacker doing with the final `sc.exe failure` command, and why does it matter?

---

## Flags (Choose One)

- **A)** They are making the service resilient against crashes or manual stops, ensuring the C2 channel survives disruption attempts
- **B)** They are testing whether the service works correctly before exfiltrating data
- **C)** They are configuring the service to shut itself down after a set number of restarts to avoid detection
- **D)** They are setting up a backup communication channel in case the primary C2 IP gets blocked

---

Correct Flag: **A**

---

# Finished?
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Service.md)
