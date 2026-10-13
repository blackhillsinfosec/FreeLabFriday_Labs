## Hunting SUNBURST Indicators

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
