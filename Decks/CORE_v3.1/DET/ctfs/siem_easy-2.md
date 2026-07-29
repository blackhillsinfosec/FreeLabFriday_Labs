![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 – Basic Log Correlation

You are analyzing web and firewall logs collected into the SIEM.

You notice the following sequence:

```
10:14:22  WEB  GET /admin/login
10:14:35  WEB  POST /admin/login   status: 200
10:14:36  FIREWALL  outbound connection to 198.51.100.24:4444
```

The outbound connection came from the same web server.

---

## Question

What most likely happened?

---

## Flags (Choose One)

- **A)** Web server initiated suspicious external communication after login
- **B)** Normal administrator login
- **C)** Firewall update process
- **D)** Internal vulnerability scan

---

Correct Flag: **A**

---

# Finished?

[Next Question](siem_medium.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Security_Informations_And_Event_Management_Log_Analysis.md)
