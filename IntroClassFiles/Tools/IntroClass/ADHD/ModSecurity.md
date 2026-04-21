![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# ModSecurity 

# Ubuntu VM

**Goal:** With **ModSecurity**,perform simple detections and blocks (XSS, SQLi, command injection), view logs, and write a simple custom rule


>[!NOTE]
>Apache is running on port 8083 on the machine

---

## Lab overview

- Enable ModSecurity (Detection/Prevention mode)
- Test attacks with `curl` (XSS, SQLi, command injection)
- Inspect audit logs and Apache logs
- Create a simple custom rule to block a pattern
- Toggle rule states and observe behavior

---

# Start

- Start and enable Apache:
```bash
sudo systemctl enable --now apache2
sudo systemctl status apache2 --no-pager
```

- Check Apache is serving:
```bash
curl -I http://localhost:8083
```

<img width="555" height="226" alt="2026-03-18_13-05" src="https://github.com/user-attachments/assets/dedfa3da-3e1f-409b-be46-5b4185984ab5" />


>[!IMPORTANT]
>ModSecurity is already installed for this lab

- Confirm module installed:
```bash
sudo apachectl -M | grep security
```

<img width="603" height="74" alt="2026-03-18_13-22" src="https://github.com/user-attachments/assets/2273b948-722d-4747-a2f7-17794e676b70" />



- The default configuration file lives at: `/etc/modsecurity/modsecurity.conf-recommended`

- We are using the basic config: `/etc/modsecurity/modsecurity.conf`

- Ensure `SecRuleEngine` is set to `DetectionOnly` initially:
```bash
sudo cat /etc/modsecurity/modsecurity.conf
```

- Important lines to check:
- `SecRuleEngine DetectionOnly` - detects but does not block
- `SecAuditLog` - path to the audit log (usually `/var/log/apache2/modsec_audit.log`)

<img width="279" height="31" alt="2026-03-18_13-25" src="https://github.com/user-attachments/assets/7eaaf190-a8ad-4df2-924f-b21287db6c93" />


<img width="462" height="28" alt="2026-03-18_13-24" src="https://github.com/user-attachments/assets/4379616a-eaf4-4038-9d74-a7ba30297a10" />

---

## Install OWASP Core Rule Set (v3.3.5) - Copy-Paste is your friend
```bash
cd /tmp
sudo rm -rf /usr/share/modsecurity-crs
sudo git clone --branch v3.3.5 --depth 1 https://github.com/coreruleset/coreruleset.git
sudo mkdir -p /usr/share/modsecurity-crs
sudo cp -r coreruleset/* /usr/share/modsecurity-crs/
sudo cp /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
```

---

## Enable CRS (Single Include Only)
```bash
sudo tee /etc/apache2/mods-available/security2.conf >/dev/null <<'EOF'
<IfModule security2_module>
    IncludeOptional /etc/modsecurity/modsecurity.conf
    IncludeOptional /usr/share/modsecurity-crs/crs-setup.conf
    IncludeOptional /usr/share/modsecurity-crs/rules/*.conf
    IncludeOptional /etc/modsecurity/custom-rules/*.conf
</IfModule>
EOF

sudo ln -sf /etc/apache2/mods-available/security2.conf /etc/apache2/mods-enabled/security2.conf
sudo apachectl configtest
sudo systemctl restart apache2
```

Test:
```bash
curl -I http://localhost:8083
```

<img width="602" height="223" alt="2026-03-18_13-28" src="https://github.com/user-attachments/assets/364a8926-2a08-444c-81e9-202c9fdc1a72" />


---

## SConfirm ModSecurity is running
- Check Apache error log for ModSecurity startup messages:
```bash
sudo tail -n 200 /var/log/apache2/error.log
```

<img width="1754" height="224" alt="2026-03-18_13-29" src="https://github.com/user-attachments/assets/1bc6da59-91f6-48eb-a4a3-60a7e0abb558" />



Check the audit log file exists (may be empty initially):
```bash
sudo ls -l /var/log/apache2/modsec_audit.log || ls -l /var/log/modsec_audit.log
```


<img width="1070" height="50" alt="2026-03-18_13-30" src="https://github.com/user-attachments/assets/9efcf029-2fc1-4e9e-a338-0990abadc394" />


---

## Simple detection tests (DetectionOnly mode)
- With `SecRuleEngine DetectionOnly` ModSecurity will log but not block.

### XSS test (reflected)
```bash
curl -v "http://localhost:8083/?q=<script>alert(1)</script>" -s -o /dev/null
```

<img width="1037" height="508" alt="2026-03-18_13-33" src="https://github.com/user-attachments/assets/40b8e6e6-4153-445f-ae5a-3e206e336d0a" />


- Now tail the **audit log** (open another terminal):
```bash
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```

<img width="1906" height="323" alt="2026-03-18_13-35" src="https://github.com/user-attachments/assets/0ac5400b-c83a-476f-b65c-721eede6f7ef" />


- **BOOM!** What is cool about **ModSecurity** is that not only does it detect attacks really well, but it also logs them extensively, as you can see, giving details about everything


### SQL Injection test
```bash
curl -v "http://localhost:8083/?id=1%20OR%201=1" -s -o /dev/null
```

```bash
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```

<img width="1905" height="509" alt="2026-03-18_13-39" src="https://github.com/user-attachments/assets/123bada1-631d-4152-9ba0-627c85dc62c6" />


### Command injection-like input
```bash
curl -v "http://localhost:8083/?cmd=|ls" -s -o /dev/null
```
```bash
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```

<img width="1908" height="600" alt="2026-03-18_13-40" src="https://github.com/user-attachments/assets/b2a81860-cd09-4ca8-9f75-9c98d59f1e8a" />



- Each **curl** should create **ModSecurity** audit events. Study the audit log format: it is split into sections (`--A--`, `--B--`) with **request**, **response**, and **matched rule details**

---

## Switch to prevention mode (blocking)
- Now turn ModSecurity into blocking mode.

**Important:** On some rules and setups enabling blocking will return `403` for many requests. This is expected - we want to see blocking.

Edit the config:
```bash
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf
```
```bash
sudo systemctl restart apache2
```

- Test the same payloads:

```bash
curl -v "http://localhost:8083/?q=<script>alert(1)</script>" -s -o /dev/null -w "%{http_code}\n"
# Expected: 403 (or another non-200)
```


<img width="1218" height="468" alt="2026-03-18_13-41" src="https://github.com/user-attachments/assets/de19f4a5-1acc-4739-9db7-a2ca9b22396c" />


```bash
curl -v "http://localhost:8083/?id=1%20OR%201=1" -s -o /dev/null -w "%{http_code}\n"
```

Review the audit log and Apache error log for blocked events:
```bash
sudo tail -n 120 /var/log/apache2/modsec_audit.log
```

```bash
sudo tail -n 200 /var/log/apache2/error.log
```

<img width="1906" height="94" alt="2026-03-18_13-42" src="https://github.com/user-attachments/assets/3b507553-cd47-4a5f-a92a-f9b55a12222f" />


---

## Useful file locations
- Main config: `/etc/modsecurity/modsecurity.conf`
- Apache include: `/etc/apache2/mods-enabled/security2.conf`
- CRS rules: `/usr/share/modsecurity-crs/rules/`
- CRS setup: `/usr/share/modsecurity-crs/crs-setup.conf`
- Audit log: `/var/log/apache2/modsec_audit.log` (or `/var/log/modsec_audit.log`)
- Apache error log: `/var/log/apache2/error.log`


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Haraka.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Glastopf.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
