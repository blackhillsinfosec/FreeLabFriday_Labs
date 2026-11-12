---

## What is CredMaster?

**CredMaster** is a password spraying framework used by penetration testers and red teams. Unlike brute-force attacks that try every password against one account, **password spraying** tries one or a few common passwords against many accounts - slowly - to avoid account lockouts.

CredMaster is built around **plugins** that target different authentication services (Office 365, Okta, AWS, VPNs, etc.) and can optionally distribute requests through AWS Lambda to rotate IP addresses. In this lab we skip the cloud rotation and spray against a local server we control.

---

### Spin up the Mock-up server meant for the Password Spray

Let's start by opening **Terminal #1**


Go ahead and run the following two commands:

```bash
cd ~/BnB/credMaster
```

```bash
python3 mock_auth_server.py
```

<img width="705" height="116" alt="2026-04-09_12-40" src="https://github.com/user-attachments/assets/afa7dfc5-4373-4d75-9027-6c1c7700250f" />

Leave this terminal open, and move on.

---

## Step 1: Open the Defender View

Before spraying, open **Terminal #2** to watch the server logs live - this is the **Blue Team** or **Analyst** perspective:

```bash
tail -f /tmp/auth_server.log
```

Leave this running. Every login attempt will appear here in real time as CredMaster works through the lists.

---

## Step 2: Setup AWS Account

Before running the spray we need to create an **AWS Account**.<br>
Go here and make an account: https://aws.amazon.com/

<img width="785" height="135" alt="2026-04-09_13-24" src="https://github.com/user-attachments/assets/edb3cf0a-f47a-41d1-b92c-b1303fac1051" />

Afert you have made an account, go here:<br>
https://us-east-1.console.aws.amazon.com/iam/home?region=eu-north-1#/users <br>

Now hit `Create User`:

<img width="581" height="240" alt="2026-04-09_14-13" src="https://github.com/user-attachments/assets/98b39c9e-d0f3-4d59-a557-2e0f0015eb10" />

<img width="742" height="340" alt="2026-04-09_14-14" src="https://github.com/user-attachments/assets/16c022dc-ea0d-4d09-a68c-895847e037ee" />

<img width="1438" height="688" alt="2026-04-09_14-15" src="https://github.com/user-attachments/assets/ae4f4352-0fc6-4676-8444-d1c749c5c49b" />

After creating the user with the settings from above, you should see this:

<img width="705" height="283" alt="2026-04-09_14-17" src="https://github.com/user-attachments/assets/4ec235cb-b54b-4b6f-8681-7f89cf3193c7" />

Click on the user and then click `Create access key`

<img width="1615" height="815" alt="2026-04-09_14-19" src="https://github.com/user-attachments/assets/159e0f4b-7187-4f76-ba92-8152b6287d75" />

Select `Command Line Interface (CLI)` and click though the confirmation:

<img width="1213" height="778" alt="2026-04-09_14-20" src="https://github.com/user-attachments/assets/3873d292-319d-4854-953b-dad487f0477f" />

>[!IMPORTANT]
>Make sure to save the **Access Key** and the **Secret access key** somewhere safe!<br>
>We will need these later!

<img width="1155" height="526" alt="2026-04-09_14-21" src="https://github.com/user-attachments/assets/80458a46-8a6b-446b-af9c-83564e7bc372" />

Now, open up **Terminal #3**.

You should now have three terminals running:
- **Terminal #1** - the mock auth server (target)
- **Terminal #2** - the live log watcher (defender)
- **Terminal #3** - not yet used

In Terminal 3, let's get the credentials for our spray by running the following:

```bash
printf "aaron\nadam\nadmin\nalex\nalice\nandrew\nanna\nbarbara\nbrian\ncharles\nchris\ndavid\ndiana\nedward\nemma\n" > ~/Desktop/names.txt

sudo wget -O ~/Desktop/top-passwords-shortlist.txt \
  https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/top-passwords-shortlist.txt
```

<hr>

## Step 3: Setup Ngrok Account

Now the last step is to make the mock server accessible to the internet with **ngrok**.

Navigate to https://ngrok.com and make an account.

After making an account, navigate here:<br>
https://dashboard.ngrok.com/get-started/gateway

Once you see the screen below, select `Linux`, then click **Show authtoken** before copying the command.<br>

When you've copied the command with your authtoken shown, run it in **Terminal #3**.

<img width="990" height="1129" alt="image" src="https://github.com/user-attachments/assets/d1548f4b-a658-4bb5-8531-e14f2bd1b34a" />

