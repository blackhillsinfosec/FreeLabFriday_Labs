![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

[Part 1](./ritaLab1.md) [Part 2](./ritaLab2.md) [Part 3](./ritaLab3.md) [Part 4](./ritaLab4.md) [Part 5](./ritaLab5.md) [Part 6](./ritaLab6.md) [Part 7](./ritaLab7.md)

# Ubuntu VM

During these parts you will be going through 7 datasets and you will have to answer some questions for each, you will find the answers if you keep scrolling down

You can view all of them via
```bash
rita list
```

<img width="742" height="242" alt="Screenshot From 2026-03-17 10-53-41" src="https://github.com/user-attachments/assets/11c61de5-a251-428c-b6ec-6b94e290eb08" />

## teamviewer

**Dataset description:** TeamViewer — Egress via TCP 443
```bash
rita view teamviewer
```

1. Which internal host is flagged Critical for TeamViewer activity in teamviewer_view.csv

 
2. How many connections are recorded for the Critical TeamViewer entry

 
3. How many total kilobytes are reported for the Critical TeamViewer entry

 
4. What is the exact Port:Proto:Service string for the Critical TeamViewer entry

 
5. RITA also shows a High-severity flow from the same host to a public IP over TeamViewer’s well-known port with a 0% beacon score. What destination IP and port are used in that entry

 
6. How many total megabytes moved over that TeamViewer port (from Q5) in that single entry


<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

**1. Answer:** 192.168.99.52

**2. Answer:** 51

**3. Answer:** 875.5

**4. Answer:** 443:tcp:ssl

**5. Answer:** 52.117.209.74:5938

**6. Answer:** 796.2

<br><br>


Continue with [Part 6](./ritaLab6.md)

---

# Finished?

[Back to Card's Main Page](/Cards/DET/Network_Threat_Hunting.md)

> Created By Turcu Știolică Alexandru - Black Hills Information Security
