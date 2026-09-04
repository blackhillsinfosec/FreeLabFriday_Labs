![image](/FilesForLabs/images/blueantisyphon.png)

# n8n - Part 1 - General Automation

#### Please use the UBUNTU VM


<img width="580" height="597" alt="image" src="https://github.com/user-attachments/assets/93e2a254-8454-4d28-92ad-45665e8363fd" />


<hr>

For **Part 2**, click [here](./n8n-part2.md)

<hr>

## Lab Objective
In this lab we will:
- Deploy n8n using Docker with persistent storage
- Explore the n8n web interface
- Build a simple HTTP-triggered workflow
- Automate a security alert notification via webhook
- Understand how n8n can be used in a SOC context for alert routing and automation

---

> [!NOTE]
> n8n is an open-source workflow automation tool. It lets you connect apps and services together using a visual drag-and-drop editor. In a security context it is used for things like routing alerts, enriching IOCs automatically, or triggering responses based on SIEM events

---

## Step 1: Create a Directory for n8n Data

Open a **Terminal**

<img width="50" height="54" alt="image" src="https://github.com/user-attachments/assets/181d7470-566f-444e-9463-bba59600aebd" />


n8n stores your workflows, credentials, and settings on disk. We will create a local folder and mount it into the container so your data persists even if the container is removed.

```bash
mkdir -p ~/.n8n
```

---

## Step 2:  Run n8n with Docker

Make some space for **n8n**'s image:

```bash
sudo docker rmi \
  decepot/glastopf:latest
```

Run the following command to pull and start **n8n** ( it might take a couple of minutes ):

```bash
sudo docker run -d --name n8n -p 5678:5678 -v ~/.n8n:/home/node/.n8n -e N8N_BASIC_AUTH_ACTIVE=true -e N8N_BASIC_AUTH_USER=admin -e N8N_BASIC_AUTH_PASSWORD=securepass --restart unless-stopped n8nio/n8n
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

## Step 3: Open the n8n Interface

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

You don't have to pick anything, just press **Get Started**

<img width="454" height="600" alt="image" src="https://github.com/user-attachments/assets/5f7c4d14-7e05-4afd-a7bb-0352917416ae" />

Then press **Skip**

<img width="494" height="529" alt="image" src="https://github.com/user-attachments/assets/5d35082b-22d3-42f7-ac5b-5efd2c42e285" />


Press **Build a workflow**

<img width="652" height="456" alt="image" src="https://github.com/user-attachments/assets/643b4463-52af-4b1a-a75e-fc3bee0ef1f5" />

---

## Step 4: Build Your First Workflow

We will build a simple workflow that manually triggers and fetches data from a public API.

<br>

### Add a Manual Trigger node

- Click the `+` button in the canvas
- Search for `Manual Trigger`
- Click it to add it to the canvas

<img width="1102" height="552" alt="2026-06-24_20-31" src="https://github.com/user-attachments/assets/51cdf125-30aa-4f2f-861a-3ce3d42c5970" />


This node lets you run the workflow by clicking a button.

<br>

### Add an HTTP Request node

- Click the `+` circle that appears on the right

<img width="502" height="284" alt="2026-06-25_11-28" src="https://github.com/user-attachments/assets/46d646a1-cfba-467f-b22b-e025964044cf" />

- Search for `HTTP Request`
- Click it to add it and connect it automatically

<img width="408" height="297" alt="2026-06-25_11-27" src="https://github.com/user-attachments/assets/793a1b77-164d-48cc-8185-5c2752dfc3fa" />

<br>

### Configure the HTTP Request node

- Set **Method** to `GET`
- Set **URL** to:

```
https://jsonplaceholder.typicode.com/posts/1
```

This is a free public test API that returns fake JSON data - no API key needed.

- Click **Execute node** (the play button inside the node settings)

You should see a JSON response appear on the right panel with fields like `userId`, `id`, `title`, `body`

- Close the node settings

<img width="1868" height="692" alt="2026-06-25_11-31" src="https://github.com/user-attachments/assets/340fba77-ff71-411a-a6bd-abd6bd523f00" />

<br>

### Run the whole workflow

- Click **Execute Workflow** (the play button at the bottom)

<img width="261" height="65" alt="image" src="https://github.com/user-attachments/assets/d29686d9-afef-4cad-b8e6-c85c533a3a16" />


You will see green checkmarks appear on both nodes, and the data flows from left to right. Double click on the HTTP Request node to see the output data

> [!TIP]
> This is the core concept of n8n: data flows from node to node. Each node receives input, does something, and passes output to the next node.

---

## Step 5: Build a Security Alert Workflow

Now we will build something more realistic: a webhook endpoint that receives an alert payload and processes it.

<br>

### Create a new workflow

- Click the `+` button in the top left (or go to **Workflows** -> **New**)

<img width="261" height="74" alt="image" src="https://github.com/user-attachments/assets/58c409c9-8c26-4d47-8b36-a3ab06c1c2d6" />

- Name it `Security Alert Handler`

### Add a Webhook node

- Click `+` on the canvas

<img width="205" height="189" alt="image" src="https://github.com/user-attachments/assets/e6c95d16-e843-4f27-a4bd-63f26ad69c0a" />

- Search for `Webhook`
- Add it to the canvas

<br>

### Configure the Webhook node

- Set **HTTP Method** to `POST`
- Leave the **Path** as the default
- Set **Respond** to `Immediately`
- Click **Listen for Test Event** - this activates the endpoint temporarily so you can test it

<img width="541" height="558" alt="2026-06-25_11-41" src="https://github.com/user-attachments/assets/d670bb78-e4a8-42f1-8e2f-1673f16aed5d" />


<img width="719" height="787" alt="image" src="https://github.com/user-attachments/assets/49c0ca72-80e9-45a6-bdf0-f56c116c6d16" />


Leave the node settings open. Copy the **Test URL** shown (it will look like `http://localhost:5678/webhook-test/1b4f0847-5b43-42b0-97e5-5042409ca634`)

