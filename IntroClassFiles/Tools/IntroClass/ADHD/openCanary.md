![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# For the Ubuntu VM


# OpenCanary 

**Goal:** Deploy a simple **OpenCanary** honeypot, trigger a few attacks (port scan, **SSH/SMB probe**, simple **HTTP request**), and observe **alerts**

---

# Setup

- Install mysql client for the use in the lab

```bash
sudo apt install mysql-client-core-8.0
```

- Go to its directory

```bash
cd ~/ADCD/openCanary
```

- Activate the **Virtual Environment**
```bash
source env/bin/activate
```

### Create and edit the config
Still inside your virtualenv:

- Create the default config (this prints the location)
```bash
opencanaryd --copyconfig
```

<img width="1632" height="132" alt="img_01" src="https://github.com/user-attachments/assets/ab78d32a-f45d-4b5c-a811-4eaead4d0659" />

- Make sure it is there

```bash
sudo ls -l /etc/opencanaryd/opencanary.conf
```

<img width="1147" height="57" alt="img_02" src="https://github.com/user-attachments/assets/34f5b53c-fa09-4d05-bf74-26d657e9e674" />

- Now open the config and make small edits. Example uses `nano` (or `vi`):

```bash
sudo nano /etc/opencanaryd/opencanary.conf
```

- Inside the JSON config make these **minimal** changes to enable a few services and a log file:

1. Locate the `"device.node_id"` and set a friendly name like `"opencanary-lab"`

```
"device.node_id": "opencanary-lab"
```

2. In the `"modules"` (or top-level service entries) enable the following:

```json
"ssh": {"enabled": true},
"ssh": {"port": 222},
"http": {"enabled": true},
"http": {"port": 8082},
"ftp": {"enabled": true},
"mysql": {"enabled": true},
"mysql": {"log_connection_made": true},
"telnet": {"enabled": true},
"portscan": {"enabled": true}
```

<img width="1200" height="722" alt="img_03" src="https://github.com/user-attachments/assets/4c648111-5328-4265-8d85-3ba704708235" />
<img width="1170" height="495" alt="img_04" src="https://github.com/user-attachments/assets/5e51e170-1986-4411-8b6f-c04c3598969f" />
<img width="1172" height="217" alt="img_05" src="https://github.com/user-attachments/assets/2e846bd7-02eb-478f-a6a6-96ba86691c77" />


- Save and exit with `Ctrl + x` and `y` and `Enter`


---

## Start

- Run it

>[!NOTE]
> Make sure you are in **~/ADCD/openCanary** with **venv** activated

```bash
opencanaryd --start
# To stop:
opencanaryd --stop
```

<img width="1898" height="541" alt="img_06" src="https://github.com/user-attachments/assets/9ad67aff-2d3f-429f-aebd-805a0e682931" />


- If you configured file logging as above, check the log:

```bash
sudo tail -n 50 /var/tmp/opencanary.log
```

<img width="1900" height="337" alt="img_07" src="https://github.com/user-attachments/assets/71514b52-d90a-4bd4-a1ed-c7a28429274a" />


---

## Simple attacker 
Perform these actions from a second terminal (or another device on the same network). Replace `<CANARY_IP>` with the IP address of the VM.

1. Port scan (nmap)
```bash
sudo nmap -sV -sC -Pn -p 21,23,222,3306,8082 localhost
```

<img width="1897" height="721" alt="img_08" src="https://github.com/user-attachments/assets/be1e0a45-96b4-4eb5-aa50-46fee364392e" />


- **OpenCanary's** `portscan` module should flag the scan, so let's check!

```bash
sudo tail -n 50 /var/tmp/opencanary.log
```

<img width="1901" height="773" alt="img_09" src="https://github.com/user-attachments/assets/3168032c-c6f3-43c0-a010-b4248dfb0297" />


BOOM!

2. SSH probe (attempt to connect)
```bash
ssh fakeuser@localhost -p 222
```
This triggers the `ssh` canary

3. HTTP request
```bash
curl http://127.0.0.1:8082/index.html
```
This triggers the `http` canary logs

4. MySQL login attempt
```bash
mysql -h 127.0.0.1 -u root -p
```

5. FTP login attempt
```bash
ftp 127.0.0.1
```

6. TELNET login attempt
```bash
telnet 127.0.0.1
```

- After each action, check the canary log or journal on the honeypot host to see alerts:

```bash
sudo tail -n 50 /var/tmp/opencanary.log
```

<img width="1897" height="452" alt="img_10" src="https://github.com/user-attachments/assets/e7c925b3-2e28-4b7b-80a8-2a493e94078e" />


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Beelzebub.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/HoneyPorts/HoneyPorts.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
