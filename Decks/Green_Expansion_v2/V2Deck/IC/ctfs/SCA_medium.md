![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Hunting SUNBURST Indicators

You are a threat hunter at a company that ran SolarWinds Orion version 2020.2. Leadership wants to know if the environment was compromised by SUNBURST.

You have access to the following data points collected from one endpoint:

```
[Process Log]
Parent:   SolarWinds.BusinessLayerHost.exe
Child:    cmd.exe
Args:     /c whoami & ipconfig & net localgroup administrators

[Network Log]
Host:     192.168.4.10
Protocol: HTTPS
Dest:     databaseus.appsync-api.us-east-1.avsvmcloud.com:443
Direction: Outbound
First seen: 14 days after Orion installation

[File Log]
Path:     C:\Windows\SysWOW64\netsetupsvc.dll
Action:   Created
By:       SolarWinds.BusinessLayerHost.exe
```

---

## Question

Which combination of findings is the strongest evidence of an active SUNBURST infection?

---

## Flags (Choose One)

- **A)** The child process spawned by Orion, combined with the outbound HTTPS connection to a subdomain of avsvmcloud.com
- **B)** The DLL created in SysWOW64, because DLLs in that folder are always malicious
- **C)** The outbound connection alone, because any external HTTPS traffic from a monitoring tool is suspicious
- **D)** The cmd.exe process alone, because legitimate software never spawns command-line tools

---

Correct Flag: **A**

---

# Finished?

[Next Challenge](SCA_hard.md)
[Back to Main Page](../Supply_Chain_Attack.md)
