![image](/FilesForLabs/images/blueantisyphon.png)

## Spot the Anomalous Login

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
