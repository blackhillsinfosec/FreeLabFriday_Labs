![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Inveigh

# Windows VM

### In this lab we will
- Understand why LLMNR and NBT-NS are dangerous on Windows networks
- Run Inveigh on a Windows machine
- Capture **NTLMv2** hash via **HTTP NTLM poisoning**
- Analyze what was captured and understand the defender's perspective

## Background

When a Windows machine tries to resolve a hostname and **DNS fails**, it falls back to two legacy protocols:

- **LLMNR** (Link-Local Multicast Name Resolution) - broadcasts a query to the entire local network segment asking "who is \<hostname\>?"
- **NBT-NS** (NetBIOS Name Service) - similar broadcast-based name resolution

The problem: **any machine on the network can answer**, including an attacker's.

**Inveigh** listens for these broadcasts, responds claiming to be the requested host, and when the victim machine tries to authenticate, it captures the **NTLMv2 hash**. That hash can then be cracked offline.

This attack is also known as **Responder-style poisoning**, except Inveigh runs natively on Windows with PowerShell - no Linux required.


---

## Let's start

Open **PowerShell as Administrator**:

<img width="81" height="103" alt="image" src="https://github.com/user-attachments/assets/255e287b-c7c6-4290-9d90-760e29bb985d" />


---

### Part 1 - Bypass the execution policy and grab your IP

PowerShell blocks unsigned scripts by default. Bypass it for this session only:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

This does **not** permanently change your system - it only applies to the current PowerShell window

Inveigh captures hashes over HTTP on port 80. Open it so the victim machine can reach it:

```powershell
New-NetFirewallRule -DisplayName "Inveigh HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
```

```powershell
ipconfig
```

Then save your ip like this:

<img width="610" height="245" alt="image" src="https://github.com/user-attachments/assets/907b5265-9274-48f8-83c4-ae20ce3579b9" />

>[!IMPORTANT]
>
>YOUR IP WILL BE DIFFERENT

---

### Part 2 - Start Inveigh

```powershell
Invoke-Inveigh -LLMNR Y -NBNS Y -ConsoleOutput Y -FileOutput Y -IP <IP Here>
```

<img width="1047" height="522" alt="Screenshot 2026-05-19 203201" src="https://github.com/user-attachments/assets/192ce2b6-673e-4c66-adea-fd71291925d1" />



What each flag does:

| Flag | What it does |
|---|---|
| `-LLMNR Y` | Listen for and respond to LLMNR broadcasts |
| `-NBNS Y` | Listen for and respond to NBT-NS broadcasts |
| `-ConsoleOutput Y` | Print captured data live to the console |
| `-FileOutput Y` | Save everything to files in Current Dir |

Inveigh will print startup messages and begin listening. Leave this window open.

---

### Part 3 - Trigger an LLMNR broadcast

Open a **Ubuntu Shell** and run:

<img width="82" height="94" alt="image" src="https://github.com/user-attachments/assets/2af1d76b-d7e8-4574-99cd-e44b925af73e" />


```bash
curl -v --ntlm -u testuser:password123 http://<IP here>/
```

<img width="1089" height="557" alt="Screenshot 2026-05-19 205712" src="https://github.com/user-attachments/assets/14aeea98-ad70-4c0e-8958-f47536ef8bff" />



What happens behind the scenes:
1. curl connects to Inveigh's fake HTTP server
2. Inveigh sends back an NTLM challenge
3. curl responds with an NTLM authentication attempt
4. Inveigh captures the NTLMv2 hash before Windows can reject the login

The curl command will fail with an auth error - that is expected. The hash is captured regardless.

---

### Part 4 - Observe the captured hash

Switch back to the **first PowerShell window** where Inveigh is running. You should see output like:

<img width="1087" height="237" alt="image" src="https://github.com/user-attachments/assets/f3e07534-1102-4388-b53b-1ef61b0af726" />


That long string is the **NTLMv2 hash**. It contains:
- The username
- The NTLM challenge sent by Inveigh
- The encrypted response from the victim - derived from the real password hash

The hash is in **Hashcat mode 5600** format, ready to be cracked offline



---

### Part 5 - Stop Inveigh

```powershell
Stop-Inveigh
```

Inveigh will stop listening

---

## How to defend against this

LLMNR and NBT-NS are **enabled by default** on every Windows machine. To block this attack:

**Disable LLMNR via Group Policy:**
```
Computer Configuration -> Administrative Templates -> Network -> DNS Client
-> Turn off multicast name resolution -> Set to Enabled
```

**Disable NBT-NS per adapter:**
```
Network Adapter -> IPv4 Properties -> Advanced -> WINS tab
-> Select "Disable NetBIOS over TCP/IP"
```

**Enable SMB Signing** on all machines - prevents relay attacks even if hashes are captured.

**Use strong, unique passwords** - a complex password makes the captured NTLMv2 hash computationally infeasible to crack with a wordlist.

**Enable Extended Protection for Authentication (EPA)** on HTTP services to bind NTLM tokens to the TLS channel, preventing capture and relay.


---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Broadcast-Multicast_Protocol_Poisoning.md)

---

> Created by Turcu-Stiolica Alexandru
