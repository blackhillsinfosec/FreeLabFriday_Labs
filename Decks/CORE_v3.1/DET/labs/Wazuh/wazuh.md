![image](/FilesForLabs/images/blueantisyphon.png)

# Wazuh Cloud SIEM & XDR
# Ubuntu & Windows VM
## The objective of this lab is to deploy Wazuh Agents to a cloud-hosted SIEM environment, configure File Integrity Monitoring (FIM), simulate malicious activities across two different OS environments, and perform Blue Team analysis on the generated alerts.

---

### **Documentation and scenario** :
**What is Wazuh?**

 - Wazuh is a free, open-source security platform that unifies XDR (Extended Detection and Response) and SIEM (Security Information and Event Management) capabilities. It protects endpoints and cloud workloads by identifying threats and responding to them in real-time.

**What we will be focusing on:**

 - *File Integrity Monitoring (FIM)*: Wazuh monitors the file system, identifying changes in content, permissions, ownership, and attributes of files that you specify. It is crucial for detecting unauthorized configuration changes or backdoors.

 - *Malware Detection*: Wazuh uses out-of-the-box integration with various threat intelligence sources to detect known malicious files (like malware or ransomware) dropped onto the filesystem.

 - *Cloud Deployment* : Instead of hosting the heavy server components locally, we are using an AWS EC2 loaded up with a Wazuh Manager Unit to process and index our logs. The endpoints only run a lightweight agent.

