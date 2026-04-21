![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Honey Share 

# Windows VM

In this lab we will be creating and triggering a honey share.  The goal of this lab is to show how to set up a simple Impacket SMB server that can record attempted connections to it. 

This can be used for detecting lateral movement in a Windows environment.  

One of the cool things about this is it will track the compromised user, the system and the password hash of the compromised user account. 

Let's get started. 

First, we will need to open a **Linux Terminal**: 


- Open **Ubuntu Shell**

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/ae6d408b-7622-4545-b849-aef3d8fa0cb4" />



Next, we will navigate to the **Impacket** directory: 

```bash
cd ~/ADCD/impacket
```

```bash
source venv/bin/activate
```

- Then navigate to the **examples** directory:

```bash
cd ./examples
```

<img width="742" height="75" alt="cd_venv" src="https://github.com/user-attachments/assets/6e41042c-9a51-4f18-b09a-5ca534101e5a" />


- Make sure you are in the right place

```bash
ls
```

It should look like this:

<img width="1238" height="338" alt="ls_impacket" src="https://github.com/user-attachments/assets/095399cd-7fe5-42e0-a547-fa673aa1616b" />


Now, let's start the SMB server: 

```bash
sudo ~/ADCD/impacket/venv/bin/python smbserver.py -debug -smb2support -comment 'secret' SECRET /secret
```

It should look like this: 

<img width="1806" height="327" alt="impacket_server" src="https://github.com/user-attachments/assets/eed970c8-7ccc-4e09-bec9-056317d8f292" />


Next, let's open a Windows Command Prompt: 

![image](https://github.com/user-attachments/assets/0ccc949d-32c3-4d7b-bb18-1bb39ee36dfc)

Then, attempt to mount the share from your Windows system: 

- Make sure to use the **Linux IP** from **tailscale**

```bash
net use * \\10.10.115.101\secret
```

>[!IMPORTANT]
>
>Your IP address may be different!!! 
  

We did the most basic level of attempted authentication to the share, and it generated an error.  

<img width="1365" height="412" alt="admin_error" src="https://github.com/user-attachments/assets/e80960fb-3044-42b0-999b-34b2d0c9568a" />


However, the trap was triggered! 

Go back to your **Linux terminal** and see the log data. 

It should look like this: 

<img width="1375" height="752" alt="logs" src="https://github.com/user-attachments/assets/071e0e2c-c261-41c6-9066-3b49510a0c15" />


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/honeyuser/honeyuser.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/HoneyBadger_files/HoneyBadger.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
