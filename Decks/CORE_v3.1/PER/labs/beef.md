![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


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
- **Center** - Commands and modules
- **Right** - Module results

---

## Step 4 - Hook a victim browser

BeEF ships with a built-in demo page that already has `hook.js` loaded.

Open a **new browser tab** (this simulates the victim's browser) and go to:

```
http://127.0.0.1:3000/demos/basic.html
```

You do not need to click anything. The moment the page loads, the browser is hooked.

Switch back to the BeEF panel tab. Under **Hooked Browsers -> Online Browsers** you will now see an entry appear. Click on it.

---

## Step 5 - Explore what BeEF collects automatically

Click on the hooked browser entry in the left panel. Look at the **Details** tab on the right side.

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

Click on the **Commands** tab in the center panel.

Expand **Browsers -> Hooked Domain -> Alert Dialog**.

In the module panel on the right, you will see a text field labelled **Alert Text**. Type:

```
You have been hooked by BeEF!
```

Click **Execute**.

Now switch to the victim browser tab (the `basic.html` tab). You will see a JavaScript alert popup appear with your message.

Switch back to the BeEF panel. Under **Command History** at the bottom, the command will show a green checkmark and status **success**.

This demonstrates that the attacker can execute arbitrary JavaScript in the victim browser.

---

## Step 7 - Get browser geolocation

Expand **Geolocation -> Get Geolocation**.

Click **Execute**.

Switch to the victim tab. The browser will show a permission prompt asking whether to share location. Click **Allow**.

Back in BeEF under Command History, after a few seconds you will see the result with latitude and longitude coordinates.

>[!NOTE]
>If location permissions are blocked in your VM's browser settings, the result will be empty. That is expected.

---

## Step 8 - Redirect the victim browser

Expand **Browsers -> Hooked Domain -> Redirect Browser**.

In the **Redirect URL** field enter:

```
https://beefproject.com
```

Click **Execute**.

Watch the victim tab. It will navigate to the BeEF project website automatically. The victim has no control over this - the attacker redirected them silently.

---

## Step 9 - Run a port scan against the victim's local network

This module uses the victim's browser as a proxy to scan their internal network.

Expand **Network -> Port Scanner**.

The default scan target is `127.0.0.1` with a port range of common ports. Leave the defaults and click **Execute**.

After a minute or two, the results will appear in Command History showing which ports responded on the victim's local machine (from the victim's own network perspective).

This is significant because the victim's browser can reach internal addresses that the attacker cannot reach directly from the internet.

---

## Step 10 - Defender perspective

Open a new terminal and run:

```bash
sudo ss -tulnp | grep 3000
```

You will see BeEF listening on port 3000.

Now look at what the hook script looks like from a network perspective. Run:

```bash
curl -s http://127.0.0.1:3000/hook.js | head -5
```

You will see obfuscated JavaScript. This is what gets injected into a vulnerable page. A defender monitoring outbound traffic would see the victim browser making repeated HTTP requests to the BeEF server every few seconds - this is the "heartbeat" that keeps the hook alive.

Check the BeEF log:

```bash
sudo tail -f /var/log/beef-xss/beef.log
```

You will see every command executed and every browser event logged with timestamps.

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Browser_Plugins.md)

---

> Created by Turcu-Stiolica Alexandru
