![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF – Multi-Source Investigation

Your SIEM ingests logs from endpoint, DNS, and authentication sources.

You observe the following timeline:

```
11:03:10  AUTH   user: jsmith  login success
11:04:02  DNS    query: update-check.secure-apps.net
11:04:03  ENDPOINT  powershell.exe spawned by winword.exe
11:04:05  DNS    query: data-sync.secure-apps.net
```

The user reports only opening an email attachment.

---

## Question

What is the most likely scenario?

---

## Flags (Choose One)

- **A)** Normal software update
- **B)** User manually ran a maintenance script
- **C)** Phishing attachment leading to malicious script execution
- **D)** SIEM false positive from DNS logs

---

Correct Flag: **C**

---

# Finished?

[Next Question](siem_hard.md)

[Back to Card's Main Page](/Cards/DET/Security_Informations_And_Event_Management_Log_Analysis.md)
