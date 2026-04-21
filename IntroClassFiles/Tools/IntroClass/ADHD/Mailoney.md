![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Mailoney

You’ll deploy **Mailoney** (a low-interaction SMTP honeypot) and then **simulate simple email-based attacks** to see what it captures

---

# Setup

- Open a terminal

```bash
cd ~/ADCD/mailoney
```

```bash
source venv/bin/activate
```

---

# Start Mailoney (SQLite + port 2525)

We’ll run Mailoney on:
- IP: `127.0.0.1`
- Port: `2525`
- Database: `sqlite:///mailoney.db` (a file in this folder)

Start it:
```bash
python main.py \
  --ip 127.0.0.1 \
  --port 2525 \
  --server-name mail.lab \
  --db-url sqlite:///mailoney.db \
  --log-level INFO
```

<img width="1197" height="565" alt="2026-03-16_12-56" src="https://github.com/user-attachments/assets/105789a4-c49e-41e3-a811-0b35dcaba586" />


Leave this terminal open (it will show logs)

> If you stop it later: press **Ctrl+C**

---

# Verify it’s listening

Open a **second terminal**, go back to the same folder, and activate the venv again:

```bash
cd ~/ADCD/mailoney
```

```bash
source venv/bin/activate
```

Check the listening port:
```bash
ss -lntp | grep 2525
```

<img width="924" height="49" alt="2026-03-16_12-57" src="https://github.com/user-attachments/assets/cc17d320-9c7a-4cd4-8cc3-948f3b2798ac" />


You should see something listening on `127.0.0.1:2525`

---

# Simulate a basic SMTP “email delivery”

We’ll use **swaks** (Swiss Army Knife for SMTP)

Send a test email into the honeypot:
```bash
swaks \
  --server 127.0.0.1 \
  --port 2525 \
  --from alice@demo.local \
  --to bob@demo.local \
  --header "Subject: Hello from the lab" \
  --body "This is a harmless test message captured by Mailoney."
```

- Back in the **Mailoney Terminal**, we can see the hit

<img width="546" height="29" alt="2026-03-16_12-58" src="https://github.com/user-attachments/assets/34bdde8e-264a-4d13-83d0-50eea8f03cab" />

- Go back to the **Second Terminal** and do this to get the data received by the honeypot from the last hit
```bash
sqlite3 -header -column mailoney.db \
"SELECT id, timestamp, ip_address, session_data
 FROM smtp_sessions
 ORDER BY timestamp DESC
 LIMIT 1;"
```

<img width="1904" height="510" alt="2026-03-16_13-00" src="https://github.com/user-attachments/assets/01273dfd-e8ae-4dbf-926d-8c35b90b2caa" />



---

# Simulate a credential-harvesting attempt

Attackers often try weak credentials on SMTP servers

Run this to attempt SMTP AUTH LOGIN:
```bash
swaks \
  --server 127.0.0.1 \
  --port 2525 \
  --auth LOGIN \
  --auth-user admin \
  --auth-password 'Password123!' \
  --quit-after AUTH
```

**What to observe**
- Even if auth does not truly “succeed” (it’s a honeypot), Mailoney is designed to **capture the authentication attempt**


## Inspect what Mailoney captured

```bash
sqlite3 -header -column mailoney.db \
"SELECT id, timestamp, ip_address, session_data
 FROM smtp_sessions
 ORDER BY timestamp DESC
 LIMIT 1;"
```


<img width="1902" height="375" alt="2026-03-16_13-09" src="https://github.com/user-attachments/assets/cf8fcce6-3932-4307-9b69-c91b6ebf9186" />












***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/bluespawn/Bluespawn.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/GoPhish.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
