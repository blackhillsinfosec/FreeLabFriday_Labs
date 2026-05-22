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

Once you have verified that the site loads, **you can close this browser**.

---

## Part 3 - Configure Firefox & FoxyProxy

There are two ways to intercept the trafic from *localhost* : **Chromium** or  **Firefox with FoxyProxy**. Chromium is the *built in browser for BurpSuite*, normally we'd use it for convenience, but since the actual interaction with **Burp** is the 
exact same, we'll use **FoxyProxy** to intercept the packets. 

### Step 1: Activate FoxyProxy
1. In Firefox, click the **FoxyProxy icon** (the fox head) in the top-right corner of Firefox.
2. Select the **burp** profile. **All traffic is now routed through Burp Suite.**

<img width="393" height="427" alt="image" src="https://github.com/user-attachments/assets/934b91d7-98a2-45a5-8e20-0de54bba0eeb" />

### Step 2: Prepare Burp Suite
1. Go back to **Burp Suite**.
2. Click the **Proxy** tab, then ensure **Intercept is off** (the button should be grey/disabled for now so it doesn't freeze your background traffic).
3. Switch to the **HTTP history** tab next to it. This is your traffic log.

<img width="1737" height="432" alt="image" src="https://github.com/user-attachments/assets/7f7a3437-9561-4573-97e3-00a7b33dcf91" />

4. Back in FireFox, navigate to:

```
http://localhost:3000
```

You should see Juice Shop. From now on, **always use this browser** for the lab - it's the one Burp can see

---

## Part 4 - Intercept a request with Proxy

This is the canonical Burp move: pause a request mid-flight, change it, then let it through.

1. In Firefox on the **Burp** profile, on the Juice Shop site, click anywhere - for example, click the **Account** menu, then **Login**.

<img width="423" height="292" alt="image" src="https://github.com/user-attachments/assets/e2679bff-5b1f-4650-9d03-2d9c4fe0c673" />

2. Type any email and password (e.g. `test@test.com` / `wrongpass`) in the input field. **Do not click LOGIN yet**.
3. In Burp, go to **Proxy -> Intercept**.
4. Click **Intercept is off** so it toggles to **Intercept is on**.
5. Go back to Firefox and click **Log In**. **It should be fairly visible that the site appears to lag a bit before responding. It is just Burp Intercepting the traffic**
6. Check *BurpSuite*, there should be a *POST* packet visible that was intercepted.

<img width="1734" height="960" alt="image" src="https://github.com/user-attachments/assets/9500677e-12e4-4363-970d-f6737b4bd9ab" />

<img width="1728" height="407" alt="image" src="https://github.com/user-attachments/assets/04aabda7-57d5-4463-886e-586ed3f9f942" />

8. Click on the request and scroll down to see details. The **HTTP Request** should look like this : 

```
POST /rest/user/login HTTP/1.1
Host: localhost:3000
...
{"email":"test@test.com","password":"wrongpass"}
```
<img width="916" height="455" alt="image" src="https://github.com/user-attachments/assets/456f1b59-9905-4b35-8719-caca1ea72dce" />

Now **modify it before forwarding**. Change the password to something else, e.g.:
```
{"email":"test@test.com","password":"hacked"}
```
<img width="767" height="333" alt="image" src="https://github.com/user-attachments/assets/bf3314da-ef98-4e32-bfca-1db9a758088d" />

Click **Forward**. The (modified) request hits the server. The server still rejects it (wrong creds), but you just demonstrated full request control.

<img width="955" height="847" alt="image" src="https://github.com/user-attachments/assets/9b543ecf-59d5-4a68-a83c-bca85bcc3e5f" />

Toggle **Intercept is off** when you're done so the browser stops hanging on every click.

---

## Part 5 - Browse HTTP history

Even when intercept is **off**, Burp logs everything that passed through.

1. Go to **Proxy -> HTTP history**.
2. Browse Juice Shop normally for 30 seconds - click around products, go to other pages on the site, read reviews, etc.
3. Watch the history table populate.

Click any row to see the **full request/response pair**. You can see exactly what you modified and where : 

<img width="1734" height="808" alt="image" src="https://github.com/user-attachments/assets/87c8683d-7738-4ad7-a3ad-aa85a6699798" />

>[!NOTE]
>Try filtering - for example, type `login` in the filter bar to find your earlier login attempt without scrolling to see what you've modified.
>Click on **Filter Settings** and input **Login** in the **Filter by search term** field.

<img width="1723" height="880" alt="image" src="https://github.com/user-attachments/assets/db5edd1f-9a89-4133-9a7f-641959431543" />

---

## Part 6 - Replay and tamper with Repeater

**Repeater** lets you take a single request and resend it as many times as you want, tweaking parameters between sends. This is the workhorse tool for manual web testing.

1. In **HTTP history**, find your `POST /rest/user/login` request.
2. Right-click it -> **Send to Repeater**.

<img width="985" height="708" alt="image" src="https://github.com/user-attachments/assets/f0bc381f-6222-4fcb-bfbc-e5d8566af9ab" />

4. Click the **Repeater** tab at the top.

You now see the request on the left, an empty response panel on the right.

Try this classic SQL-injection-style payload - change the JSON body to:

```json
{
  "email": "' OR 1=1--",
  "password": "anything"
}
```

**Click Send**.

Look at the response. If you see something like `HTTP/1.1 200 OK` with a JSON body containing `authentication` and a token, **you just logged in as admin without knowing the password**. Juice Shop's login is vulnerable to a simple SQL injection in the email field.

<img width="1367" height="848" alt="image" src="https://github.com/user-attachments/assets/3c92500c-3b45-4add-adf8-dea00e8a092c" />

Try another payload to see how the response changes:
```json
{
  "email": "admin@juice-sh.op",
  "password": "anything"
}
```
This one fails (no SQLi this time) - compare the responses. That comparison-by-eye is the core skill Repeater builds.

<img width="1186" height="451" alt="image" src="https://github.com/user-attachments/assets/0dca5923-ed30-477a-a259-ba506404560f" />

---

## Part 7 - Decoder: encode and decode quickly

Web apps constantly use Base64, URL-encoding, hex, and hashes. Decoder is a Swiss army knife for that.

1. Go to the **Decoder** tab.
2. Paste this Base64 string into the input area:
```
YWRtaW5AanVpY2Utc2gub3A6YWRtaW4xMjM=
```
3. On the right, click **Decode as... -> Base64**.

<img width="1732" height="431" alt="image" src="https://github.com/user-attachments/assets/f18b9b55-4315-431e-a10c-0d47d2a5a1e4" />

You should see the decoded value (a fake `email:password` pair). Now try the reverse:
- Type your name in a fresh Decoder pane.
- Click **Encode as... -> Base64**, then **Encode as... -> URL**.

This is exactly what you'll do dozens of times in real testing - credentials, JWT payloads, and hidden parameters all live in encoded form.

<img width="1728" height="374" alt="image" src="https://github.com/user-attachments/assets/b8af873d-ffae-4747-a270-f7ba7ea0c2d3" />

---

## Part 8 - Comparer: diff two responses

When two responses *almost* match, Comparer shows you exactly what changed.

1. Go back to **Repeater**. Send two different login attempts (e.g. one valid email, one invalid). Right-click each of them -> **Send to Comparer (response)**.

<img width="1352" height="786" alt="image" src="https://github.com/user-attachments/assets/6a07bbe9-2d08-4aed-a456-ff34c389baf6" />
 
<img width="1424" height="820" alt="image" src="https://github.com/user-attachments/assets/b3fe9be3-a73d-4821-b45e-05848eb5e958" />

2. Click the **Comparer** tab -> select both items -> click **Words** (bottom right).

You'll get a side-by-side colored diff. Useful for spotting things like a single header changing on a successful auth, or a different error message hinting at user enumeration.

<img width="1733" height="960" alt="image" src="https://github.com/user-attachments/assets/b375dfc5-fdd8-41da-af9b-bf56b0cddd3a" />

---

## Part 9 - Intruder (limited in Community Edition)

**Intruder** automates request tampering - useful for password spraying, fuzzing parameters, etc.

> 🔴 **Heads up:** In Burp Suite **Community**, Intruder runs at a heavily throttled rate (intentionally slowed by PortSwigger to push you to Pro). It still works for learning purposes - it'll just be slow.

1. From **HTTP history**, find the `POST /rest/user/login` request.
2. Right-click -> **Send to Intruder**.
3. Open the **Intruder** tab -> **Positions** sub-tab.
4. Burp auto-marks "insertion points" with `§` symbols. Click **Clear §** to remove them.
5. Highlight just the password value in the body - for example highlight `anything` in `"password":"anything"` - then click **Add §**. Now only the password is a payload position.

<img width="1221" height="738" alt="image" src="https://github.com/user-attachments/assets/4eed69e0-dea6-4e5b-8d3f-8cee554aed99" />

6. Switch to the **Payloads** sub-tab.
7. Under **Payload configuration**, paste a few candidate passwords, one per line:
```
admin
admin123
password
123456
letmein
```
8. Click **Start attack**.

<img width="1695" height="710" alt="image" src="https://github.com/user-attachments/assets/e2936e61-2deb-422f-ae4c-d03615b367e7" />

A new window opens, firing one request per password. Successful logins typically have a different response length than failures. That's how you spot a hit in a sea of attempts.

<img width="1635" height="462" alt="image" src="https://github.com/user-attachments/assets/92e2c24e-2159-4e58-ac4b-59fd287e4d65" />

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