<br>

### Send a test alert to the webhook

Open a **new terminal** (keep the first one available):

```bash
curl -X POST http://localhost:5678/webhook-test/1b4f0847-5b43-42b0-97e5-5042409ca634 -H "Content-Type: application/json" -d '{"alert_type": "brute_force","source_ip": "192.168.1.50","target": "ssh","severity": "high","timestamp": "2025-01-01T12:00:00Z"}'
```

<img width="1144" height="229" alt="image" src="https://github.com/user-attachments/assets/15f83b41-878e-4a00-bb94-26c73aa0cdfc" />


> [!NOTE]
> Replace `1b4f0847-5b43-42b0-97e5-5042409ca634` in the URL above with the actual path shown in your Webhook node.

Back in the n8n canvas you should see the webhook node light up with the **Output** section, switch to **JSON** instead of **Table** if you want. The JSON payload you sent will be visible in the node output panel.

<img width="720" height="571" alt="image" src="https://github.com/user-attachments/assets/d91bc400-8af4-4871-89e4-28edfaa490b6" />


---

## Step 6: Add an IF Node to Route by Severity

Now we will add logic: if severity is `high`, we route one way; otherwise another.

<br>

### Add an IF node

- Hover over the Webhook node, click the `+` on its right side

<img width="342" height="181" alt="2026-06-25_11-45" src="https://github.com/user-attachments/assets/e96b7246-0b0b-46d0-b79e-1e9cda51da7e" />

- Search for `IF`
- Click it

<br>

### Configure the IF node

- Under **Conditions**, click **value1**
- Drag **severity** there

- Set **Operation** to `String -> is equal to`
- Set **value2** to: `high`
- Click **Execute node** to test

