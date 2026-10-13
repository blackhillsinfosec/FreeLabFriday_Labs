## C2 Traffic Investigation

A SIEM alert fired on a developer workstation. You pull the relevant logs and find the following sequence of events:

```
[09:14:22]  svchost.exe        spawned child process: powershell.exe
[09:14:23]  powershell.exe     read file: C:\Users\dev01\Documents\credentials.txt
[09:14:24]  powershell.exe     read file: C:\Users\dev01\AppData\Roaming\ssh\known_hosts
[09:14:25]  powershell.exe     made HTTPS connection to: update-cdn.delivery-net.com:443
[09:14:26]  powershell.exe     POST /telemetry/report  body size: 14.7 KB
[09:14:27]  powershell.exe     received response: 200 OK
[09:14:27]  powershell.exe     exited
```

A quick WHOIS on `update-cdn.delivery-net.com` shows the domain was registered 4 days ago.
