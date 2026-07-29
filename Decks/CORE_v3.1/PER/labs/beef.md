![image](/FilesForLabs/images/blueantisyphon.png)


# Browser Exploitation Framework (BeEF)

# Ubuntu VM

## In this lab we will
- Start the BeEF framework
- Hook a victim browser using a JavaScript hook
- Explore what information BeEF collects automatically
- Execute basic browser-side commands from the attacker panel
- Understand what defenders should look for

---

## Step 1 - Configure credentials

Open a terminal on your Ubuntu machine

<img width="48" height="52" alt="image" src="https://github.com/user-attachments/assets/fe596f48-cf89-47ef-b529-4d4f155cd0d5" />

```bash
cd ~/BnB/beef
```

Before starting BeEF for the first time, set your own password in the config file. The default credentials (`beef/beef`) are intentionally blocked on startup.

Open the config file:

```bash
nano config.yaml
```

Find these lines near the top:

```yaml
credentials:
  user:   "beef"
  passwd: "beef"
```

Change `passwd` to something you will remember, for example:

```yaml
credentials:
  user:   "beef"
  passwd: "BeefLab123!"
```

<img width="331" height="76" alt="image" src="https://github.com/user-attachments/assets/9c33ba52-4b10-41d9-993e-6a4a6546c4c0" />


Save and exit: `Ctrl+O`, `Enter`, `Ctrl+X`.

---

## Step 2 - Start BeEF

```bash
sudo ./beef
```

You will see output similar to:

<img width="742" height="704" alt="image" src="https://github.com/user-attachments/assets/6c2e2dd7-c8fd-4443-a406-4176ab8605fa" />


Leave this terminal open. BeEF is now running

---

## Step 3 - Log in to the attacker panel

Open a browser on Ubuntu (Firefox or Chromium) and go to:

```
http://127.0.0.1:3000/ui/panel
```

Log in with the credentials you set in Step 2

<img width="600" height="434" alt="image" src="https://github.com/user-attachments/assets/0bff9b8a-6f98-49e5-907f-756243f3a787" />


You will land on the BeEF dashboard. It has three main panels:
- **Left** - Hooked Browsers (none yet)
- **Center** - Commands and modules and Tabs + Module Results

---

## Step 4 - Hook a victim browser

BeEF ships with a built-in demo page that already has `hook.js` loaded.

Open a **new browser tab** (this simulates the victim's browser) and go to:

```
http://127.0.0.1:3000/demos/basic.html
```

You do not need to click anything. The moment the page loads, the browser is hooked.

Switch back to the BeEF panel tab


<img width="1380" height="581" alt="2026-06-17_23-28" src="https://github.com/user-attachments/assets/baebf53c-247e-4050-b49b-c3a64d93942d" />

Under **Hooked Browsers -> Online Browsers** you will now see an entry appear. Click on it


<img width="242" height="147" alt="2026-06-17_23-29" src="https://github.com/user-attachments/assets/bf53f0f4-f6f5-4fa9-9a35-24d844918550" />


---

## Step 5 - Explore what BeEF collects automatically

Click on the hooked browser entry in the left panel. Look at the **Details** tab

<img width="1774" height="779" alt="image" src="https://github.com/user-attachments/assets/527c26bd-9eba-4e2b-a614-e0d1a9205606" />


BeEF automatically harvests:
- Browser name, version, and engine
- Operating system
- Screen resolution
- Installed plugins
- Whether cookies are enabled
- Whether Java is installed
- The page the hook was injected on

This happens with zero interaction from the victim. Simply loading the page is enough.

---

## Step 6 - Run your first command - Alert dialog

Click on the **Commands** tab in the center panel

<img width="920" height="311" alt="2026-06-17_23-31" src="https://github.com/user-attachments/assets/fa72c5e4-1cb8-4e7b-acbe-bb3f4c36c312" />


Expand **Browsers -> Hooked Domain -> Create Alert Dialog**

<img width="258" height="532" alt="2026-06-17_23-33" src="https://github.com/user-attachments/assets/be7980b7-26a5-4470-94c1-362765747806" />


In the module panel on the right, you will see a text field labelled **Alert Text**. Type:

```
You have been hooked by BeEF!
```

Click **Execute**.

Now switch to the victim browser, open another tab (the `http://127.0.0.1:3000/demos/basic.html` tab). You will see a JavaScript alert popup appear with your message

<img width="1400" height="579" alt="image" src="https://github.com/user-attachments/assets/30b511c1-945d-491b-89e5-f9f5ca50e410" />

This is how an attacker can execute arbitrary JavaScript in the victim browser

---

## Step 7 - Get browser geolocation

Expand **Host -> Get Geolocation(API)**

<img width="259" height="509" alt="2026-06-17_23-38" src="https://github.com/user-attachments/assets/2e316a1c-32d3-4066-8553-9e0561e4c3fb" />


Click **Execute**

Switch to the victim tab. The browser will show a permission prompt asking whether to share location. Click **Allow**

<img width="699" height="247" alt="2026-06-17_23-38" src="https://github.com/user-attachments/assets/f7a36e9a-cc28-44ea-b422-37c609b2599c" />


Back in BeEF under Command History, after a few seconds you will see the result with latitude and longitude coordinates

<img width="1171" height="398" alt="2026-06-17_23-41" src="https://github.com/user-attachments/assets/83cbf6ad-5862-47b6-8ec6-cf172e4ae322" />


> [!NOTE]
> In VM environments and remote desktop sessions (such as Guacamole), geolocation will return TIMEOUT because there is no physical GPS or location service available. This is expected. In a real attack scenario against a physical device, this would return actual coordinates


---

## Step 8 - Redirect the victim browser

Expand **Browsers -> Hooked Domain -> Redirect Browser (Standard)**

<img width="255" height="638" alt="2026-06-17_23-44" src="https://github.com/user-attachments/assets/e1c4e67e-d480-4fff-9877-93d005e2d309" />


In the **Redirect URL** field enter:

```
https://beefproject.com
```

Click **Execute**.

Watch the victim tab. It will navigate to the BeEF project website automatically. The victim has no control over this - the attacker redirected them silently

<img width="1917" height="891" alt="image" src="https://github.com/user-attachments/assets/b1442a6c-2595-447b-bb3c-30490056aa94" />


---

## Step 9 - Run a port scan against the victim's local network

This module uses the victim's browser as a proxy to scan their internal network.

Expand **Network -> Port Scanner**.

Set the **Scan IP or Hostname** to `127.0.0.1` with a port range of common ports. Leave the defaults and click **Execute**

<img width="1683" height="749" alt="2026-06-18_00-05" src="https://github.com/user-attachments/assets/fb8d10ad-8a5a-47eb-aab5-e3a4d67e3d81" />


After a minute or two, the results will appear in Command History showing which ports responded on the victim's local machine (from the victim's own network perspective)

<img width="1483" height="155" alt="image" src="https://github.com/user-attachments/assets/0eb5d946-ee64-48f0-b54c-928ec4992d76" />


This is significant because the victim's browser can reach internal addresses that the attacker cannot reach directly from the internet.

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Browser_Plugins.md)

---

> Created by Turcu-Stiolica Alexandru
