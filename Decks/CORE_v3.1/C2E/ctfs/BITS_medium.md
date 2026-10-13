## Reconstructing an Exfiltration Timeline

You are a defender investigating a potential data breach. The endpoint in question is a finance department laptop. You run the following command and get this output:

```cmd
bitsadmin /list /allusers /verbose
```

```
GUID        : {A3F2C1B4-...}
DisplayName : WindowsUpdateHelper
Type        : UPLOAD
State       : TRANSFERRED
Priority    : FOREGROUND
Created     : 2024-03-15 00:04:11
Modified    : 2024-03-15 00:09:55
Transfer    : 1 / 1
Files       : 1 / 1

  Source    : C:\ProgramData\audit_q1_2024.zip
  Dest      : http://update-cdn-microsoft.net/receive/audit_q1_2024.zip
  Size      : 87,341,024 bytes
```

You look up `update-cdn-microsoft.net` - it was registered 6 days ago and does not belong to Microsoft.
