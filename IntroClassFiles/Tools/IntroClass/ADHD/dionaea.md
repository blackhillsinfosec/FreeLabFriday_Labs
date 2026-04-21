![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Dionaea

# Ubuntu VM

### In this lab we will
- Observe how it captures malicious connection attempts
- View logs and captured malware samples
- Understand its modular architecture

# Let's start

- Open up a terminal if you are not using **SSH**

- Go the Dionaea's directory

```bash
cd ~/SOC_Analyst_Labs/dionaea/
```

 - Start it up:
```bash
sudo dionaea
```

<img width="1506" height="491" alt="2026-03-18_11-37" src="https://github.com/user-attachments/assets/4cf4bb02-0c36-4bc8-b475-a10f07146c96" />


<br>

Open another terminal!

Let's see it's true power, see what ports it is listening on:
```bash
sudo netstat -tulnp | grep dionaea
```

<img width="941" height="729" alt="2026-03-18_11-39" src="https://github.com/user-attachments/assets/17a98b45-21f5-42ad-8c45-5e97e6f369aa" />


We can see it's listening on lots of ports (FTP, HTTP, SMB, MONGO, MSSQL, SIP, and more)

Let's simulate and FTP bruteforce attack

- Tail the logs:
```bash
sudo tail -f /usr/local/var/log/dionaea/dionaea.log
```

>[!NOTE]
>We have rockyou.txt on **~/Desktop**

- Then on a **third** terminal



```bash
hydra -l admin -P ~/Desktop/rockyou.txt localhost ftp -V
```
We can see all perspectives, the one of the attacker, it is saying that it found passwords, despite it being false to simulate a vulnerable service

<img width="1149" height="908" alt="2026-03-18_11-50" src="https://github.com/user-attachments/assets/fce67025-4cad-425c-aac1-6731b189cbd1" />


<br><br>

And the one of the Analyst, where we see the logs and the credentials used

<img width="1849" height="1011" alt="2026-03-18_11-51" src="https://github.com/user-attachments/assets/3fc7afde-6673-4053-9831-d4d1988ad233" />


<br><br>

Now let's try with mysql instead of ftp:

```bash
hydra -l root -P ~/Desktop/rockyou.txt localhost mysql
``` 
- Same fake success

<img width="1137" height="312" alt="2026-03-18_11-52" src="https://github.com/user-attachments/assets/3e2d339c-3c49-4622-986a-35a194ebcdf1" />


<br><br>


What about **Command Injection**?
```bash
curl "http://localhost/index.php?cmd=ls"
```

For each of those commands try to understand the logs

Let's try an agressive port scan using **nmap**
```bash
nmap -A localhost
```

## Final thoughts
Dionaea’s true power comes from its purpose-built design as an intelligent malware-catching honeypot — not just a passive listener, but a smart, low-interaction trap

Most important features
- Smart Protocol Emulation
- Binary Capture Engine
- Integrated SQLite Logging
- Wide Protocol Coverage
- Python + C Plugin Architecture
- Visual and Analytical Integration



***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/CuckooSandbox.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Haraka.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---

