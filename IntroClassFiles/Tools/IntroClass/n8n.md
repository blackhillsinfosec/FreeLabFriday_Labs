# n8n - Workflow Automation Lab

# Ubuntu VM

## In this lab we will

- Deploy n8n using Docker with persistent storage
- Explore the n8n web interface
- Build a simple HTTP-triggered workflow
- Automate a security alert notification via webhook
- Understand how n8n can be used in a SOC context for alert routing and automation

---

> [!NOTE]
> n8n is an open-source workflow automation tool. It lets you connect apps and services together using a visual drag-and-drop editor. In a security context it is used for things like routing alerts, enriching IOCs automatically, or triggering responses based on SIEM events

---

## Step 1 - Create a Directory for n8n Data

n8n stores your workflows, credentials, and settings on disk. We will create a local folder and mount it into the container so your data persists even if the container is removed.

```bash
mkdir -p ~/.n8n
```

---

## Step 2 - Run n8n with Docker

Run the following command to pull and start **n8n** ( it might take a couple of minutes ):

```bash
sudo docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=securepass \
  --restart unless-stopped \
  n8nio/n8n
```

What each flag does:

| Flag | Purpose |
|---|---|
| `-d` | Run in detached mode (background) |
| `--name n8n` | Give the container a name so you can reference it easily |
| `-p 5678:5678` | Map port 5678 on your host to port 5678 in the container |
| `-v ~/.n8n:/home/node/.n8n` | Mount your local folder into the container for persistent data |
| `-e N8N_BASIC_AUTH_*` | Enable basic auth to protect the UI |
| `--restart unless-stopped` | Auto-restart the container after reboots |

Check that the container is running:

```bash
sudo docker ps
```

<img width="1815" height="69" alt="image" src="https://github.com/user-attachments/assets/94ba4114-37fe-4586-9b1d-07ce6eb0de38" />


---

## Step 3 - Open the n8n Interface

Open your browser and go to:

```
http://localhost:5678
```

You will have to set up the owner account, fill in whatever fake information you want:

- **Email:** `admin@lab.local`
- **First Name:** `John`
- **Last Name:** `Doe`
- **Password:** `Lab12345`

<img width="440" height="657" alt="image" src="https://github.com/user-attachments/assets/e111b0d2-46f0-4adc-921d-74fb3444580f" />

Then press **Skip**

<img width="494" height="529" alt="image" src="https://github.com/user-attachments/assets/5d35082b-22d3-42f7-ac5b-5efd2c42e285" />


Press **Build a workflow**

<img width="652" height="456" alt="image" src="https://github.com/user-attachments/assets/643b4463-52af-4b1a-a75e-fc3bee0ef1f5" />

---

## Step 4 - Build Your First Workflow: Manual Trigger -> HTTP Request

We will build a simple workflow that manually triggers and fetches data from a public API.

### Add a Manual Trigger node

- Click the `+` button in the canvas
- Search for `Manual Trigger`
- Click it to add it to the canvas

<img width="1102" height="552" alt="2026-06-24_20-31" src="https://github.com/user-attachments/assets/51cdf125-30aa-4f2f-861a-3ce3d42c5970" />


This node lets you run the workflow by clicking a button.

### Add an HTTP Request node

- Hover over the Manual Trigger node and click the `+` circle that appears on the right
- Search for `HTTP Request`
- Click it to add it and connect it automatically

### Configure the HTTP Request node

- Double-click the HTTP Request node to open its settings
- Set **Method** to `GET`
- Set **URL** to:

```
https://jsonplaceholder.typicode.com/posts/1
```

This is a free public test API that returns fake JSON data - no API key needed.

- Click **Execute node** (the play button inside the node settings)

You should see a JSON response appear on the right panel with fields like `userId`, `id`, `title`, `body`.

- Close the node settings

### Run the whole workflow

- Click **Execute Workflow** (the play button at the top)

You will see green checkmarks appear on both nodes, and the data flows from left to right. Click on the HTTP Request node to see the output data.

> [!TIP]
> This is the core concept of n8n: data flows from node to node. Each node receives input, does something, and passes output to the next node.

---

## Step 5 - Build a Security Alert Workflow using a Webhook

Now we will build something more realistic: a webhook endpoint that receives an alert payload and processes it.

### Create a new workflow

- Click the `+` button in the top left (or go to **Workflows** -> **New**)
- Name it `Security Alert Handler`

