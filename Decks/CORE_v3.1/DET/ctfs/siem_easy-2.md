## Basic Log Correlation

You are analyzing web and firewall logs collected into the SIEM.

You notice the following sequence:

```
10:14:22  WEB  GET /admin/login
10:14:35  WEB  POST /admin/login   status: 200
10:14:36  FIREWALL  outbound connection to 198.51.100.24:4444
```

The outbound connection came from the same web server.
