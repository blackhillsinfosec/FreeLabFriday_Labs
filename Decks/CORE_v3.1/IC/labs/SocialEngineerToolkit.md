![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Social Engineering Toolkit (SET)

# Ubuntu VM

---

## In this lab we will

- Clone a real website to create a credential harvester
- Send a simulated phishing payload using SET's built-in tools
- Understand how attackers think - so defenders can stop them

---

## What is SET?

The **Social Engineering Toolkit (SET)** is an open-source penetration testing framework designed specifically for **social engineering attacks**. It was created by TrustedSec and comes pre-installed on Kali Linux. It automates attacks like:

- **Credential Harvesting** - cloning websites to steal logins
- **Phishing Emails** - crafting convincing fake emails
- **Payload Generation** - creating malicious files
- **QR Code Attacks** - embedding malicious links in QR codes

---

## Launching SET

- Launch the toolkit:

```bash
sudo setoolkit
```

<img width="687" height="682" alt="2026-04-08_12-06" src="https://github.com/user-attachments/assets/8c80bf20-c5be-4db9-8c55-773041576a27" />


This is the SET main menu, everything is **number-driven** - you just type the number and press Enter

---

## Credential Harvester Attack (Website Cloning)

This is one of SET's most well-known features. It clones a real website and captures any credentials typed into it - all running **on your own machine**.

### Step 1 - Enter Social Engineering Attacks

```
set> 1
```

You will see:

<img width="484" height="373" alt="2026-04-08_12-08" src="https://github.com/user-attachments/assets/d7640b4f-8401-4c0d-b159-337a2035e510" />


### Select Website Attack Vectors

```
set> 2
```

You will see:

<img width="998" height="650" alt="2026-04-08_12-10" src="https://github.com/user-attachments/assets/90efe03d-a604-4051-917a-2944f88fb155" />


### Select the Credential Harvester Attack Method

```
set:webattack> 3
```

You will see:

<img width="711" height="417" alt="2026-04-08_12-11" src="https://github.com/user-attachments/assets/2ccba603-79ff-4f8f-bb5b-771259e44fdd" />


### Use the Site Cloner

```
set:webattack> 2
```

SET will ask for your IP address (where the fake site will be hosted):

```
set:webattack> IP address for the POST back in Harvester/Tabnabbing:
```

Type your local machine IP. To find it, open **another terminal** and run:

```bash
ifconfig ens5 | grep inet | cut -d" " -f10
```

Use the IPv4 shown (something like `10.x.x.x`). Type it and press Enter

<img width="675" height="92" alt="2026-04-08_12-18" src="https://github.com/user-attachments/assets/2ae88884-8266-4b9e-9892-1e490914be09" />


### Enter the site to clone

SET will ask which URL to clone:

```
set:webattack> Enter the url to clone: http://testaspnet.vulnweb.com/login.aspx
```

> We are cloning **http://testaspnet.vulnweb.com/login.aspx** - this is a **deliberately vulnerable test site** created by Acunetix specifically for security testing. It is safe and legal to use

SET will clone the site and start a web server on port **80**.

You will see:

<img width="1400" height="279" alt="2026-04-08_12-21" src="https://github.com/user-attachments/assets/4b7bd96f-78f1-408c-bf68-c30f4a0beb0b" />


### Open the fake site in your browser

Open your browser and go to:

```
http://127.0.0.1
```

You will see a **pixel-perfect clone** of the login page. Go ahead and type in some fake credentials:

- **Username:** `testuser`
- **Password:** `Password123`

Click the login button

### Watch SET capture the credentials

Go back to your terminal where SET is running. You will see the captured data printed in **real time**:

<img width="948" height="414" alt="2026-04-08_12-24" src="https://github.com/user-attachments/assets/3853a2f9-5264-4aae-b53e-a66ce53d1e21" />


SET captured everything typed into the fake form - **username, password, and more** - without the "victim" knowing anything happened

### Stop the harvester

Press `CTRL+C` to stop the server. SET will automatically generate a report saved to:

<pre>/root/.set/reports/</pre>

View it:

```bash
sudo sh -c 'cat /root/.set/reports/*.xml'
```

---

## QR Code Attack Generator

QR code attacks redirect victims to a malicious URL - like your credential harvester page - without them seeing a suspicious link. Attackers use these on flyers, emails, and posters.

SET has a built-in QR code generator but it requires Metasploit to be installed. We will use `qrencode` directly instead, which does the exact same thing.

- Generate a QR code pointing to your harvester page:

```bash
qrencode -o ~/qrcode.png "http://10.10.77.7"
```

- View the generated QR code:

```bash
eog ~/qrcode.png
```

<img width="1100" height="497" alt="2026-04-09_00-13" src="https://github.com/user-attachments/assets/4c637931-4a16-4cc7-8827-8633b2181788" />

You will see a QR code image. Scan it with your phone - it will take you straight to `http://10.10.77.7`, which is your cloned login page.



> **What this demonstrates:** Attackers print or share these QR codes in public (flyers, emails, fake posters, business cards) to redirect victims to phishing pages - bypassing URL suspicion entirely since people do not "read" a QR code before scanning it.

---

## Exploring the Spear Phishing Menu

Go back to the main menu:

```
set> 1

set> 1
```

You will see options like:

<img width="848" height="390" alt="2026-04-09_11-17" src="https://github.com/user-attachments/assets/0532cd25-3616-4b27-8f27-3de13598ad54" />


- Option **1** lets you send a phishing email with an attached payload to a target
- Option **2** lets you embed payloads in `.pdf`, `.docx`, `.xlsx` files
- Option **3** lets you craft a custom email template

**This is how real attackers operate.** A crafted email + a weaponized attachment = a convincing spear phishing campaign that bypasses most user awareness

Type `99` or press `CTRL+C` to exit without sending anything






---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/Phishing.md)



> Created by Turcu-Stiolica Alexandru
