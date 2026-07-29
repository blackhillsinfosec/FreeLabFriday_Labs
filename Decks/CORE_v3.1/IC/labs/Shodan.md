![image](/FilesForLabs/images/blueantisyphon.png)

# Shodan

**Goal:** Learn what Shodan can do using the **web interface**

---

## In this lab you will
- Understand what Shodan is and how it works
- Use the Shodan **web UI** to search the internet
- Read service banners and exposed ports
- Use basic filters (port, country, product)
- Inspect a host in detail
- Understand why exposed services are risky

---

## What is Shodan?
Shodan is a **search engine for internet-connected devices**.

Unlike Google (which indexes web pages), **Shodan** indexes:
- Open **ports**
- **Services** (SSH, FTP, HTTP, RDP, etc)
- Software **banners**
- Sometimes **known vulnerabilities** (**CVEs**)

Everything you see is collected by **Shodan scanners**, not by you


## Create a Shodan account
Create an account on Shodan [HERE](https://account.shodan.io/register) and log in with it

<img width="734" height="540" alt="image" src="https://github.com/user-attachments/assets/275aef2c-df81-4661-a81b-8faa3808df44" />



## First search: exposed web servers
At the top search bar at [this link](https://www.shodan.io/), enter:

```
apache
```

Press **Enter** or the **magnifying glass**

<img width="622" height="66" alt="image" src="https://github.com/user-attachments/assets/1b8ec8ed-f33f-4c3d-9d39-3dfb8e62a340" />


### What you should see
- A list of IP addresses
- Open ports (usually 80 or 443)
- Organization / ISP
- Country
- Short service banners

<img width="1920" height="1029" alt="image" src="https://github.com/user-attachments/assets/8836a417-a3e9-4820-9e5c-0cd1e2cb2965" />

- There are a total of `14,737,596` probable **apache** servers at the time of search, that is a lot!

Click on **any result**

---

## Reading a host page
When you click an IP address, you’ll see:

- **IP address**
- **Open ports**
- **Detected services**
- **Banners**
- Sometimes:
  - SSL certificate info
  - Software versions
  - Tags

<img width="284" height="153" alt="image" src="https://github.com/user-attachments/assets/9aa94188-7578-455d-ad06-d54a978ceb7f" />

<img width="960" height="305" alt="image" src="https://github.com/user-attachments/assets/baedf5ec-ca35-4481-bfa4-698f8eda1446" />


### What an attacker looks for
- What ports are open?
- What service is running on each port?
- Is version information exposed?

---

## Search using ports
In the search bar, try:

```
port:22
```

This shows systems exposing **SSH**

Now try:

```
port:3389
```

This shows systems exposing **RDP** (common attack target)

> As a **defender**, ask yourself: should these services be exposed to the entire internet?

---

## Filter by country
Search for:

```
nginx country:US
```

Replace `US` with your own country code if you want

Things to observe:
- How many results appear
- Who owns these systems
- What ports are exposed

---

## Search by product or service
Try these searches:

```
product:OpenSSH
```

```
product:MongoDB
```

```
product:MySQL
```

Click into a few results

### Notice
- Some services expose **exact versions**
- Some have **no authentication visible**
- Some are cloud-hosted

---

## Look for login pages
Search:

```
http.title:login
```

Open a few results **without interacting**

Look at:
- Page titles
- Server headers
- Technologies listed

> Seeing a login page does NOT mean it’s vulnerable - it means it’s **visible**

---

## Vulnerabilities
On some host pages you’ll see:
- **Vulnerabilities**
- **CVE identifiers**

Click a CVE number

### Understand:
- Shodan did NOT exploit the host
- It mapped known vulnerable versions
- This is correlation, not confirmation

---

## Defensive mindset
For every exposed service you see, ask:
- Does this need to be public?
- Could this be behind a VPN?
- Could this be restricted by IP?
- Is version info necessary?

Shodan is not the danger - **misconfiguration is**








---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/External_Service_Exploitation.md)

---

> Created by Turcu-Stiolica Alexandru
