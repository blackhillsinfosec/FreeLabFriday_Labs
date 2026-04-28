# IDS Lab - Using Snort & Suricata
 
## Lab Goals
 
Learn how to:
- Use **Snort** and **Suricata** 
- Create and test **custom detection rules**
- Simulate **attacks** (ping, Nmap, Nikto, curl, etc.)
- Monitor and analyze **alerts**
 
 
---
 
## 1. Install IDS Tools 
 
### Install Snort (via apt)

>it should already be installed!
 
Verify:
 
```bash
snort -V
```
>[!IMPORTANT]
>
> Output should say **Snort++ / Snort 3.x**
 
<img width="1007" height="370" alt="image" src="https://github.com/user-attachments/assets/51c35470-9900-4b86-954a-50925d8dca10" />


---
 
### Install Suricata
 

>it should already be installed!

Verify:
 
```bash
suricata --build-info
```
<img width="789" height="46" alt="image" src="https://github.com/user-attachments/assets/61cb2d8b-5fa3-45a3-a255-7f8aa5d11467" />


---
 
## 2. Lab Folder Structure (Optional)
 
```bash
mkdir -p ~/labs/ids_lab/{rules,logs,pcaps}
```
 
---
 
## 3. Snort Lab
 
### A. Create a Snort Rule

```bash
cd ~/SOC_Analyst_Labs/ids
```

```bash
mkdir rules
```
 
```bash
cd rules && nano local.rules
```
 
Paste:
 
```snort
alert icmp any any -> any any (msg:"[Snort3] ICMP Ping Detected"; sid:1000001; rev:1;)
```
 
![Snort rule 1](./ids_lab_photos/nano_snort_rule.png)
```bash
cd ..
```
---
 
###  B. Run Snort 
 
```bash
sudo snort -c /usr/local/etc/snort/snort.lua -R /home/ubuntu/SOC_Analyst_Labs/ids/rules/local.rules -i lo -A alert_fast
```
 
- `-c`: config file
- `-R`: rule file
- `-i lo`: loopback interface
- `-A alert_fast`: fast alert output
 
<img width="566" height="748" alt="image" src="https://github.com/user-attachments/assets/c4742c2f-bcbe-446c-8126-327c5881e022" />


---
 
### C. Simulate Traffic
 
Open a new terminal:
 
```bash
ping 127.0.0.1
```
 
<img width="633" height="195" alt="image" src="https://github.com/user-attachments/assets/460f5657-49ff-435e-9d20-9fb123dccc22" />


 You should see something similar to this:
 
```
[Snort3] ICMP Ping Detected
```
 
![snort detection](./ids_lab_photos/Snort_detection.png)

---
 
### More Snort Rules
 
In `local.rules`, add:
 
```snort
alert tcp any any -> any any (flags:S; msg:"[Snort3] SYN Scan Detected"; sid:1000002; rev:1;)
```
 
![snort 2nd rule](./ids_lab_photos/snort_second_rule.png)

Test:
 
```bash
sudo nmap -sS 127.0.0.1
```
 
![nmap](./ids_lab_photos/nmap_scan.png)

![snort detection logs for 2nd rule](./ids_lab_photos/snort_second_rule_detection.png)

---
 
## 4. Suricata Lab
 
### A. Add Custom Rules
 
```bash
sudo nano /var/lib/suricata/rules/suricata.rules
```
 
Paste:
 
```suricata
alert icmp any any -> any any (msg:"[Suricata] ICMP Ping Detected"; itype:8; sid:2000001;)
```
 
Ensure `/etc/suricata/suricata.yaml` includes:
 
```yaml
default-rule-path: /var/lib/suricata/rules
 
rule-files:
  - suricata.rules
```
 
---
 
### B. Run Suricata
 
```bash
sudo suricata -c /etc/suricata/suricata.yaml -i lo
```

<img width="873" height="171" alt="image" src="https://github.com/user-attachments/assets/50ae9b31-bc3a-4eed-8487-9105536c9bc5" />




Then(in another terminal):
 
```bash
ping 127.0.0.1
```
 
Check alerts(in a 3rd terminal):
 
```bash
sudo tail -f /var/log/suricata/fast.log
```

![suricata logs tail](./ids_lab_photos/suricata_detection_logs_tail.png)
 
---
 
## 5.Skills You're Practicing
 
| Skill              | Purpose                                           |
|-------------------|---------------------------------------------------|
| IDS Configuration | Setup and tuning for detection effectiveness      |
| Rule Writing       | Customize detection, reduce false positives       |
| Alert Triage       | Investigate logs quickly and efficiently          |
| Attack Simulation  | Understand adversary behavior                     |
| Incident Reporting | Communicate findings clearly in report format     |
 
---
 
##  6. Mini-Incident Report Example
 
| Field           | Example                       |
|----------------|-------------------------------|
| **Time**        | 2025-07-24 14:32              |
| **Tool**        | Suricata                      |
| **Alert**       | ICMP Ping Detected            |
| **Source IP**   | 127.0.0.1                     |
| **Dest IP**     | 127.0.0.1                     |
| **Rule SID**    | 2000001                       |
 
 
---
 
## 7. Useful resource
 
- [snorpy](https://snorpy.cyb3rs3c.net) -A Web Based Snort Rule Creator


---
[Back to the section](/SocAnalystLabs/courseFiles/Section_05-networkingAndTelemetry/networkingAndTelemetry.md)
