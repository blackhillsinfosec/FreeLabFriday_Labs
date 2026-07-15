![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# HoneyWire

# Both VMs

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

## Part 1 - Deploy the Hub - Open the **Ubuntu VM**

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

```bash
sudo apt-get update && sudo apt-get install docker-compose-plugin
```

Get the IP of the Ubuntu VM(UR IP WILL BE DIFFERENT)

```bash
ip a show ens5
```

<img width="545" height="177" alt="image" src="https://github.com/user-attachments/assets/24673b34-f1de-49fa-9f91-0d8084fbc7b4" />


Start it:

```bash
sudo docker compose up
```

<img width="1029" height="513" alt="image" src="https://github.com/user-attachments/assets/6f4ca857-2219-497a-a504-fa23a69b3ce2" />


## Part 2 - Initialize the Hub

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

<br><br>

<img width="524" height="426" alt="image" src="https://github.com/user-attachments/assets/37fa3233-aceb-4c74-8518-8670489ccf2a" />


### For the auth key use `changeme123`(we set this up in the docker compose file)

<img width="1919" height="850" alt="image" src="https://github.com/user-attachments/assets/5b3d89df-fe3a-43ae-922e-d2e63af5dc44" />


## Part 3 - Register a Node

In the left sidebar, click **Fleet Management**, then click **Deploy New Node** in the top right

<img width="1919" height="407" alt="2026-07-14_11-23" src="https://github.com/user-attachments/assets/4d83114f-47cd-44b8-bcef-ac383803e37b" />

- Give it a **Node Alias**, for example `Lab-Node-01`
- Click **Create Node**

<img width="375" height="297" alt="image" src="https://github.com/user-attachments/assets/30103f2e-d437-4422-90bc-6441f7843fcc" />


The Hub will show you two things, copy both somewhere safe:

- A **Wizard Installation Command**, something like:

```bash
curl -fsSL https://get.honeywire.dev | bash -s -- --link http://localhost:8080 --api-key <your-node-api-key>
```

- A **Node API Key**

<img width="373" height="510" alt="2026-07-14_11-25" src="https://github.com/user-attachments/assets/faa4cb68-1803-4195-8d79-00529f88746d" />




>[!TIP]
>The API key is only ever shown in full once, on this screen. If you lose it, you can pull it again later from the Node's detail page under **Manage Key**.

Click **Done**.

## Part 4 - Link the Node with the Wizard

On another terminal, run the install command from Part 4, with your real Hub address and API key substituted in:

```bash
curl -fsSL https://get.honeywire.dev | bash -s -- --link http://<your-hub-ip>:8080 --api-key <your-node-api-key>
```

<img width="593" height="248" alt="image" src="https://github.com/user-attachments/assets/898c3187-4e4e-4566-8780-283ceecc99e8" />

When you encounter this, press **y** and **Enter**

<img width="621" height="175" alt="image" src="https://github.com/user-attachments/assets/05e4e265-4ef1-4d1d-bb80-d5d92f7d0aa4" />

For this Host Discovery, press **N** and **Enter**

<img width="316" height="21" alt="image" src="https://github.com/user-attachments/assets/5eeae0dc-70b5-425c-a112-a3dbbd1481f9" />


Go back to **Fleet Management** in the dashboard. Your node card starts out showing **Awaiting Initial Check-in**

## Part 5 - Attach a sensor to the Node

Click into your Node, then click **Install First Sensor**

Choose **TCP Tarpit (Credential Trap)**

<img width="1677" height="717" alt="2026-07-14_11-49" src="https://github.com/user-attachments/assets/79c987a4-80e7-42c0-a4ec-c9003dca4787" />


Under its **Configuration** tab, the defaults work fine for this lab:

| Setting | Value | What it does |
|---|---|---|
| Alert Severity | High | How the event gets flagged when tripped |
| `HW_DECOY_PORTS` | `2222` | Which port(s) the trap listens on |
| `HW_TARPIT_BANNER` | `SSH-2.0-OpenSSH_8.2p1\r\n` | The fake service banner shown to a connecting attacker |
| `HW_TARPIT_MODE` | `hold` | Holds the connection open instead of closing or echoing |

<img width="776" height="723" alt="image" src="https://github.com/user-attachments/assets/bc75165c-8d8a-46e2-ad54-3969b1a57422" />


Click **Add to Node**

And press **Sync Node**

<img width="1312" height="680" alt="2026-07-14_11-51" src="https://github.com/user-attachments/assets/cb4b5ddd-0aeb-4dff-9fb2-4e317d6b846a" />

Copy the command from the **Automatic Deployment (Recommended)** and run it in your terminal

<img width="663" height="483" alt="2026-07-14_11-54" src="https://github.com/user-attachments/assets/753911f0-bfbd-4548-88de-adcf0123085e" />

You will be prompted to type **y/N** 3 times, write **y** for the first 2, and then **N**

<img width="1359" height="829" alt="image" src="https://github.com/user-attachments/assets/0b11e74e-28cb-4414-a7f3-53ffd45f9f5a" />


>[!NOTE]
>Getting some errors is ok, it will not bother us for this lab


- Go back to the first terminal where we ran `sudo docker compose up`, you will see it has shutdown because of the sensor we installed

<img width="1171" height="262" alt="Screenshot 2026-07-15 104212" src="https://github.com/user-attachments/assets/c7ae6a14-f266-43d0-ab9e-90339d614b48" />

- Start it again, run:

```bash
sudo docker compose up
```

Now, going back to the dashboard and refreshing the page and loging in again, you can see the sensor has been deployed, if it doesn't look like it, don't worry, the sensor is there, it is just that the tool is still very new and bugs are bound to happen

<img width="366" height="263" alt="image" src="https://github.com/user-attachments/assets/8c288c84-ec2e-4f38-bba0-d888f5d7e2b0" />

<img width="358" height="185" alt="image" src="https://github.com/user-attachments/assets/2f05f259-e9e7-4d5b-902d-c63094268af7" />


## Part 6 - Attacker perspective, trip the wire

On **the Windows VM**, open **cmd**, and connect to the decoy port with `netcat`

```bash
ncat <Ubuntu IP> 2222
```

You should see the fake `SSH-2.0-OpenSSH_8.2p1` banner appear immediately, that is `HW_TARPIT_MODE=hold` doing its job of looking exactly like a real SSH service. Type anything, for example:

```
admin
```

Press Enter. The connection will feel like it hangs, that is the tarpit behavior, it is built to waste an attacker's time. Press `Ctrl+C` to close it when you are done

You can also try to do this from inside the Ubuntu VM, connecting with **nc** to **localhost** on port **2222**, but it might not show up in the dashboard

## Part 7 - Defender perspective, watch the alert

Switch back to the Hub Dashboard. Within seconds you should see:

- **Events Velocity** tick up from 0
- **Severity Distribution** register your event under the severity you configured (High)
- The **Active Threat Queue** at the bottom populate with a new row showing the Threat, the Event Trigger, the Source IP, the Target, the Sensor, the Node, and the Time

<img width="1675" height="772" alt="image" src="https://github.com/user-attachments/assets/cd9e2ab4-ad23-48e6-86a0-a43e77c4a7d6" />


>[!NOTE]
>This is the whole point of HoneyWire. There is no baseline to tune and no threshold to adjust. The sensor has no legitimate reason to ever be touched, so one connection is a confirmed finding, not a probability.

## Part 8 - Try a scan instead of a manual connection

From the windows terminal:

```bash
nmap -sV <Ubuntu IP> -p2222
```

Check the Active Threat Queue again. The scan touching the Tarpit port generates its own event too, for the same reason as Part 8, a scan is exactly the kind of "touch that should never happen."

## Part 9 - Arm and disarm the system

Sometimes you need to run your own vulnerability scans or do maintenance without flooding your phone with push alerts. In the top right of the dashboard, find the **Armed** toggle and switch it off before doing that kind of work, then switch it back on afterward

<img width="367" height="71" alt="2026-07-14_14-01" src="https://github.com/user-attachments/assets/036ed767-59ca-4efd-84d5-31472aaa1583" />


>[!TIP]
>Disarming only pauses push notifications. Events still get logged to the dashboard either way, so you will not lose visibility.

## Other sensors in the catalog

Once this lab feels comfortable, the Sensor Catalog on your Node's page also includes:

- **File Canary (FIM)** - Honeypot and File Integrity Monitor. Watches files and directories for unauthorized modifications.
- **ICMP Canary** - Detects internal network discovery (ping sweeps) from compromised assets.
- **Network Scan Detector** - Detects horizontal port scanning (Nmap sweeps) across the LAN.

Each one attaches to a Node the same way as Part 5, pick it from the catalog, configure it, **Add to Node**


***                                                                 
<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
