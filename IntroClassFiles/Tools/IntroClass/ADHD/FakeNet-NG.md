![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# FakeNet-NG

#### Please Use the Ubuntu VM

<hr>

## Lab Objective:
- Run **FakeNet-NG** on Linux
- See how it intercepts and emulates network services
- Simulate “malware-like” traffic from the same host
- Inspect logs / captures to understand what happened

---

## Step 1: Start FakeNet-NG
Open up a **terminal** and run:

```bash
cd ~/ADCD/fakenet-ng
```

```bash
source venv/bin/activate
```

```bash
sudo fakenet -c lab.ini
```

You should see something like:

<img width="1220" height="381" alt="img01" src="https://github.com/user-attachments/assets/9f09028b-7beb-4745-9963-5ffe85027e7c" />

**FakeNet-NG** will **keep running in the foreground**

Leave this terminal window open. This is your **“Deception / Analyst” view**

---

## Step 2: What is FakeNet-NG Listening On?

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

## Step 3: Simulate Web "Malware" Traffic

While FakeNet-NG is still running in **Terminal 1**, start another terminal.
In **Terminal 2**, we'll play the role of the "malware" sending traffic.

> [!NOTE]
> Since the DNS listener is disabled in `lab.ini`, we use `--resolve` to bypass DNS lookup and connect directly to FakeNet-NG on `127.0.0.1`.

<br>

### HTTP Request to a Domain

```bash
curl http://totally-not-evil-c2.com/ --resolve totally-not-evil-c2.com:80:127.0.0.1
```

Watch **Terminal 1** (FakeNet-NG window):

- You should see an HTTP request logged by FakeNet-NG.
- FakeNet-NG will return some default HTML content in Terminal 2:

<img width="761" height="519" alt="img02" src="https://github.com/user-attachments/assets/2b01a0c0-3e62-4efb-8d84-2408a34dbe24" />

<br>

### HTTPS request (FakeNet as fake TLS server)

```bash
curl https://really-bad-c2.example/ -k --resolve really-bad-c2.example:443:127.0.0.1
```

---

## Step 4: Simulate FTP "Malware" Traffic

Some malware uses **FTP** to exfiltrate data or download additional payloads.
FakeNet-NG has a fully emulated FTP server listening on port **21**.

<br>

### Connect to the fake FTP server

```bash
ftp 127.0.0.1
```

When prompted, enter any username and password - FakeNet-NG will accept them:

```
Name: malware
Password: infected
```

<img width="439" height="169" alt="img03" src="https://github.com/user-attachments/assets/3579d43b-6e86-4265-ba23-094bd0fdf764" />

Watch **Terminal 1** (FakeNet-NG window):

- You should see the FTP connection logged with the banner FakeNet-NG presents
- The fake credentials you entered will be captured in the logs

<img width="1202" height="180" alt="2026-03-17_22-27" src="https://github.com/user-attachments/assets/ee19fad5-11d4-4414-9538-b23c9ebb8568" />

<br>

### Try some FTP commands

Once connected, try a few commands to generate more traffic:

```ftp
ls
pwd
get secret-data.txt
quit
```

<img width="536" height="419" alt="img04" src="https://github.com/user-attachments/assets/538081f1-aafe-4350-8779-2b4402165ee0" />

Watch **Terminal 1**:

- Each command will be logged by FakeNet-NG
- FakeNet-NG will respond as if it were a real FTP server
- File requests will be served from the `defaultFiles/` webroot defined in `lab.ini`

> In a real investigation, captured FTP credentials and filenames are valuable **IOCs**
> that reveal what data the malware was trying to steal or download.

---

## Step 5: Port-Scanning "malware"

Now we'll pretend the malware is scanning common service ports.

<br>

### Scan common ports on localhost

```bash
nmap -Pn -p 21,25,53,80,443,110,1337 127.0.0.1
```

From **nmap's perspective** (attacker view), it will look like these ports are open 
and responding on `127.0.0.1`.

<img width="668" height="272" alt="img05" src="https://github.com/user-attachments/assets/eab1e4dc-1099-4c43-87cc-16f589d4b0bb" />

> [!NOTE]
> When FakeNet is active on Linux, **SYN** scans often show ports as **filtered**.
> This happens because **FakeNet** intercepts packets using **iptables**/**NFQUEUE**.

In **Terminal 1** (FakeNet-NG), you'll see many connection attempts logged
against the emulated services.

You can push it further with a more aggressive scan (optional, but noisy):

```bash
nmap -sS -p- 127.0.0.1
```

FakeNet-NG will try to keep up and emulate responses, again acting as a fake, but convincing, network.

---

## Step 6: Look at Captures & Logs

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

>[!Note]
>
>If you want to continue with another lab after completing this one, **restart the VM session first**.
