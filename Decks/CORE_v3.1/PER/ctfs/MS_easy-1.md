![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Spot the Service

A junior analyst is reviewing the services installed on a Windows endpoint that was flagged by the SIEM. They pull the service list and notice this entry among the usual system services:

```
Service Name:  WindowsUpdateHelper32
Display Name:  Windows Update Helper
Binary Path:   C:\Users\Public\Downloads\wuh32.exe
Status:        Running
Start Type:    Automatic
```

Everything else on the list looks normal.

---

## Question

What should immediately raise a red flag about this service?

---

## Flags (Choose One)

- **A)** The service is set to start automatically
- **B)** The binary is located in a user-writable public directory, not a system path
- **C)** The service name contains numbers
- **D)** The display name is too similar to a real Windows service

---

Correct Flag: **B**

---

# Finished?
[Next Question](MS_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Service.md)
