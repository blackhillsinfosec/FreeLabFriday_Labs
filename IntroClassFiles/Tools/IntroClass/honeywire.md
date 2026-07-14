![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# HoneyWire

# Ubuntu VM

## In this lab we will
- Deploy the HoneyWire Hub, a self-hosted deception platform
- Deploy an official sensor (TCP Tarpit) and connect it to the Hub
- Trip the tripwire as an attacker and watch live detection as a defender
- Understand the Hub -> Sensor architecture and the data it captures

>[!NOTE]
>HoneyWire is a self-hosted deception platform. Instead of trying to spot attacks through heuristics like a SIEM does, it places fake, low-value services ("HoneyWires") on your network. Nothing legitimate ever has a reason to touch them, so any interaction is treated as a confirmed threat, not a maybe.

## Architecture

HoneyWire is split into three pieces:

- **Hub** -> the central brain. A Go binary with an embedded SQLite database and a web dashboard. This is what you, the analyst, watch.
- **Sensors** -> the decoy nodes. Small binaries that sit on a port (or a file, or an ICMP listener) and report back to the Hub the moment they are touched.
- **SDKs** -> libraries for building your own custom sensors that speak the HoneyWire event format.

For this lab we will deploy the Hub, then deploy one official sensor called the **TCP Tarpit**, which pretends to be a vulnerable service sitting on a port.

## Step 1 - Deploy the Hub

Create a directory for HoneyWire and move into it:

```bash
mkdir ~/ADCD/honeywire && cd ~/ADCD/honeywire
```

Create the compose file:

```bash
cat > docker-compose.yml << 'EOF'
services:
  permission-fixer:
    image: alpine:latest
    command: sh -c "chown -R 65532:65532 /data"
    volumes:
      - ./honeywire_data:/data

  hub:
    image: ghcr.io/andreicscs/honeywire-hub:latest
    container_name: honeywire-hub
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - ./honeywire_data:/data
    depends_on:
      permission-fixer:
        condition: service_completed_successfully
    user: "65532:65532"
    read_only: true
    cap_drop: ["ALL"]
    security_opt: ["no-new-privileges:true"]
    environment:
      - HW_ENV=development
      - HW_PORT=8080
      - HW_DB_PATH=/data/honeywire.db
      - HW_DASHBOARD_PASSWORD=changeme123
EOF
```

>[!NOTE]
>`HW_ENV=development` only exists so the login cookie works over plain HTTP for this lab. In a real deployment you would remove it and put the Hub behind a reverse proxy with HTTPS instead.
>
>`HW_DB_PATH` matters more than it looks. The container runs `read_only: true` with only `/data` writable. Without this variable pointing the database at `/data/honeywire.db`, the Hub tries to write its database somewhere it isn't allowed to, and crash-loops on startup with an error like `unable to open database file`.
>
>`HW_DASHBOARD_PASSWORD` sets the key you sign in with. Pick your own value if you wish, it is not shown anywhere else afterward.

Start it:

```bash
sudo docker compose up -d
```

<img width="1029" height="513" alt="image" src="https://github.com/user-attachments/assets/6f4ca857-2219-497a-a504-fa23a69b3ce2" />


## Step 2 - Initialize the Hub

Open a browser

<img width="264" height="455" alt="2026-07-14_10-44" src="https://github.com/user-attachments/assets/3fcc00e3-94b3-4df3-86a1-93c45ca4194e" />

Go to:

```
http://localhost:8080
```

<img width="674" height="613" alt="image" src="https://github.com/user-attachments/assets/1cd563db-92e6-48ed-b53d-044d4cbc81c9" />


You will land on the **HoneyWire Sentinel** screen. From there:

- Create a Master Password
- Leave the default Hub Endpoint URL (the address sensors will phone home to)
- Click **Initialize Hub**


- For the auth key use `changeme123`(we set this up in the docker compose file)

<img width="1919" height="850" alt="image" src="https://github.com/user-attachments/assets/5b3d89df-fe3a-43ae-922e-d2e63af5dc44" />


## Step 3 - Register a Node

In the left sidebar, click **Fleet Management**, then click **Deploy New Node** in the top right

<img width="1919" height="407" alt="2026-07-14_11-23" src="https://github.com/user-attachments/assets/4d83114f-47cd-44b8-bcef-ac383803e37b" />

- Give it a **Node Alias**, for example `Lab-Node-01`
- Click **Create Node**

<img width="375" height="297" alt="image" src="https://github.com/user-attachments/assets/30103f2e-d437-4422-90bc-6441f7843fcc" />


The Hub will show you two things, copy both somewhere safe:

- A **Wizard Installation Command**, something like:

```bash
curl -fsSL https://get.honeywire.dev | bash -s -- --link http://<your-hub-ip>:8080 --api-key <your-node-api-key>
```

- A **Node API Key**

<img width="373" height="510" alt="2026-07-14_11-25" src="https://github.com/user-attachments/assets/faa4cb68-1803-4195-8d79-00529f88746d" />




>[!TIP]
>The API key is only ever shown in full once, on this screen. If you lose it, you can pull it again later from the Node's detail page under **Manage Key**.

Click **Done**.

## Step 4 - Link the Node with the Wizard

On the machine you want to protect (this can be the same VM for the lab), run the install command from Step 4, with your real Hub address and API key substituted in:

```bash
curl -fsSL https://get.honeywire.dev | bash -s -- --link http://<your-hub-ip>:8080 --api-key <your-node-api-key>
```

>[!NOTE]
>This is "the Wizard." It links the machine to the Node you registered and then exits. There is no persistent installer process left running, only the sensor containers it deploys later actually sit and listen.

Go back to **Fleet Management** in the dashboard. Your node card starts out showing **Awaiting Initial Check-in**. Once the Wizard finishes linking, it should flip to an active/connected state.

## Step 5 - Attach a sensor to the Node

Click into your Node, then click **Install First Sensor** (or pick directly from the **Sensor Catalog** further down the page).

Choose **TCP Tarpit (Credential Trap)**. Under its **Configuration** tab, the defaults work fine for this lab:

| Setting | Value | What it does |
|---|---|---|
| Alert Severity | High | How the event gets flagged when tripped |
| `HW_DECOY_PORTS` | `2222` | Which port(s) the trap listens on |
| `HW_TARPIT_BANNER` | `SSH-2.0-OpenSSH_8.2p1\r\n` | The fake service banner shown to a connecting attacker |
| `HW_TARPIT_MODE` | `hold` | Holds the connection open instead of closing or echoing |

Click **Add to Node**.

>[!NOTE]
>Not fully confirmed at the time of writing: whether **Add to Node** deploys the sensor immediately, or only queues it until a sync step runs on the Node itself. The project's changelog references sensor versions being pinned until the operator runs a `honeywire apply` command on the Node. If the sensor doesn't show as actually deployed after clicking **Add to Node**, try running `honeywire apply` on the Node machine and confirm the behavior in your own environment before teaching this step to others.

>[!TIP]
>If you're deploying the Tarpit sensor on the same machine as the Hub, older builds before v2.0.1 had a bug where the Tarpit's default port could collide with the Hub's own web server. This was fixed in v2.0.1, but worth knowing if you ever roll back to an older image.

Give it about 30 seconds, then check the Node's **Deployed Sensors** section, it should now show your TCP Tarpit instead of "No sensors deployed."

## Step 6 - Attacker perspective, trip the wire

On another terminal (or your second machine), connect to the decoy port with `netcat`. Netcat is usually already installed on Ubuntu; if not: `sudo apt install -y netcat-traditional`.

```bash
nc <node-ip> 2222
```

You should see the fake `SSH-2.0-OpenSSH_8.2p1` banner appear immediately, that is `HW_TARPIT_MODE=hold` doing its job of looking exactly like a real SSH service. Type anything, for example:

```
admin
```

Press Enter. The connection will feel like it hangs, that is the tarpit behavior, it is built to waste an attacker's time. Press `Ctrl+C` to close it when you are done.

## Step 7 - Defender perspective, watch the alert

Switch back to the Hub Dashboard. Within seconds you should see:

- **Events Velocity** tick up from 0
- **Severity Distribution** register your event under the severity you configured (High)
- The **Active Threat Queue** at the bottom populate with a new row showing the Threat, the Event Trigger, the Source IP, the Target, the Sensor, the Node, and the Time

>[!NOTE]
>This is the whole point of HoneyWire. There is no baseline to tune and no threshold to adjust. The sensor has no legitimate reason to ever be touched, so one connection is a confirmed finding, not a probability.

## Step 8 - Try a scan instead of a manual connection

From the attacker terminal:

```bash
sudo apt install -y nmap
nmap -sV <node-ip> -p 1-100
```

Check the Active Threat Queue again. The scan touching the Tarpit port generates its own event too, for the same reason as Step 8, a scan is exactly the kind of "touch that should never happen."

## Step 9 - Arm and disarm the system

Sometimes you need to run your own vulnerability scans or do maintenance without flooding your phone with push alerts. In the top right of the dashboard, find the **Armed** toggle and switch it off before doing that kind of work, then switch it back on afterward.

>[!TIP]
>Disarming only pauses push notifications. Events still get logged to the dashboard either way, so you will not lose visibility.

## Other sensors in the catalog

Once this lab feels comfortable, the Sensor Catalog on your Node's page also includes:

- **File Canary (FIM)** - Honeypot and File Integrity Monitor. Watches files and directories for unauthorized modifications.
- **ICMP Canary** - Detects internal network discovery (ping sweeps) from compromised assets.
- **Network Scan Detector** - Detects horizontal port scanning (Nmap sweeps) across the LAN.

Each one attaches to a Node the same way as Step 5, pick it from the catalog, configure it, **Add to Node**.
