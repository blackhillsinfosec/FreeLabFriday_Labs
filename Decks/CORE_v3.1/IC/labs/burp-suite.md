![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Burp Suite

# Burp Suite Community Edition

# Ubuntu VM

**Burp Suite Community Edition** is the free version of the industry-standard web application security testing toolkit made by PortSwigger. It sits between your browser and the target web app as a **man-in-the-middle proxy**, letting you see, modify, replay, and analyze every HTTP request and response.

### In this lab we will

- Spin up a deliberately vulnerable web app (**OWASP Juice Shop**) as our practice target
- Use **Proxy** to intercept and modify a live request
- Use **HTTP history** to inspect traffic that already passed through
- Use **Repeater** to manually tamper with requests and observe responses
- Use **Decoder** to encode/decode data (Base64, URL, etc.)
- Use **Comparer** to diff two responses
- Briefly try **Intruder** (note: Community Edition throttles it heavily)


---

## Part 1 - Open Burp Suite Community

Select the `search` icon in your taskbar and search `Burp Suite`

<img width="555" height="628" alt="2026-04-29_17-38" src="https://github.com/user-attachments/assets/5ec278ac-9741-4691-9d27-74ba657cb457" />

Double Click `Burp Suite Community Edition`

<img width="775" height="599" alt="image" src="https://github.com/user-attachments/assets/ab76d808-6597-4a73-8e1f-e3fa624dcbf0" />

Leave the **defaults** and click `Next`

<img width="777" height="599" alt="image" src="https://github.com/user-attachments/assets/8aac1c6d-717e-4274-9c4a-8dc935d98f5d" />

Leave the defaults again and click `Start Burp`

You should land on the Burp dashboard/discover tab

<img width="1915" height="961" alt="image" src="https://github.com/user-attachments/assets/1feba374-38ed-4169-8b45-0602b5e700d7" />


---

## Part 2 - Spin up our practice target (OWASP Juice Shop)

We need a vulnerable web app to attack. **OWASP Juice Shop** is a deliberately broken e-commerce site, perfect for this

Run Juice Shop as it is already on the system:

```bash
sudo docker run -d --rm -p 3000:3000 --name juice-new bkimminich/juice-shop:v19.2.1
```

Confirm it's running:

```bash
sudo docker ps
```

<img width="1844" height="66" alt="image" src="https://github.com/user-attachments/assets/261ef2f7-2515-4fe2-8f5d-75b1ef8a21d9" />

You should see `juice-shop` listening on `0.0.0.0:3000`.

Open `http://localhost:3000` in any browser to verify the site loads

<img width="1916" height="943" alt="image" src="https://github.com/user-attachments/assets/b6baa41a-3a84-4a85-856b-34432f291a6b" />

---

## Part 3 - Use Burp's built-in browser (the easy path)

Go back to **Burp Suite**

Burp Community ships a pre-configured Chromium browser. Using it means you **don't** have to install Burp's CA certificate or fiddle with proxy settings - those are pre-set

In Burp:
1. Click the **Proxy** tab (top)
2. Click the **Open browser** button. A new Chromium window opens ( it can take a while, be patient )

<img width="1908" height="351" alt="image" src="https://github.com/user-attachments/assets/e66a2ee7-bba3-4945-985f-8dadc1e244f5" />


3. In that browser, navigate to:
```
http://localhost:3000
```

You should see Juice Shop. From now on, **always use this browser** for the lab - it's the one Burp can see

*(Insert screenshot of "Open browser" button highlighted)*

---

## Part 4 - Intercept a request with Proxy

This is the canonical Burp move: pause a request mid-flight, change it, then let it through.

1. In Burp, go to **Proxy -> Intercept**.
2. Click **Intercept is off** so it toggles to **Intercept is on**.
3. In Burp's browser, on the Juice Shop site, click anywhere - for example, click the **Account** menu, then **Login**.
4. Type any email and password (e.g. `test@test.com` / `wrongpass`) and click **Log in**.

The browser will appear to hang. That's because Burp is holding the request. Switch to Burp - you'll see the raw HTTP request:

```
POST /rest/user/login HTTP/1.1
Host: localhost:3000
...
{"email":"test@test.com","password":"wrongpass"}
```

Now **modify it before forwarding**. Change the password to something else, e.g.:
```
{"email":"test@test.com","password":"hacked"}
```
Click **Forward**. The (modified) request hits the server. The server still rejects it (wrong creds), but you just demonstrated full request control.

Toggle **Intercept is off** when you're done so the browser stops hanging on every click.

*(Insert screenshot of intercepted request in Burp)*

---

## Part 5 - Browse HTTP history

Even when intercept is **off**, Burp logs everything that passed through.

1. Go to **Proxy -> HTTP history**.
2. Browse Juice Shop normally for 30 seconds - click around products, add things to a cart.
3. Watch the history table populate.

Click any row to see the **full request/response pair**. Try filtering - for example, type `login` in the filter bar to find your earlier login attempt.

*(Insert screenshot of HTTP history populated)*

---

## Part 6 - Replay and tamper with Repeater

**Repeater** lets you take a single request and resend it as many times as you want, tweaking parameters between sends. This is the workhorse tool for manual web testing.

1. In **HTTP history**, find your `POST /rest/user/login` request.
2. Right-click it -> **Send to Repeater**.
3. Click the **Repeater** tab at the top.

You now see the request on the left, an empty response panel on the right.

Try this classic SQL-injection-style payload - change the JSON body to:
```json
{"email":"' OR 1=1--","password":"anything"}
```
Click **Send**.

Look at the response. If you see something like `HTTP/1.1 200 OK` with a JSON body containing `authentication` and a token, **you just logged in as admin without knowing the password**. Juice Shop's login is vulnerable to a simple SQL injection in the email field.

Try another payload to see how the response changes:
```json
{"email":"admin@juice-sh.op","password":"anything"}
```
This one fails (no SQLi this time) - compare the responses. That comparison-by-eye is the core skill Repeater builds.

*(Insert screenshot of successful SQLi response in Repeater)*

---

## Part 7 - Decoder: encode and decode quickly

Web apps constantly use Base64, URL-encoding, hex, and hashes. Decoder is a Swiss army knife for that.

1. Go to the **Decoder** tab.
2. Paste this Base64 string into the input area:
```
YWRtaW5AanVpY2Utc2gub3A6YWRtaW4xMjM=
```
3. On the right, click **Decode as... -> Base64**.

You should see the decoded value (a fake `email:password` pair). Now try the reverse:
- Type your name in a fresh Decoder pane.
- Click **Encode as... -> Base64**, then **Encode as... -> URL**.

This is exactly what you'll do dozens of times in real testing - credentials, JWT payloads, and hidden parameters all live in encoded form.

*(Insert screenshot of Decoder with Base64 decode)*

---

## Part 8 - Comparer: diff two responses

When two responses *almost* match, Comparer shows you exactly what changed.

1. Go back to **Repeater**. Send two different login attempts (e.g. one valid email, one invalid).
2. Right-click the first response -> **Send to Comparer (response)**.
3. Right-click the second response -> **Send to Comparer (response)**.
4. Click the **Comparer** tab -> select both items -> click **Words** (bottom right).

You'll get a side-by-side colored diff. Useful for spotting things like a single header changing on a successful auth, or a different error message hinting at user enumeration.

*(Insert screenshot of Comparer diff view)*

---

## Part 9 - Intruder (limited in Community Edition)

**Intruder** automates request tampering - useful for password spraying, fuzzing parameters, etc.

> 🔴 **Heads up:** In Burp Suite **Community**, Intruder runs at a heavily throttled rate (intentionally slowed by PortSwigger to push you to Pro). It still works for learning purposes - it'll just be slow.

1. From **HTTP history**, find a `POST /rest/user/login` request.
2. Right-click -> **Send to Intruder**.
3. Open the **Intruder** tab -> **Positions** sub-tab.
4. Burp auto-marks "insertion points" with `§` symbols. Click **Clear §** to remove them.
5. Highlight just the password value in the body - for example highlight `anything` in `"password":"anything"` - then click **Add §**. Now only the password is a payload position.
6. Switch to the **Payloads** sub-tab.
7. Under **Payload settings**, paste a few candidate passwords, one per line:
```
admin
admin123
password
123456
letmein
```
8. Click **Start attack**.

A new window opens, firing one request per password. Sort the results table by **Length** - successful logins typically have a different response length than failures. That's how you spot a hit in a sea of attempts.

*(Insert screenshot of Intruder results sorted by length)*

---

## Part 10 - Cleanup

Stop and remove the Juice Shop container:
```bash
sudo docker stop juice-shop
sudo docker rm juice-shop
```

Close Burp Suite. Don't save the project (Community Edition can't anyway - saving projects is a Pro-only feature).

---

## What you just learned

| Tool | What it's for |
|---|---|
| **Proxy / Intercept** | Pause and modify requests in flight |
| **HTTP history** | See every request that passed through, after the fact |
| **Repeater** | Manually re-send and tweak a single request - core manual testing tool |
| **Decoder** | Encode/decode Base64, URL, hex, hashes |
| **Comparer** | Diff two requests or responses |
| **Intruder** | Automate request tampering (throttled in Community) |

Things **not** in Community Edition that you'd use in real engagements:
- The vulnerability **Scanner** (Pro only)
- Full-speed **Intruder**
- **Project saving** (every Community session is temporary)
- **Collaborator** (the OAST server for blind vulnerabilities) - only available in Pro

For deeper structured practice, the free **PortSwigger Web Security Academy** (<https://portswigger.net/web-security>) has hundreds of labs designed specifically for Burp Community.










---

# Finished?

[Back to Compromised Web Server's Main Page](/Decks/CORE_v3.1/IC/Compromised_Web_Server.md)

[Back to Credential Stuffing's Main Page](/Decks/CORE_v3.1/IC/Credential_Stuffing.md)

---

> Created by Turcu-Stiolica Alexandru
