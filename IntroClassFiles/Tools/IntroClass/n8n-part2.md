![image](/FilesForLabs/images/blueantisyphon.png)

# n8n - Part 2 - AI Integration

#### Please use the UBUNTU VM

<hr>

> [!NOTE]
> This part builds directly on Part 1. You need the `Security Alert Handler` workflow already created. Here we send an incoming alert to an AI model and have it write a short human-readable triage summary, exactly like a junior analyst would.

For **Part 1**, click [here](./n8n-part1.md)

<hr>

## Lab Objective
In this lab, we will:
- Get an API key from an AI provider
- Connect n8n to the AI using an HTTP Request node
- Have the AI summarize a security alert and suggest a response

---

> [!IMPORTANT]
> This part requires your own API key. In order for this lab to function, you will need to add credits to your openai account.
> Don't worry though, it costs a tiny amount per request (usually a fraction of a cent)

---

## Step 1: Get an API Key

Choose the provider:

- **OpenAI:** create a key at https://platform.openai.com/api-keys

- Copy the key somewhere safe. You will paste it into n8n in a moment.

> [!TIP]
> Treat API Keys like passwords. Never commit them to GitHub or share them.<br>
> n8n stores them encrypted in its credentials store.

---

## Step 2: Add an HTTP Request Node

Open your `Security Alert Handler` workflow from Part 1

<img width="942" height="379" alt="image" src="https://github.com/user-attachments/assets/998eb197-976c-4337-90e7-34f203493206" />


- Hover over the **IF** node and click the `+` on its **True** output (so the AI only runs on high-severity alerts)

<img width="221" height="93" alt="image" src="https://github.com/user-attachments/assets/a6f97c65-89e1-4491-bc23-984fe7fbcc3a" />


- Search for `HTTP Request`
- Click it to add it

---

## Step 3: Configure the Request

We will use the same HTTP Request node you learned in Part 1, just pointed at an AI provider.

- Set **Method** to `POST`
- Set **URL** to:

```
https://api.openai.com/v1/chat/completions
```

- Set **Authentication** to `Generic Credential Type`
- Set **Generic Auth Type** to `Header Auth`

<img width="410" height="280" alt="image" src="https://github.com/user-attachments/assets/420e43a7-147c-41f1-b575-311f2d712b08" />


- Click **Connect to Header Auth** and fill in:
  - **Name:** `Authorization`
  - **Value:** `Bearer YOUR_API_KEY_HERE`

<img width="1199" height="674" alt="image" src="https://github.com/user-attachments/assets/0f0757c9-9736-4566-b42d-5a6db1e781f0" />


- Save the credential
- Set **Send Body** to `on`
- Set **Body Content Type** to `JSON`
- Switch the **Specify Body** to `Using JSON` and paste:

```
{{ JSON.stringify({ model: "gpt-4o-mini", messages: [ { role: "user", content: "You are a SOC analyst. In one short sentence, summarize this security alert and suggest one response action. Alert: " + JSON.stringify($json.body) } ] }) }}
```

<img width="412" height="435" alt="image" src="https://github.com/user-attachments/assets/91b31f32-549c-4c9b-8a06-c798cce300b4" />

---

## Step 4: Execute the Node

- Click **Execute step**

You should see the AI response in the node output

<img width="721" height="598" alt="613589630-9e23d31e-5c36-466f-b644-89ad9ddb7f7b" src="https://github.com/user-attachments/assets/bc455357-9150-4f10-86f1-7074d5bf894c" />


That is the AI-written triage summary of your alert

---

## Step 5: Test the Full Flow

- Make sure the chain is: **Webhook -> IF -> (True) HTTP Request (AI) -> Set -> Respond to Webhook**

<img width="1152" height="427" alt="image" src="https://github.com/user-attachments/assets/7abfb442-7331-479c-bdde-7bef6b196967" />


- Click **Listen for Test Event** on the Webhook node
- In your terminal, send a high-severity alert again:

```bash
curl -X POST http://localhost:5678/webhook-test/YOUR-WEBHOOK-PATH -H "Content-Type: application/json" -d '{"alert_type": "brute_force","source_ip": "192.168.1.50","target": "ssh","severity": "high","timestamp": "2025-01-01T12:00:00Z"}'
```

> [!NOTE]
> Replace `YOUR-WEBHOOK-PATH` with the actual path from your Webhook node.

Watch the canvas: the alert flows in, the AI node lights up, and you get back an AI-written triage line alongside the `block_ip` / `P1` enrichment from Part 1

<img width="1903" height="154" alt="2026-06-26_12-16" src="https://github.com/user-attachments/assets/0ff94df6-d1ea-4a2b-849e-08e4e3231971" />


---

## What this looks like in a real SOC

- AI can summarize noisy alerts into one readable line for a tier-1 analyst
- It can suggest a first response action to speed up triage
- A cloud model needs no local hardware, but the alert data leaves your network - so be careful what you send

---

## Defender vs Attacker Perspective

| Perspective | Takeaway |
|---|---|
| **Defender** | AI enrichment reduces analyst fatigue and speeds up triage. Use it as an assistant, not an authority |
| **Attacker** | AI output should never be trusted blindly - a crafted alert payload could try to manipulate the model (prompt injection). Always treat AI suggestions as advisory, not as an automatic action trigger |

> [!TIP]
> Never let an AI node directly trigger a destructive action (like blocking an IP or isolating a host) without a human in the loop. Prompt injection through attacker-controlled fields is a real risk.


For **Part 1**, click [here](./n8n-part1.md)