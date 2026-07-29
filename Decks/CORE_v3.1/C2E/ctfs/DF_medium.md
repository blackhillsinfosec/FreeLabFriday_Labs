![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Hunting the Beacon

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

---

## Question

What is the correct first investigative step to confirm whether this is domain fronting?

---

## Flags (Choose One)

- **A)** Immediately block all outbound traffic to Azure IP ranges across the organization
- **B)** Compare the SNI value in the TLS handshake against the HTTP Host header captured by the proxy
- **C)** Reinstall the OS on the workstation and close the alert
- **D)** Disable HTTPS inspection on the proxy to avoid breaking legitimate traffic

---

Correct Flag: **B**

---

# Finished?

[Next Question](DF_hard.md)  
[Back to Card's Main Page](../Domain_Fronting_As_C2.md)