### Add a Webhook node

- Click `+` on the canvas
- Search for `Webhook`
- Add it to the canvas

### Configure the Webhook node

- Double-click the Webhook node
- Set **HTTP Method** to `POST`
- Leave the **Path** as the default (it will generate something like `/webhook/abc123`)
- Set **Response Mode** to `Immediately`
- Click **Listen for Test Event** - this activates the endpoint temporarily so you can test it

Leave the node settings open. Copy the **Test URL** shown (it will look like `http://localhost:5678/webhook-test/abc123`).

### Send a test alert to the webhook

Open a **new terminal** (keep the first one available):

```bash
curl -X POST http://localhost:5678/webhook-test/abc123 \
  -H "Content-Type: application/json" \
  -d '{
    "alert_type": "brute_force",
    "source_ip": "192.168.1.50",
    "target": "ssh",
    "severity": "high",
    "timestamp": "2025-01-01T12:00:00Z"
  }'
```

> [!NOTE]
> Replace `abc123` in the URL above with the actual path shown in your Webhook node.

Back in the n8n canvas you should see the webhook node light up with the received data. The JSON payload you sent will be visible in the node output panel.

---

## Step 6 - Add an IF Node to Route by Severity

Now we will add logic: if severity is `high`, we route one way; otherwise another.

### Add an IF node

- Hover over the Webhook node, click the `+` on its right side
- Search for `IF`
- Add it to the canvas

### Configure the IF node

- Double-click the IF node
- Under **Conditions**, click **Add Condition**
- Set the left side to: `{{ $json.severity }}`

  (Click the field, type the expression above, or use the expression editor by clicking the `{}` icon)

- Set **Operation** to `Equal`
- Set the right side to: `high`
- Click **Execute node** to test

The node will show two outputs: **True** (severity equals high) and **False** (everything else).

### Add a Set node to simulate alert enrichment

- From the **True** output of the IF node, click `+`
- Search for `Set`
- Add and connect it

### Configure the Set node

- Double-click the Set node
- Click **Add field**
- Set **Name** to `action`
- Set **Value** to `block_ip`
- Add another field: **Name** = `priority`, **Value** = `P1`
- Click **Execute node**

You will see the node output the original data plus the two new fields you added.

> This simulates what a real SOAR would do - enriching an alert with a recommended action before passing it downstream.

---

## Step 7 - Add a Respond to Webhook node

Let's make the webhook return a proper response to the caller.

- From the Set node, click `+`
- Search for `Respond to Webhook`
- Add it

### Configure it

- Double-click the node
- Set **Response Code** to `200`
- Set **Response Body** to:

```json
{"status": "alert received", "action": "block_ip"}
```

- Click **Save** on the workflow (top right)

### Test the full flow

- Click **Execute Workflow** (top play button)
- Switch back to **Listen for Test Event** on the Webhook node if needed
- In your second terminal, re-run the curl command:

```bash
curl -X POST http://localhost:5678/webhook-test/abc123 \
  -H "Content-Type: application/json" \
  -d '{
    "alert_type": "brute_force",
    "source_ip": "192.168.1.50",
    "target": "ssh",
    "severity": "high",
    "timestamp": "2025-01-01T12:00:00Z"
  }'
```

You should see the response:

```json
{"status": "alert received", "action": "block_ip"}
```

And back in n8n, all nodes should show green.

---

## Step 8 - Activate the Workflow (Production Mode)

Right now the webhook only works in test mode. To make it persistent:

- Click the **Inactive** toggle in the top right of the canvas
- It will switch to **Active**

Now the workflow runs permanently. The URL changes from `/webhook-test/...` to `/webhook/...`

Test the production URL:

```bash
curl -X POST http://localhost:5678/webhook/abc123 \
  -H "Content-Type: application/json" \
  -d '{
    "alert_type": "port_scan",
    "source_ip": "10.0.0.99",
    "target": "firewall",
    "severity": "low",
    "timestamp": "2025-01-01T13:00:00Z"
  }'
```

This time severity is `low`, so the IF node will go down the **False** path. Watch the execution to see the difference.

---

## Step 9 - View Execution History

- Click the hamburger menu (top left) -> **Executions**

You will see a log of every time the workflow ran, including:

- Timestamp
- Status (success/error)
- Execution time

Click on any execution to replay and inspect it step by step. This is critical for debugging and for auditing in a SOC context.

---

## Finished with the Labs?

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)
