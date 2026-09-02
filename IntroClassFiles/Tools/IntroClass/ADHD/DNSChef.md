![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# DNSChef


#### Please Use the Ubuntu VM

<hr>

## Lab Objective

- Install and run **DNSChef** (a DNS proxy / spoofing tool)
- Observe how it **logs DNS queries**
- See how it can **spoof DNS answers** for specific domains
- Use it as a **deception tool** by pointing a domain to a fake service


---

## Step 1: Understanding DNS resolution

Before using **DNSChef**, see what your **DNS** looks like normally.

<br>

### Check where DNS queries go by default

```bash
cat /etc/resolv.conf
```

<img width="225" height="72" alt="2026-03-17_11-27" src="https://github.com/user-attachments/assets/9e2eefc7-8435-4d26-aaee-6791ace9da4c" />

That’s your current **DNS resolver**

<br>

### Resolve a Domain Normally

```bash
dig example.com +short
```

<img width="470" height="68" alt="2026-03-17_11-28" src="https://github.com/user-attachments/assets/60e8a224-eef2-43eb-afd1-bde3855e43ef" />

Note the IP address you get.<br>
This is the **legitimate** DNS answer from your normal resolver.

We’ll **compare** this later with the **spoofed** result.

---

## Run DNSChef as a logging DNS proxy

First, we’ll use DNSChef to **observe** DNS traffic, without spoofing anything.

<br>

### Start DNSChef (logging only)

Open **Terminal 1** and run:

```bash
cd ~/ADCD/dnschef/
```

```bash
sudo python3 dnschef.py --interface 0.0.0.0 --port 53530 --nameserver 8.8.8.8
```

Explanation:

`--interface 0.0.0.0` – listen on all interfaces<br>
`--nameserver 8.8.8.8` – forward all queries to Google DNS, without changes

You should see DNSChef starting and waiting for queries.<br> 
Keep this terminal open.

<img width="730" height="280" alt="2026-03-17_11-29" src="https://github.com/user-attachments/assets/9ee71875-4703-4326-8796-74f7d5ea7f9c" />

<br>

### Send queries to DNSChef

Open **Terminal 2** and run:

```bash
dig @127.0.0.1 -p 53530 www.google.com
dig @127.0.0.1 -p 53530 example.com
dig @127.0.0.1 -p 53530 www.wikipedia.org
```

`@127.0.0.1` tells `dig` to use DNSChef (listening on localhost) as the DNS server

Watch **Terminal 1** (DNSChef):

You should see **logs** of each **query** being made and the response from **upstream**.<br>
This is what a defender/analyst would see when monitoring DNS traffic.

<img width="820" height="88" alt="2026-03-17_11-31" src="https://github.com/user-attachments/assets/a8bc528d-ef65-49bf-9bd9-5b2b960aceb6" />

You can stop **DNSChef** with `Ctrl + C` in **Terminal 1**.

We’ll restart it in the next steps with **spoofing enabled**.

<hr>

## Step 2: Simple DNS spoofing (fake IP for all domains)

Now let’s use **DNSChef** to **lie** about where domains point to.

We’ll make **every** DNS query resolve to the same IP.

For demonstration, we’ll use `127.0.0.1` (your own machine).

<br>

### Start DNSChef with global IP spoofing

In **Terminal 1**:

```bash
sudo python3 dnschef.py --interface 0.0.0.0 --port 53530 --fakeip 127.0.0.1
```

`--fakeip 127.0.0.1` – return `127.0.0.1` for **all A-record (IPv4)** DNS queries.
No upstream **DNS server** is specified now – **DNSChef** always responds with the fake IP.

<br>

### Test Spoofing With Dig

In **Terminal 2**:

```bash
dig @127.0.0.1 -p 53530 example.com +short
dig @127.0.0.1 -p 53530 www.google.com +short
dig @127.0.0.1 -p 53530 anyrandomdomainthatdoesnotexist123.com +short
```

<img width="1156" height="172" alt="2026-03-17_11-33" src="https://github.com/user-attachments/assets/0eee9628-45bb-4c55-bbf1-2d353a513a6c" />

You should see that all of them return:

```text
127.0.0.1
```

From the **attacker** perspective:

Any client using this DNS server will be redirected to **your** IP.

From the **defender/deception** perspective:

You can point **malware** or suspicious hosts to a **sinkhole** IP where you log or analyze them.

Stop DNSChef with `Ctrl + C` in **Terminal 1** when you’re done.

---

## Step 3: Targeted Spoofing

Let's now try targeted spoofing of a single domain (with upstream passthrough).

Global spoofing is noisy and easy to detect.

A more realistic use case is to **spoof only one domain** and let others resolve normally.

<br>

### Scenario

- Only `login.badbank.test` should be spoofed to a fake IP (our machine).
- All other domains should resolve via a real DNS server (e.g. `8.8.8.8`).

<br>

### Selective Spoofing
Now, lets start DNSChef with selective spoofing.<br>
In **Terminal 1**:

```bash
sudo python3 dnschef.py \
  --interface 0.0.0.0 \
  --port 53530 \
  --nameserver 8.8.8.8 \
  --fakeip 127.0.0.1 \
  --fakedomains login.badbank.test
```

<img width="876" height="282" alt="2026-03-17_11-34" src="https://github.com/user-attachments/assets/4c845001-ca6f-4e03-b1b8-07172b78cdf6" />

Explanation:

- `--fakeip 127.0.0.1` – fake IP to return
- `--fakedomains login.badbank.test` – spoof **only** this domain
- `--nameserver 8.8.8.8` – use Google DNS for all other domains (pass-through)

<br>

### Test the spoofed domain vs normal domains

In **Terminal 2**:

```bash
# Spoofed domain
dig @127.0.0.1 -p 53530 login.badbank.test +short
```

```bash
# Normal domains (pass-through to real DNS)
dig @127.0.0.1 -p 53530 example.com +short
```

```bash
dig @127.0.0.1 -p 53530 www.google.com +short
```

`login.badbank.test` should resolve to `127.0.0.1`.<br>
Other domains should resolve to their **real IP addresses** (similar to your earlier tests).

<img width="955" height="84" alt="2026-03-17_11-36" src="https://github.com/user-attachments/assets/7ad81fbc-2522-4019-bb09-13e056408013" />