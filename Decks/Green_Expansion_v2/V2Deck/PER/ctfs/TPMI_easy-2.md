![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Suspicious Update

A company's IT team pushes a routine software update to all workstations on a Monday morning. By noon, the SOC receives alerts from multiple machines showing the same process spawning outbound connections:

```
Process: updater.exe
Parent: svchost.exe
Destination: 185.220.101.47:4444
Frequency: every 60 seconds
```

No user interaction triggered this. The update came from the vendor's official update server.

---

## Question

Which conclusion best fits the evidence?

---

## Flags (Choose One)

- **A)** A user on one of the machines manually ran a malicious file
- **B)** The vendor's update server or update package was compromised before distribution
- **C)** The SOC alerts are false positives caused by the update process checking for newer versions
- **D)** The workstations had a pre-existing infection unrelated to the update

---

Correct Flag: **B**

---

# Finished?

[Next Question](TPMI_medium.md)
[Back to Card's Main Page](../Third-Party_Malware_Injection.md)
