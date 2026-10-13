## Hunting the Beacon

Your SIEM fired an alert on a developer workstation. You pull the relevant logs and find the following:

**DNS logs:**
```
workstation-04 queried: api.azure-cdn.net  ->  resolved to 13.107.x.x
```

**Proxy logs:**
```
CONNECT api.azure-cdn.net:443  -  TLS established
Host: beacon.c2-operator.io
Transfer: 512 bytes out / 88 bytes in
Duration: 143ms
```

**Endpoint logs:**
```
Process: svchost.exe (PID 4812)
Parent: explorer.exe
Network connection initiated to 13.107.x.x:443
```

The developer insists they were not doing anything Azure-related at the time.
