## Default Creds, Real Consequences

You find an externally reachable service on a target host

A banner grab shows:

```
80/tcp open  http
Server: Apache Tomcat/9.0.XX
Title: "Tomcat Manager Application"
```

When you visit `/manager/html`, you get a browser authentication prompt (Basic Auth)

---

## Goal

Pick the most likely way a red team gets in **first**, before spending time on anything fancy