Now run the following in **Terminal #3**:

```bash
ngrok http 5000
```

Grab the link in the **Forwarding** section. We will need it later.

<img width="1110" height="150" alt="2026-04-10_12-54" src="https://github.com/user-attachments/assets/aa41b775-11f9-4794-b10b-27eb1b2fcc85" />

<hr>

## Step 4: Run The Spray

Finally, open **Terminal #4**.

Start by navigating to the correct directory once more:

```bash
cd ~/BnB/credMaster/CredMaster
```

Now set the source:

```bash
source venv/bin/activate
```

<br>

Run the spray with **YOUR** AWS Keys and Ngrok Domain:

>[!NOTE]
>Make sure to fill in your own information before running the command below!<br>

```bash
python3 credmaster.py \
  --plugin httppost \
  -u ~/Desktop/names.txt \
  -p ~/Desktop/top-passwords-shortlist.txt \
  --access_key [YOUR_AWS_KEY] \
  --secret_access_key [YOUR_AWS_SECRET] \
  --pluginargs url [YOUR_NGROK_DOMAIN]/auth/login content-type json \
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

**Terminal #1 - The Attacker Terminal** - CredMaster will find multiple hits since 5 accounts share weak passwords:

<img width="1067" height="862" alt="2026-04-10_13-21" src="https://github.com/user-attachments/assets/a3626ff1-6c82-4e03-9227-3716a2d18792" />


**Terminal #2 - The Defender Terminal** - the log shows every attempt in real time:

<img width="1074" height="676" alt="2026-04-10_13-22" src="https://github.com/user-attachments/assets/c78f2398-a933-481c-b278-cd3ca1a5c5cb" />

<img width="455" height="107" alt="2026-04-10_13-24" src="https://github.com/user-attachments/assets/2c294804-c931-4953-addb-6b65ca09b0e0" />


The pattern is unmistakable from the defender's view: the **same IP cycling through hundreds of usernames, one password at a time, and hitting multiple accounts**. That is the signature of a spray - and exactly why a single weak password policy can compromise an entire organisation at once.

---

## Step 5: View the Results

After the run completes, check what CredMaster saved by running the following commands in **Terminal #3**:

```bash
cat ~/BnB/credMaster/CredMaster/credmaster-success.txt
```

You should see all 5 compromised accounts listed

<img width="152" height="82" alt="image" src="https://github.com/user-attachments/assets/b387e261-c5ac-462b-bd4e-8c18606c97ae" />

View the complete log:

```bash
cat /tmp/auth_server.log
```

<img width="1142" height="442" alt="image" src="https://github.com/user-attachments/assets/30571599-2a69-4017-b924-8f72bfdafd09" />

We can count the total attempts made with this command:

```bash
wc -l /tmp/auth_server.log
```

<img width="858" height="45" alt="image" src="https://github.com/user-attachments/assets/4e524944-e206-4cb1-af60-90fdf83d551c" />

---

## Step 6: Detection Exercises

Now think like a defender. Run these against the log:

**How many unique usernames were targeted?**
```bash
grep "LOGIN ATTEMPT" /tmp/auth_server.log | grep -oP 'User: \K[^\s|]+' | sort -u | wc -l
```

<img width="1115" height="65" alt="image" src="https://github.com/user-attachments/assets/5611374b-f297-4f50-a6e3-dcdd1c6c7293" />

**Which passwords were tried most often?**
```bash
grep "LOGIN ATTEMPT" /tmp/auth_server.log | grep -oP 'Pass: \K.*' | sort | uniq -c | sort -rn | head
```

<img width="1117" height="268" alt="image" src="https://github.com/user-attachments/assets/4846139a-61b9-4467-bbcb-175d2e847db9" />

**How many failed attempts happened before the successful one?**
```bash
grep -c "FAILED" /tmp/auth_server.log
```

<img width="964" height="43" alt="image" src="https://github.com/user-attachments/assets/f9645222-da1f-4b6e-b336-4f2937628158" />

**What was the time window of the entire attack?**
```bash
head -1 /tmp/auth_server.log && tail -1 /tmp/auth_server.log
```

<img width="1122" height="111" alt="image" src="https://github.com/user-attachments/assets/e60015a1-c61f-4d56-a913-87d2f85cd956" />

>[!TIP]
>**Defender insight:** A SIEM rule that fires on "more than 10 failed logins from the same IP across more than 5 different accounts within 10 minutes" would catch this spray immediately. The delay and jitter slow it down but do not change the underlying pattern.

---

> Created by Turcu-Stiolica Alexandru

