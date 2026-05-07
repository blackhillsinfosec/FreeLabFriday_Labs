![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF – Pick the Exploit Path

During recon, you fingerprint a public-facing VPN appliance

Nmap + banner info:

```
443/tcp open  https
Service: SSL VPN Portal
Vendor hint: "Fortinet"
Observed version string: "FortiOS 7.0.x" (from page source)
```

You search your notes and find two items:

1) A known vulnerability affects **some** FortiOS SSL-VPN builds (RCE/unauth access style bugs exist historically)
2) Your rules of engagement allow exploitation **only after** you confirm the exact affected build/version

---

## Goal

Choose the best **responsible** red-team step that still moves you toward an initial foothold quickly

---

## Question

What should you do next?

---

## Flags (Choose One)

- **A)** Fire Metasploit at it immediately and hope it sticks  
- **B)** Brute force VPN credentials from the internet until you get lucky  
- **C)** Confirm the **exact build** and check exploitability before attempting any exploit  
- **D)** Ignore the VPN and start scanning random hosts outside scope  

---

Correct Flag: **C**

---

# Finished?

[Next Question](ESE_hard.md)

[Back to Card's Main Page](/Cards/IC/External_Service_Exploitation.md)
