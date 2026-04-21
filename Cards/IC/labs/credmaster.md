![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# CredMaster

# Ubuntu VM

---

## What is CredMaster?

**CredMaster** is a password spraying framework used by penetration testers and red teams. Unlike brute-force attacks that try every password against one account, **password spraying** tries one or a few common passwords against many accounts - slowly - to avoid account lockouts.

CredMaster is built around **plugins** that target different authentication services (Office 365, Okta, AWS, VPNs, etc.) and can optionally distribute requests through AWS Lambda to rotate IP addresses. In this lab we skip the cloud rotation and spray against a local server we control.

---

### Spin up the Mock-up server meant for the Password Spray

Open up a terminal

```bash
cd ~/BnB/credMaster
```

```bash
python3 mock_auth_server.py
```

<img width="705" height="116" alt="2026-04-09_12-40" src="https://github.com/user-attachments/assets/afa7dfc5-4373-4d75-9027-6c1c7700250f" />

---

## Open the Defender View

Before spraying, open a **second terminal** to watch the server logs live - this is the blue team / analyst perspective:

```bash
tail -f /tmp/auth_server.log
```

Leave this running. Every login attempt will appear here in real time as CredMaster works through the lists.

---

## Run the Password Spray

You now have three terminals running:
- **Terminal 1** - the mock auth server (target)
- **Terminal 2** - the live log watcher (defender)
- **Terminal 3** - free


Before running the spray we need to create an **AWS Account**, go here and make an account: https://aws.amazon.com/

<img width="785" height="135" alt="2026-04-09_13-24" src="https://github.com/user-attachments/assets/edb3cf0a-f47a-41d1-b92c-b1303fac1051" />

Afert you have made an account, go here: https://us-east-1.console.aws.amazon.com/iam/home?region=eu-north-1#/users and create a new user

<img width="581" height="240" alt="2026-04-09_14-13" src="https://github.com/user-attachments/assets/98b39c9e-d0f3-4d59-a557-2e0f0015eb10" />


<img width="742" height="340" alt="2026-04-09_14-14" src="https://github.com/user-attachments/assets/16c022dc-ea0d-4d09-a68c-895847e037ee" />

<img width="1438" height="688" alt="2026-04-09_14-15" src="https://github.com/user-attachments/assets/ae4f4352-0fc6-4676-8444-d1c749c5c49b" />

After creating the user with the settings from above, you should see this:

<img width="705" height="283" alt="2026-04-09_14-17" src="https://github.com/user-attachments/assets/4ec235cb-b54b-4b6f-8681-7f89cf3193c7" />

Click on the user and then click `Create access key`

<img width="1615" height="815" alt="2026-04-09_14-19" src="https://github.com/user-attachments/assets/159e0f4b-7187-4f76-ba92-8152b6287d75" />

Select `Command Line Interface (CLI)` and click though the confirmation

<img width="1213" height="778" alt="2026-04-09_14-20" src="https://github.com/user-attachments/assets/3873d292-319d-4854-953b-dad487f0477f" />

Now this is REALLY IMPORTANT, save the **Access Key** and the **Secret access key**

<img width="1155" height="526" alt="2026-04-09_14-21" src="https://github.com/user-attachments/assets/80458a46-8a6b-446b-af9c-83564e7bc372" />



In Terminal 3, let's get the credentials for our spray

```bash
printf "aaron\nadam\nadmin\nalex\nalice\nandrew\nanna\nbarbara\nbrian\ncharles\nchris\ndavid\ndiana\nedward\nemma\n" > ~/Desktop/names.txt

sudo wget -O ~/Desktop/top-passwords-shortlist.txt \
  https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/top-passwords-shortlist.txt
```

Now the last step is to make the mock server accessible to the internet with **ngrok**

Finally go to: ngrok.com and make an account

After making an account, navigate here: https://dashboard.ngrok.com/get-started/setup/linux and grab this command and run it in the terminal:



<img width="1092" height="720" alt="2026-04-10_12-48" src="https://github.com/user-attachments/assets/e5856e02-4134-4ea2-b7d4-ed84f51f1226" />

Now run:

```bash
ngrok http 5000
```

Grab that link, we will use that:

<img width="1110" height="150" alt="2026-04-10_12-54" src="https://github.com/user-attachments/assets/aa41b775-11f9-4794-b10b-27eb1b2fcc85" />


Finally open a **4th Terminal**

Run the spray with your AWS Keys:

```bash
cd ~/BnB/credMaster/CredMaster
```

```bash
source venv/bin/activate
```

```bash
python3 credmaster.py \
  --plugin httppost \
  -u ~/Desktop/names.txt \
  -p ~/Desktop/top-passwords-shortlist.txt \
  --access_key YOUR_AWS_KEY \
  --secret_access_key YOUR_AWS_SECRET \
  --pluginargs url YOUR_NGROK_DOMAIN/auth/login content-type json \
  --delay 0 \
  --jitter 0
```

**What these flags do:**

| Flag | Meaning |
|------|---------|
| `--plugin httppost` | Use the built-in HTTP POST plugin |
| `-u` | File containing usernames to spray |
| `-p` | File containing passwords to try |
| `--access_key` | AWS access key for FireProx API Gateway |
| `--secret_access_key` | AWS secret key for FireProx API Gateway |
| `--pluginargs url` | The target login endpoint (via ngrok) |
| `--pluginargs content-type json` | Send the body as JSON |
| `--delay 0` | No delay between attempts |
| `--jitter 0` | No random extra delay |

> The `--delay` and `--jitter` flags are critical in real engagements - they mimic human timing to stay under lockout thresholds. They also make the output easier to follow here.

Watch **both perspectives** as it runs:

**Attacker terminal** - CredMaster will find multiple hits since 15 accounts all share the weak passwords:

<img width="1067" height="862" alt="2026-04-10_13-21" src="https://github.com/user-attachments/assets/a3626ff1-6c82-4e03-9227-3716a2d18792" />


**Defender terminal** - the log shows every attempt in real time:

<img width="1074" height="676" alt="2026-04-10_13-22" src="https://github.com/user-attachments/assets/c78f2398-a933-481c-b278-cd3ca1a5c5cb" />

<img width="455" height="107" alt="2026-04-10_13-24" src="https://github.com/user-attachments/assets/2c294804-c931-4953-addb-6b65ca09b0e0" />


The pattern is unmistakable from the defender's view: the **same IP cycling through hundreds of usernames, one password at a time, and hitting multiple accounts**. That is the signature of a spray - and exactly why a single weak password policy can compromise an entire organisation at once.

---

## View the Results

After the run completes, check what CredMaster saved:

```bash
cat ~/BnB/credMaster/CredMaster/credmaster-success.txt
```

You should see all 15 compromised accounts listed

View the complete log:

```bash
cat /tmp/auth_server.log
```

Count total attempts made:

```bash
wc -l /tmp/auth_server.log
```

---

## Detection Exercises

Now think like a defender. Run these against the log:

**How many unique usernames were targeted?**
```bash
grep "LOGIN ATTEMPT" /tmp/auth_server.log | grep -oP 'User: \K[^\s|]+' | sort -u | wc -l
```

**Which passwords were tried most often?**
```bash
grep "LOGIN ATTEMPT" /tmp/auth_server.log | grep -oP 'Pass: \K.*' | sort | uniq -c | sort -rn | head
```

**How many failed attempts happened before the successful one?**
```bash
grep -c "FAILED" /tmp/auth_server.log
```

**What was the time window of the entire attack?**
```bash
head -1 /tmp/auth_server.log && tail -1 /tmp/auth_server.log
```

> **Defender insight:** A SIEM rule that fires on "more than 10 failed logins from the same IP across more than 5 different accounts within 10 minutes" would catch this spray immediately. The delay and jitter slow it down but do not change the underlying pattern.










---

# Finished?

[Back to External_Password_Spray's Main Page](/Cards/IC/External_Password_Spray.md)

[Back to Credential_Stuffing's Main Page](/Cards/IC/Credential_Stuffing.md)

---

> Created by Turcu-Stiolica Alexandru

