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
mkdir ~/honeywire && cd ~/honeywire
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
EOF
```

>[!NOTE]
>`HW_ENV=development` only exists so the login cookie works over plain HTTP for this lab. In a real deployment you would remove it and put the Hub behind a reverse proxy with HTTPS instead.

Start it:

```bash
docker compose up -d
```

Check both containers came up:

```bash
docker compose ps
```

## Step 2 - Initialize the Hub

Open a browser and go to:

```
http://<your-server-ip>:8080
```

You will land on the **Initialize Sentinel** screen. From there:

- Create a Master Password
- Confirm the Hub Endpoint URL (the address sensors will phone home to)
- Generate the Sensor Secret Key (this becomes the `HW_HUB_KEY`)
- Click **Initialize Hub**

>[!TIP]
>Write down the Sensor Secret Key. Every sensor you deploy needs this exact key before the Hub will trust its events.

## Step 3 - Deploy your first sensor (TCP Tarpit)

Inside the dashboard, go to the **Sensor Store** and click **TCP Tarpit**. The Hub generates a ready-to-use `docker-compose.yml` for you, already filled in with your Hub's address and secret key.

On the machine you want to protect (this can be the same VM for the lab), create a folder and paste in the file the Hub generated:

```bash
mkdir ~/honeywire-sensor && cd ~/honeywire-sensor
nano docker-compose.yml
```

Paste the generated content, save, then start it:

```bash
docker compose up -d
```

Give it about 30 seconds, then check the **Fleet Health** section of the Hub dashboard. The sensor should show as **ONLINE**.

## Step 4 - Attacker perspective, trip the wire

On another terminal (or your second machine), connect to the decoy port with `netcat`. Netcat is usually already installed on Ubuntu; if not: `sudo apt install -y netcat-traditional`. Replace `2222` with whatever port your Tarpit sensor is actually listening on:

```bash
nc <sensor-ip> 2222
```

Depending on the Tarpit mode configured, you should see a fake service banner appear. That is the lure working as intended. Type anything, for example:

```
admin
```

Press Enter. The connection will feel like it hangs, that is the "tarpit" part, it is built to waste an attacker's time. Press `Ctrl+C` to close it when you are done.

## Step 5 - Defender perspective, watch the alert

Switch back to the Hub dashboard. Within seconds you should see a new event stream in live, containing:

- The source IP that connected
- The target sensor
- The raw payload you typed (`admin`)
- A severity rating

>[!NOTE]
>This is the whole point of HoneyWire. There is no baseline to tune and no threshold to adjust. The sensor has no legitimate reason to ever be touched, so one connection is a confirmed finding, not a probability.

## Step 6 - Try a scan instead of a manual connection

Let's see what a scanner does instead of a manual `nc` session. From the attacker terminal:

```bash
sudo apt install -y nmap
nmap -sV <sensor-ip> -p 1-100
```

Check the Hub dashboard again. The scan touching the Tarpit port generates its own event too, for the same reason as Step 6, a scan is exactly the kind of "touch that should never happen."

## Step 7 - Arm and disarm the system

Sometimes you need to run your own vulnerability scans or do maintenance without flooding your phone with push alerts. In the dashboard, find the **System Armed** toggle and switch it off before doing that kind of work, then switch it back on afterward.

>[!TIP]
>Disarming only pauses push notifications. Events still get logged to the dashboard either way, so you will not lose visibility.

## Other official sensors to explore afterward

Once this lab feels comfortable, the Sensor Store also includes:

- **Web Router Decoy** - a fake router login page
- **File Canary (FIM)** - alerts if a file that should never be opened gets read
- **ICMP Canary** - a decoy that alerts on ping sweeps
- **Network Scan Detector** - purpose built to flag broad port scans

Each one is deployed the same way as Step 4, generate its compose file from the Sensor Store, drop it on the target machine, `docker compose up -d`.

