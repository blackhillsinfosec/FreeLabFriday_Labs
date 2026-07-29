![image](/FilesForLabs/images/blueantisyphon.png)

[Part 1](./ritaLab1.md) [Part 2](./ritaLab2.md) [Part 3](./ritaLab3.md) [Part 4](./ritaLab4.md) [Part 5](./ritaLab5.md) [Part 6](./ritaLab6.md) [Part 7](./ritaLab7.md)

# Ubuntu VM

During these parts you will be going through 7 datasets and you will have to answer some questions for each, you will find the answers if you keep scrolling down

You can view all of them via
```bash
rita list
```

<img width="742" height="242" alt="Screenshot From 2026-03-17 10-53-41" src="https://github.com/user-attachments/assets/11c61de5-a251-428c-b6ec-6b94e290eb08" />

## specula

**Dataset description:** Hijacks Outlook, egress via HTTPS tcp 443
```bash
rita view specula
```

1. One host shows an extremely high connection count (34,873) to an external IP with a rare signature ACMS/1.0. What is the destination IP?

 
2. A High-severity entry shows a very low Beacon Score (0.087) despite a very long total duration (>79,000 seconds). What FQDN was contacted?

 
3. A Medium-severity flow goes to an external IP on a non-standard high port (32526) and is tagged with a mime_type_mismatch. What was the full Port:Proto:Service string for this entry?

 
4. One entry shows Outlook communicating with its cloud infrastructure and includes a rare signature revealing a User-Agent string with an Office/Outlook build. What is the exact rare signature value?

 
5. An entry (Severity: None) shows a Microsoft delivery host (1a.tlu.dl.delivery.mp.microsoft.com) transferring an unusually large volume of bytes (~78 million), flagged with a mime_type_mismatch. What is the exact total megabytes value shown in the dataset?

 
6. One entry (Severity: None) shows communication with an external IP over port 443 but with two different protocols listed (UDP + TCP). What is the destination IP?


<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

**1. Answer:** 168.63.129.16

**2. Answer:** prod-eastus.access-point.cloudmessaging.edge.microsoft.com

**3. Answer:** 32526:tcp:http

**4. Answer:** Microsoft Office/16.0 (Windows NT 10.0; Microsoft Outlook 16.0.18025; Pro)

**5. Answer:** 74.56

**6. Answer:** 34.120.154.120

<br><br>

Continue with [Part 7](./ritaLab7.md)

<b><i>Looking for a different lab? </br>[Lab Directory](/SocAnalystLabs/coursenavigation.md)</i></b>

---
[Back to the section](/SocAnalystLabs/courseFiles/Section_05-networkingAndTelemetry/networkingAndTelemetry.md)

> Created By Turcu Știolică Alexandru - Black Hills Information Security
