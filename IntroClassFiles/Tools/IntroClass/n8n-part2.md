![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# n8n - Part 2 - AI Integration

# Ubuntu VM

> [!NOTE]
> This part builds directly on Part 1. You need the `Security Alert Handler` workflow already created. Here we send an incoming alert to an AI model and have it write a short human-readable triage summary, exactly like a junior analyst would.

## In this part we will

- Get an API key from an AI provider
- Connect n8n to the AI using an HTTP Request node
- Have the AI summarize a security alert and suggest a response

---

> [!NOTE]
> This part requires your own API key. It costs a tiny amount per request (usually a fraction of a cent). The lab shows both OpenAI and Anthropic - pick whichever you have a key for.

---

## Step 1 - Get an API Key

Choose one provider:

- **OpenAI:** create a key at https://platform.openai.com/api-keys
- **Anthropic:** create a key at https://console.anthropic.com/settings/keys

Copy the key somewhere safe. You will paste it into n8n in a moment.

> [!TIP]
> Treat API keys like passwords. Never commit them to GitHub or share them. n8n stores them encrypted in its credentials store.

---

## Step 2 - Add an HTTP Request Node

Open your `Security Alert Handler` workflow from Part 1.

- Hover over the **IF** node and click the `+` on its **True** output (so the AI only runs on high-severity alerts)
- Search for `HTTP Request`
- Click it to add it

---

## Step 3 - Configure the Request

We will use the same HTTP Request node you learned in Part 1, just pointed at an AI provider.

### Option A - OpenAI

- Set **Method** to `POST`
- Set **URL** to:

```
https://api.openai.com/v1/chat/completions
```

- Set **Authentication** to `Generic Credential Type`
- Set **Generic Auth Type** to `Header Auth`
- Click **Create new credential** and fill in:
  - **Name:** `Authorization`
  - **Value:** `Bearer YOUR_API_KEY_HERE`
- Save the credential
- Set **Send Body** to `on`
- Set **Body Content Type** to `JSON`
- Switch the body field to expression mode (the `{}` icon) and paste:

```
{
  "model": "gpt-4o-mini",
  "messages": [
    {
      "role": "user",
      "content": "You are a SOC analyst. In one short sentence, summarize this security alert and suggest one response action. Alert: {{ JSON.stringify($json.body) }}"
    }
  ]
}
```

### Option B - Anthropic

- Set **Method** to `POST`
- Set **URL** to:

```
https://api.anthropic.com/v1/messages
```

- Set **Authentication** to `Generic Credential Type`
- Set **Generic Auth Type** to `Header Auth`
- Click **Create new credential** and fill in:
  - **Name:** `x-api-key`
  - **Value:** `YOUR_API_KEY_HERE`
- Save the credential
- Under **Send Headers**, set it to `on` and add one header:
  - **Name:** `anthropic-version`
  - **Value:** `2023-06-01`
- Set **Send Body** to `on`
- Set **Body Content Type** to `JSON`
- Switch the body field to expression mode (the `{}` icon) and paste:

```
{
  "model": "claude-3-5-haiku-latest",
  "max_tokens": 256,
  "messages": [
    {
      "role": "user",
      "content": "You are a SOC analyst. In one short sentence, summarize this security alert and suggest one response action. Alert: {{ JSON.stringify($json.body) }}"
    }
  ]
}
```

> [!NOTE]
> Model names change over time. If you get a model error, check the provider's current model list (https://platform.openai.com/docs/models or https://docs.anthropic.com) and update the `model` field.

---

## Step 4 - Execute the Node

- Click **Execute step**

You should see the AI response in the node output.

- For **OpenAI**, the text is under `choices[0].message.content`
- For **Anthropic**, the text is under `content[0].text`

That is the AI-written triage summary of your alert.

---

## Step 5 - Test the Full Flow

- Make sure the chain is: **Webhook -> IF -> (True) HTTP Request (AI) -> Set -> Respond to Webhook**
- Click **Listen for Test Event** on the Webhook node
- In your terminal, send a high-severity alert again:

```bash
curl -X POST http://localhost:5678/webhook-test/YOUR-WEBHOOK-PATH -H "Content-Type: application/json" -d '{"alert_type": "brute_force","source_ip": "192.168.1.50","target": "ssh","severity": "high","timestamp": "2025-01-01T12:00:00Z"}'
```

> [!NOTE]
> Replace `YOUR-WEBHOOK-PATH` with the actual path from your Webhook node.

Watch the canvas: the alert flows in, the AI node lights up, and you get back an AI-written triage line alongside the `block_ip` / `P1` enrichment from Part 1.

---

## Summary

| Concept | What you did |
|---|---|
| API key auth | Stored a provider key securely in n8n as a Header Auth credential |
| HTTP Request to AI | Sent the alert to a cloud AI model and got a plain-English summary |
| Conditional AI | Ran the AI only on high-severity alerts to save cost |

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

> [!NOTE]
> A cloud AI provider sees whatever data you send it. Do not send real customer data, credentials, or sensitive PII to a third-party model without checking your data-handling policy first.

---

## Finished?

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)