<img width="1870" height="700" alt="2026-06-25_11-52" src="https://github.com/user-attachments/assets/f71d26f1-8fef-4470-8a71-7aa4c89a2cce" />


The node will show two outputs: **True** (severity equals high) and **False** (everything else).

You can close the **if node** settings

<br>

### Add a Set node to simulate alert enrichment

- From the **True** output of the IF node, click `+`

<img width="597" height="200" alt="2026-06-25_11-53" src="https://github.com/user-attachments/assets/0472d44a-83e3-4718-ad25-44d6304e1105" />


- Search for `Set`

<img width="376" height="153" alt="Screenshot 2026-06-26 113754" src="https://github.com/user-attachments/assets/f2967af4-ce8c-461d-bda8-a99ca1a73c21" />

- Click it

<br>

### Configure the Set node

- Click **Add field**

<img width="422" height="261" alt="2026-06-25_11-54" src="https://github.com/user-attachments/assets/bf76ce9b-c8f7-4eb9-b345-f2dec32d24f2" />


- Set **Name** to `action`
- Set **Value** to `block_ip`
- Add another field: **Name** = `priority`, **Value** = `P1`
- Toggle **"Include Other Input Fields"** `on`
- Click **Execute node**

You will see the node output the original data plus the two new fields you added

<img width="1137" height="646" alt="image" src="https://github.com/user-attachments/assets/4e611367-eecb-4d92-90ce-b6d0cd9ddb33" />

- From the **false** output of the IF node, click `+`
- Search for `Respond to Webhook` and add it
- Click **Add Option** and choose `Response Code`
- Set **Response Code** to `200`
- Leave **Respond With** as `First Incoming Item`

- No need to **Execute** this node alone, you can close the windows

<img width="422" height="335" alt="image" src="https://github.com/user-attachments/assets/c82ee1c0-9491-44b4-84cf-a10c96e3d4b7" />



> This simulates what a real SOAR would do - enriching an alert with a recommended action before passing it downstream.

---

## Step 7: Add a Respond to Webhook node

Let's make the webhook return a proper response to the caller.

- From the Set node, click `+`

<img width="275" height="175" alt="2026-06-25_11-59" src="https://github.com/user-attachments/assets/fbc208b9-ca86-4dbb-b593-5991c1da0c22" />


- Search for `Respond to Webhook`
- Click it

<br>

### Configure it

- Click **Add Option** and choose `Response Code`
- Set **Response Code** to `200`

<img width="429" height="323" alt="image" src="https://github.com/user-attachments/assets/2bb3244b-c908-4cad-90c5-9dbe4938c5d3" />


- No need to **Execute** this node alone, you can close the windows

<br>

### Test the full flow

Go back to the **Webhook** node and set **Respond** to `Using 'Respond to Webhook' Node`

<img width="454" height="537" alt="2026-06-25_12-19" src="https://github.com/user-attachments/assets/5254b9f6-2b90-49e5-bb6f-10578ca86e86" />

- Click **Execute Workflow** (bottom button)

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
{"headers":{"host":"localhost:5678","user-agent":"curl/8.5.0","accept":"*/*","content-type":"application/json","content-length":"156"},"params":{},"query":{},"body":{"alert_type":"brute_force","source_ip":"192.168.1.50","target":"ssh","severity":"high","timestamp":"2025-01-01T12:00:00Z"},"webhookUrl":"http://localhost:5678/webhook-test/1b4f0847-5b43-42b0-97e5-5042409ca634","executionMode":"test"}
```

And then appended at the end:

```json
{"action":"block_ip","priority":"P1"}
```

<img width="1323" height="266" alt="image" src="https://github.com/user-attachments/assets/803ceb80-a951-4e61-b262-d3d8a1bc777d" />


And back in n8n, all nodes should show green

<img width="1069" height="425" alt="image" src="https://github.com/user-attachments/assets/afc311d0-1213-46ba-8156-b2116444bd49" />

<hr>

For **Part 2**, click [here](./n8n-part2.md)
