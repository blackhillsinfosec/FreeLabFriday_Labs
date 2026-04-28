![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# SQL Injection Lab

# Windows VM

## The objective for this lab is to
- Understand how SQL Injection works
- See how it appears in logs
- See the mitigation ( how a SOC analyst should react )
- See the difference between vulnerable and secure code

## Setup




- Open **Command Prompt**

<img width="85" height="103" alt="image" src="https://github.com/user-attachments/assets/b2c7dbad-d57b-40d0-9318-ca8d40176c22" />

- **SSH** into the **Linux** machine
```bash
ssh ubuntu@linux.cloudlab.lan
```

<img width="247" height="25" alt="image" src="https://github.com/user-attachments/assets/69706053-abe6-4de7-aa48-d9fd739ec4a7" />



```bash
sudo su -
```






```bash
cd ~/SOC_Analyst_Labs/WebLab
```

```bash
source venv/bin/activate
```
```bash
python app.py
```

<img width="1089" height="261" alt="image" src="https://github.com/user-attachments/assets/32164c4d-bf50-4330-941a-c9fb090d2b95" />


You will need to use the **IP** you got from **tailscale status**

To connect to the site open ``http://100.116.161.87:8000`` **NOTE THAT YOUR IP MAY BE DIFFERENT**

## Go to [Part 2](/SocAnalystLabs/courseFiles/Section_06-webSecurity/webLabPart2.md)

---
[Back to the section](/SocAnalystLabs/courseFiles/Section_06-webSecurity/webSecurity.md)
