![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# FakeNet-NG

# For the Ubuntu VM


### In this lab we will
- Run **FakeNet-NG** on Linux
- See how it intercepts and emulates network services
- Simulate “malware-like” traffic from the same host
- Inspect logs / captures to understand what happened

---

## Start FakeNet-NG (the fake Internet)

- Open up a **terminal** and run

```bash
cd ~/ADCD/fakenet-ng
```

```bash
sudo fakenet -c lab.ini
```

You should see something like:

<img width="948" height="512" alt="2026-03-17_11-39" src="https://github.com/user-attachments/assets/fbae2273-cdd7-4a7e-9fc3-28640bdd2faf" />


**FakeNet-NG** will **keep running in the foreground**

Leave this terminal window open. This is your **“Deception / Analyst” view**

---

## See what FakeNet-NG is listening on

Open a **second terminal**.

### List listening ports

```bash
sudo ss -tulnp | grep -i fakenet
```

<img width="1022" height="247" alt="2026-03-17_11-48" src="https://github.com/user-attachments/assets/a29d299f-daa5-4cf3-81bb-e18d07e5d1fa" />



You should see FakeNet-NG listening on multiple ports, for example:

- 80 (**HTTP**)
- 443 (**HTTPS/SSL**)
- 21 (**FTP**)
- 25 (**SMTP**)
- Others depending on your version/config

> FakeNet-NG pretends to be many services at once,
> so “**malware**” thinks it is talking to the real **Internet**

---

## Simulate simple web "malware" traffic

- FakeNet-NG is still running in **terminal 1**.  
- In **terminal 2**, we'll play the role of the "malware" sending traffic.

> [!NOTE]
> Since the DNS listener is disabled in `lab.ini`, we use `--resolve` to bypass DNS lookup and connect directly to FakeNet-NG on `127.0.0.1`.

### HTTP request to a domain

```bash
curl http://totally-not-evil-c2.com/ --resolve totally-not-evil-c2.com:80:127.0.0.1
```

Watch **terminal 1** (FakeNet-NG window):

- You should see an HTTP request logged by FakeNet-NG
- FakeNet-NG will return some default HTML content in terminal 2:

<img width="1422" height="727" alt="2026-03-17_22-13" src="https://github.com/user-attachments/assets/d693ec6f-6486-4319-9246-05a6a796d22f" />


### HTTPS request (FakeNet as fake TLS server)

```bash
curl https://really-bad-c2.example/ -k --resolve really-bad-c2.example:443:127.0.0.1
```

---

## Simulate FTP "malware" traffic

Some malware uses **FTP** to exfiltrate data or download additional payloads.
FakeNet-NG has a fully emulated FTP server listening on port **21**.

### Connect to the fake FTP server

```bash
ftp 127.0.0.1
```

When prompted, enter any username and password - FakeNet-NG will accept them:

```
Name: malware
Password: infected
```

<img width="477" height="227" alt="2026-03-17_22-28" src="https://github.com/user-attachments/assets/7ac5ae8d-02a7-4eee-9eca-a8840e3cc6ae" />

Watch **terminal 1** (FakeNet-NG window):

- You should see the FTP connection logged with the banner FakeNet-NG presents
- The fake credentials you entered will be captured in the logs

<img width="1202" height="180" alt="2026-03-17_22-27" src="https://github.com/user-attachments/assets/ee19fad5-11d4-4414-9538-b23c9ebb8568" />


### Try some FTP commands

Once connected, try a few commands to generate more traffic:

```ftp
ls
pwd
get secret-data.txt
quit
```

<img width="761" height="551" alt="2026-03-17_22-28" src="https://github.com/user-attachments/assets/b7e3dc00-79c5-4a76-a453-a5b4bf3d7435" />


Watch **terminal 1**:

- Each command will be logged by FakeNet-NG
- FakeNet-NG will respond as if it were a real FTP server
- File requests will be served from the `defaultFiles/` webroot defined in `lab.ini`

> In a real investigation, captured FTP credentials and filenames are valuable **IOCs**
> that reveal what data the malware was trying to steal or download.

---

## Simulate a port-scanning "malware"

Now we'll pretend the malware is scanning common service ports.

### Scan common ports on localhost

```bash
nmap -Pn -p 21,25,53,80,443,110,1337 127.0.0.1
```

- From **nmap's perspective** (attacker view), it will look like these ports are open
  and responding on `127.0.0.1`.

<img width="739" height="333" alt="2026-03-17_22-24" src="https://github.com/user-attachments/assets/0e535802-6d03-41e1-a64e-a63e67cc1093" />


> [!NOTE]
> When FakeNet is active on Linux, **SYN** scans often show ports as **filtered**.
> This happens because **FakeNet** intercepts packets using **iptables**/**NFQUEUE**.

- In **terminal 1** (FakeNet-NG), you'll see many connection attempts logged
  against the emulated services.

You can push it further with a more aggressive scan (optional, but noisy):

```bash
nmap -sS -p- 127.0.0.1
```

FakeNet-NG will try to keep up and emulate responses, again acting as a fake, but convincing, network.

---

## Look at captures / logs

Stop FakeNet-NG by going to **terminal 1** and pressing:

```text
Ctrl + C
```

Depending on version/config, FakeNet-NG will:

- Save a **PCAP** file with captured traffic

In the directory where you started FakeNet-NG, run:

```bash
ls
```

Look for `*.pcap` files

If you see a `.pcap` file, you can open it with Wireshark later for deeper analysis:

```bash
wireshark captured_traffic.pcap
```


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/canarytokens/Canarytokens.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/DNSChef.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
