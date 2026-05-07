![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Spot the Anomalous Login

You are a SOC analyst reviewing login activity for a company employee named **maria.ionescu**.

Her normal behavior baseline looks like this:

- Login hours: **08:00 – 17:00, Monday to Friday**
- Location: **Bucharest, Romania**
- Device: **Windows 10 workstation, hostname WKSTN-047**

You receive the following UEBA alert from this week's logs:

```
2024-11-14 02:34:17  User: maria.ionescu  Source IP: 185.220.101.42
Location: Frankfurt, Germany  Device: Unknown  Action: Successful login
Files accessed: HR_salaries_2024.xlsx, contracts_archive.zip
```

---

## Question

What is the most accurate conclusion based on the behavioral baseline?

---

## Flags (Choose One)

- **A)** Maria is working overtime from a business trip
- **B)** The login is normal because the credentials were valid
- **C)** This is a likely compromised account — multiple baseline deviations detected
- **D)** The alert is a false positive triggered by a VPN connection

---

**Correct Flag: C**

---

# Finished?
[Next Question](UEBA_easy-2.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/DET/UEBA_Analytics.md)