If you want to dive a bit deeper, check the [Wazuh Documentation](https://github.com/wazuh/wazuh).

>[!NOTE]
>In the real world, attackers often attempt to modify critical system configuration files to maintain persistence (e.g., adding a new user to /etc/passwd on Linux) or drop malicious payloads on user endpoints (Windows). Being able to detect both simultaneously in a single dashboard is the primary advantage of a centralized SIEM.

---

### SCENARIO :
In this lab, we are simulating a multi-stage incident. The Windows VM represents a corporate workstation, and the Ubuntu VM represents an internal database/web server.
We will connect both machines (with *Wazuh Agents* Installed) to a *Wazuh Manager* instance that we'll run in an *AWS EC2*.

 - *The Attack:* We will simulate an attacker clearing system logs on the Windows endpoint. Simultaneously, we will simulate an attacker who has gained SSH access to the Ubuntu server and is modifying a highly sensitive configuration file to establish a backdoor.

 - *The Defense:* We will switch to the Blue Team perspective, log into the Wazuh Manager Dashboard, and hunt down these specific Indicators of Compromise (IoCs).

>[!IMPORTANT]
>All actions will be performed from the Windows VM. **To demonstrate how Wazuh detects malware, we will pretend the Windows VM is already compromised**. You will use the *Windows Powershell* to connect to the AWS EC2 and use the **Wazuh Manager Dashboard**, Windows PowerShell for the Windows attack simulation, and the "Ubuntu Shell" Desktop shortcut (SSH) to interact with the Ubuntu VM.

---

## Wazuh Manager and AWS setup 

**!!!** -> You will need an AWS *Free Tier Account*. If you want the step by step instructions for that, check [Phase 1 of the ScoutSuite Lab](https://github.com/blackhillsinfosec/FreeLabFriday_Labs/blob/main/Decks/CORE_v3.1/IC/labs/ScoutSuite/scoutsuite.md).

- Once you have the account set up, log in and let's make some **key pairs** for the EC2. Navigate to the **EC2 Dashboard**:
  
<img width="1513" height="688" alt="image" src="https://github.com/user-attachments/assets/ae61bd2f-a8d2-4c78-9056-5bf89b92fa27" />

- In the *Network & Security* section, in the down left part of the menu, click on **Key Pairs**:

<img width="863" height="996" alt="image" src="https://github.com/user-attachments/assets/ad749dec-8474-4c40-a388-537ab7e661fc" />

- Click on **Create Key Pair**:

<img width="1615" height="240" alt="image" src="https://github.com/user-attachments/assets/381879be-b431-46ff-84d9-cb344027950f" />

- Give the Key pair a simple name like **wazuh-key**, leave the *Key pair type* on **RSA**, and the *Private key file format* on **.pem**:

<img width="736" height="686" alt="image" src="https://github.com/user-attachments/assets/58bdae7c-b744-4d57-afaf-8dfebb5082fc" />


---

## Moving the Key : 

>[!IMPORTANT]
> Once you recieve *wazuh-key.pem*, **you NEED to move it to your personal computer**.
> If there is a network error, or the VM idles too long and closes, **you risk losing the RSA Private Key, and therefore access to your AWS EC2 instance**. If that happens you need to **delete the key and reconfigure the AWS EC2**.

🔑 Securing the SSH Key (wazuh-key.pem): 
 - The *RSA Key* should be in your *Downloads* folder on the VM :
   
 <img width="1222" height="645" alt="image" src="https://github.com/user-attachments/assets/29004727-2cb8-49b0-bbdb-5b2246d9cdc2" />

   We will use the **VM's clipboard** to copy the .pem file. Move the *.pem* file to the **lab directory (~/BnB/Wazuh)**
 - To *open or close* the clipboard of the VM press **ctrl+alt+shift** and a small window will pop up: 

 <img width="526" height="826" alt="image" src="https://github.com/user-attachments/assets/9ce6ed1f-9a0a-4e46-80a0-39d65c95b40d" />
 
 - Open the file with notepad and copy the contents. Make sure to copy the **---BEGIN...---** and **---END...---** parts of the key. 

 <img width="811" height="710" alt="image" src="https://github.com/user-attachments/assets/5ccc2f0a-0bf2-438a-a638-613f52383f4c" />

 - Copy the contents of the file using **ctrl+c**, and you will see that when you open your clipboard, the contents of the file will be listed there : 

 <img width="524" height="662" alt="image" src="https://github.com/user-attachments/assets/f104722a-7ed5-417c-aa21-a6a8a83dd6d7" />

Use your cursor to **copy the contents of the VM clipboard with ctrl+a, then ctrl+c**, and paste them into a file on your personal machine. 

>[!NOTE]
>After creating the wazuh-key.pem file on your host machine using the Copy-Paste method, you must set the correct file permissions. SSH clients are designed to ignore private keys that are "too readable" by other users on the system. If you skip this step, your connection will be rejected.

Depending on your operating system, this proccess will differ : 

### Option A: Linux / macOS Users

- On Linux / macOS, open a folder of your choosing in the terminal, type **nano wazuh-key.pem**, paste the content into a the file, press **ctrl+o, Enter, then ctrl+x**. After that, type:

``` bash
chmod 400 wazuh-key.pem
```

 - You should now see the that **only the root user has reading permission**: 

<img width="574" height="21" alt="image" src="https://github.com/user-attachments/assets/1ae5f980-7bde-471b-a6e0-caf0c8cc4e92" />


### Option B: Windows Users (PowerShell)
Open a PowerShell terminal in the folder containing your key and run these two commands. This will disable permission inheritance and ensure only your current user profile has access:

```PowerShell
# 1. Disable permission inheritance
icacls "wazuh-key.pem" /inheritance:r

# 2. Grant read access only to the current user
icacls "wazuh-key.pem" /grant:r "${env:USERNAME}:R"
```

⚠️ Important Security Note: 
 - These "Strict Permissions" ensure that you are the only one who can read this file. If you attempt to connect and see an error like Permissions 0644 for 'wazuh-key.pem' are too open, it means the steps above were not completed successfully.

---

## Back to the AWS & Wazuh Setup : 

- We need to move [this script](../Wazuh/wazuh_cloudformation_setup.yaml) into the *Windows VM*. This is the cloudformation script. Open up **Windows Powershell** and type this command : 

```Powershell
cd Downloads ; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/blackhillsinfosec/FreeLabFriday_Labs/refs/heads/main/Decks/CORE_v3.1/DET/labs/Wazuh/wazuh_cloudformation_setup.yaml" -OutFile "wazuh_cloudformation_setup.yaml"
```
<img width="1196" height="391" alt="image" src="https://github.com/user-attachments/assets/f7856e6d-0aee-4802-8ab9-050b1f7f2e2e" />

- Let's use it. Navigate to the **Cloudformation Console** : 

<img width="1707" height="944" alt="image" src="https://github.com/user-attachments/assets/fb146dce-8e13-4485-a204-b4788da9d15c" />

- Press **Create Stack** and select **Upload File**. Upload the file that we stored in *Downloads* earlier:
   
<img width="1342" height="655" alt="image" src="https://github.com/user-attachments/assets/f6b68df8-4783-4289-b2a5-15b88c4e99cd" /> 

<img width="944" height="513" alt="image" src="https://github.com/user-attachments/assets/484c58b1-1c1c-4597-8290-6f2856a80647" />

- Fill in **Wazuh-server** for yout *Stack name*, and click on the drop-down menu to choose the **RSA key** you just created: 

<img width="1343" height="631" alt="image" src="https://github.com/user-attachments/assets/23d3e1d8-7eee-4850-a443-e26e48239303" />

- Click **Next**, then click **Next** again. When reaching the **Review and Create** tab, click Submit: 

<img width="1487" height="264" alt="image" src="https://github.com/user-attachments/assets/37fef7bf-70d6-4c8d-bdce-fe612c0f862d" />

- You will be taken to the *events* tab of the *deployment timeline*. Once it is done deploying, click on outputs to see your **public IP**: 

<img width="951" height="516" alt="image" src="https://github.com/user-attachments/assets/67fda621-6e9e-4026-a58f-d3d250ad85e5" />
  
---

## Phase 1 : Agent Enrollment & System Check

Now that the CloudFormation stack is complete, the AWS EC2 instance is running. However, because Wazuh generates a random password during its automated installation, we need to SSH into the server to retrieve it and verify the manager is running correctly.

- Open your Windows PowerShell and ensure you are in the directory where you saved wazuh-key.pem (the Downloads folder).

<img width="636" height="299" alt="image" src="https://github.com/user-attachments/assets/4a3feb14-1875-4e09-a6c5-17714490022d" />

<img width="441" height="78" alt="image" src="https://github.com/user-attachments/assets/7232e309-becf-4fae-8f48-8754da064df8" />


- Run the following command to connect to your EC2 instance. Make sure to replace <YOUR_EC2_PUBLIC_IP> with the actual IP from the **CloudFormation Outputs** tab:

```PowerShell
ssh -i wazuh-key.pem ubuntu@<YOUR_EC2_PUBLIC_IP>
```

>[!NOTE]
>Upon your first connection, SSH will warn you about the host's authenticity. Type yes and press Enter to continue.

<img width="815" height="161" alt="image" src="https://github.com/user-attachments/assets/c03ad282-d34f-4900-8b0c-887cfab38099" />

- You should now see your terminal prompt change to something like ubuntu@ip-172-31-x-x:~$, indicating you are successfully logged into the AWS Linux server.

**Step 1**: Verify the Manager Status
Let's ensure the Wazuh Manager service installed successfully and is actively running. Run the following command:

```Bash
sudo systemctl status wazuh-manager
```
> (You should see a green active (running) status. Press q to exit the status screen).

<img width="1189" height="628" alt="image" src="https://github.com/user-attachments/assets/8d9b8f75-9ace-4411-b18b-154d5d13402b" />

**Step 2**: Retrieve the Dashboard Password
Our automated setup script saved the installation output, including the web dashboard credentials, directly into your home directory. Read the file by typing:

```Bash
cat /home/ubuntu/wazuh_install_info.txt
```

Scroll through the output in your terminal and look for the User (admin) and the newly generated Password. Copy this password to your clipboard — you will need it in the next step.

<img width="1195" height="519" alt="image" src="https://github.com/user-attachments/assets/179baf20-d312-485a-827a-8f7410dbd888" />

- Once you have the password, you can type exit to close the SSH connection, or simply minimize the PowerShell window.

First, we need to deploy the Wazuh Agents to our endpoints so they can start forwarding telemetry to our newly created AWS manager. Open Google Chrome on your Windows VM and let's start logging into your **Wazuh Manager Dashboard**. 

>[!NOTE]
>**Do NOT close the dashboard until we are done installing the agents.**

- To do this, navigate to `https://<YOUR_EC2_PUBLIC_IP>:<WAZUH_MANAGER_SPECIFIED_PORT>` and input the credentials. (You can find the default login credentials in the Outputs tab of your AWS CloudFormation stack, along with the port that you can access). You will see the **Your connection is not private** warning, click **Advanced** and then **Proceed to <IP>(unsafe)**. 

<img width="993" height="720" alt="image" src="https://github.com/user-attachments/assets/3f06f09c-badf-4132-8b67-ede94b2d65b9" />

- Once logged in, navigate to the lateral menu and roll down the **Server Management** section. Click on **Endpoints Summary**. Then, click **Deploy new agent**.

<img width="1194" height="900" alt="image" src="https://github.com/user-attachments/assets/125ade31-b093-450e-bae4-914144689f0d" />

<img width="741" height="380" alt="image" src="https://github.com/user-attachments/assets/1e74c97a-53bc-4340-9e2a-a7987b8e23c8" />

- Select **Windows**, input your EC2 Public IP as the server address and copy the generated PowerShell command:
  
<img width="942" height="829" alt="image" src="https://github.com/user-attachments/assets/328cb46c-3354-4328-8daa-a5a82c1b85a9" />
<img width="938" height="766" alt="image" src="https://github.com/user-attachments/assets/d64659eb-d95a-4851-acbb-1a071eff2e02" />
<img width="966" height="217" alt="image" src="https://github.com/user-attachments/assets/9654c5e1-3815-4ef2-baaf-f40805a4ea82" />

- Open an Administrator PowerShell terminal and paste it to install and start the agent:
  
<img width="821" height="254" alt="image" src="https://github.com/user-attachments/assets/202a842d-3055-40b8-8aca-730861dee1d4" />

- Now, to do the same for the **Ubuntu VM**, don't close the tab, just select the **Linux DEB amd64** installation package:

<img width="908" height="497" alt="image" src="https://github.com/user-attachments/assets/e75442d6-5895-4709-bc63-be9f12c92038" />

- You will have to input the *Ubuntu commands* in the **Ubuntu shell** in order to start the agent. Close the powershell terminal and click on the **Ubuntu shell shortcut**:

<img width="530" height="549" alt="image" src="https://github.com/user-attachments/assets/820cf867-aed5-4d11-9eda-63264b3bfc8b" />
   
- Copy the Linux enrollment commands, and paste it into the Ubuntu shell:

<img width="753" height="141" alt="image" src="https://github.com/user-attachments/assets/842cb2aa-2933-46a2-98f2-e6fd9f91da80" />

- Go back to the Wazuh Manager Dashboard (click *close*). You should now see both agents marked as Active:
<img width="1844" height="561" alt="image" src="https://github.com/user-attachments/assets/c0dfff83-0431-4275-afc4-e544b7e2819a" />

## Phase 2: Configuring File Integrity Monitoring (FIM)
By default, Wazuh monitors certain system directories. We want to explicitly monitor a custom "sensitive" directory on our Ubuntu VM to simulate a targeted data breach or config alteration, but we also want to monitor added malware files on the desktop of the Windows VM.

- In your Ubuntu Shell, let's create a fake sensitive file:

```bash
sudo mkdir -p /var/www/html/secure_portal
sudo touch /var/www/html/secure_portal/db_config.php
sudo nano /var/www/html/secure_portal/db_config.php
```

Add some dummy text inside (like db_password=SuperSecret), save, and exit:

<img width="1346" height="340" alt="image" src="https://github.com/user-attachments/assets/072ee6db-6067-4092-85e7-5ea5d5d9ef66" />

- Now, we tell the Wazuh Agent to watch this specific directory. Open the agent configuration file:

```bash
sudo nano /var/ossec/etc/ossec.conf
```
<img width="888" height="569" alt="image" src="https://github.com/user-attachments/assets/56665fe0-3d98-4d15-b723-8feb80aad143" />

- Scroll down to the <syscheck> section (which handles FIM) and add the following line to monitor our new directory in real-time:

```
<directories check_all="yes" realtime="yes">/var/www/html/secure_portal</directories>
```

<img width="1106" height="916" alt="image" src="https://github.com/user-attachments/assets/7389b00e-f33b-41a4-8e14-e20edc76063d" />

Press **ctrl+s to save the changes, then ctrl+x to exit.**

- Restart the Wazuh agent to apply the changes:

```bash
sudo systemctl restart wazuh-agent
```

>[!NOTE]
>FIM takes a few minutes to run its initial baseline scan. **It hashes all the files in that directory** so it has something to compare against when a change happens.

<img width="946" height="178" alt="image" src="https://github.com/user-attachments/assets/b675590b-753d-4946-bc89-d061eb578939" />



## Phase 3: Execution (Simulating the Attack)
Now we play the role of the attacker on both machines.

#### Attack 1: Security Log Wipe on Windows

To hide their tracks, attackers often clear Windows Event Logs immediately after compromising a system. This technique, known as *Defense Evasion*, is a massive red flag for any Blue Team. We will simulate this by completely wiping the local Security logs on the Windows endpoint.

- Open your **Windows PowerShell** (ensure you are running it as Administrator) and execute the following command:

```powershell
Clear-EventLog -LogName Security
```

>[!NOTE]
>Clearing the event logs interacts directly with the core Windows auditing system. Although the attacker's goal is to delete historical data, the action of clearing the log generates a final, un-erasable system event (Event ID >1102) stating that the audit log was cleared. Wazuh monitors this natively and will immediately trigger a critical alert.


---

### Attack 2: Backdoor Configuration on Ubuntu

The attacker (already SSH'd into the system via the Ubuntu Shell) modifies the database configuration file to route traffic to their own server.

- In the **Ubuntu shell**, type this command :

```bash
echo "db_password=HACKED_PASSWORD_123" | sudo tee -a /var/www/html/secure_portal/db_config.php
```
<img width="769" height="292" alt="image" src="https://github.com/user-attachments/assets/987cfb02-054f-4598-ac87-177455485463" />

## Phase 4: Blue Team Detection
The attacks are complete. Now, switch to your Google Chrome browser on Windows and refresh the Wazuh Manager Dashboard.

**Hunting the Windows Malware:**
- In the *Dashboard*, go to "Agents Summary" and click on **Active**: 
  
<img width="522" height="273" alt="image" src="https://github.com/user-attachments/assets/a94e5a6c-08db-437e-b959-f0dc23ba6096" />

- Click on the *Windows Agent*:
  
<img width="1819" height="377" alt="image" src="https://github.com/user-attachments/assets/03137e0d-0476-4d58-bf67-f3ca2c9ae1a0" />

- Go to *Threat Hunting*: 

<img width="836" height="475" alt="image" src="https://github.com/user-attachments/assets/6479e772-a420-4b4b-ab0b-942327b9560a" />

- You will the log wipe show up in the **Top 5 Alerts** section: 

<img width="1096" height="803" alt="image" src="https://github.com/user-attachments/assets/94a516a2-0b01-450b-8b92-6519d1de13c6" />

- Hovering above the alert will show more data about the findings : 

<img width="648" height="428" alt="image" src="https://github.com/user-attachments/assets/3b64a52b-0cde-4788-a052-55e976121224" />

**We've detected the system log wipe.**

**Hunting the Ubuntu FIM Violation:**
- Navigate to the **File Integrity Monitoring** under **Endpoint security**:

<img width="557" height="946" alt="image" src="https://github.com/user-attachments/assets/3d748f81-53f5-4f55-bf4b-31ec61e8f5a9" />

- Click on **Events** and you should see that **the only event is the fact that the file at /var/www/html/secure_portal/db_config.php was modified**.

<img width="1841" height="878" alt="image" src="https://github.com/user-attachments/assets/f48e3190-6a28-4d1f-ac93-55e8f94afb22" />

Wazuh will show you the exact timestamp, the user who made the change (root, via sudo), and even the hash differences before and after the attack.

## Cleanup

Since this lab relies on cloud infrastructure that incurs hourly costs, it is **critical** to properly destroy your environment once you have finished analyzing the alerts. 

>[!IMPORTANT]
>Do not forget to destroy the lab environment once you're done.

### AWS Infrastructure Cleanup (CRITICAL)
The Wazuh Manager was deployed on a large EC2 instance. If you leave this running, it will rapidly consume your AWS Free Tier limits and generate real-world charges. To properly destroy the server, we must delete the CloudFormation stack, which will automatically terminate the EC2 instance attached to it:

- In your browser, navigate back to the AWS CloudFormation Console.

- Select the Wazuh-server stack you created at the beginning of the lab.

- Click the Delete button at the top right, then confirm by clicking Delete stack.

<img width="1646" height="573" alt="image" src="https://github.com/user-attachments/assets/59555a7b-f3d7-4b74-a1d3-8098df004dbf" />

>[!IMPORTANT]
> Verification: To ensure you don't get billed, navigate to your EC2 Dashboard -> Instances. You should see your Wazuh instance state change to Shutting-down and eventually Terminated. Once it says terminated, AWS has stopped billing you for that compute time.

(Optional) Clean up the SSH Key:

1. In the EC2 Dashboard, scroll down on the left menu to Key Pairs.

2. Select your wazuh-key (or whatever you named it) and select Actions -> Delete.

3. You can now safely delete the .pem file from your personal computer's Downloads folder.

## Conclusion
In this lab, you successfully deployed an enterprise-grade SIEM/XDR architecture using a cloud-hosted Wazuh Manager on AWS EC2. You learned how to configure File Integrity Monitoring (FIM) to protect sensitive server configurations on a Linux machine, and you simulated a Defense Evasion attack (Log Clearing) on a Windows endpoint. Most importantly, you navigated the Wazuh Dashboard to perform threat hunting, proving that centralized logging is absolutely essential for detecting multi-vector attacks across different operating systems.

# Finished?
[Back to Card's Main Page](https://github.com/blackhillsinfosec/FreeLabFriday_Labs/blob/main/Decks/CORE_v3.1/DET/Cloud_Event_Log_Analysis.md)
