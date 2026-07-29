![image](/FilesForLabs/images/blueantisyphon.png)

# PEASS-ng

# Ubuntu VM

**Goal:** Learn what **PEASS-ng / LinPEAS** can discover on a Linux host by **creating a few safe “bad configs” in a lab VM**, running LinPEAS, and reviewing the findings.  

https://github.com/peass-ng/PEASS-ng

---

## What you’ll do in this lab

- Generate a report and filter for “interesting” lines
- Create 3 simple lab misconfigurations and see LinPEAS detect them:
  1. **World-readable “app config” with credentials**
  2. **A root cron job that runs a script**
  3. **A cron script that is writable by normal users** (a classic “this is bad” finding)
- Fix the misconfigurations and re-run LinPEAS to confirm improvement



---

## Create 3 simple lab misconfigurations

### Create a world-readable “app config” with fake credentials

```bash
sudo mkdir -p /opt/demoapp
```

```bash
sudo bash -c 'cat > /opt/demoapp/config.ini << "EOF"
[database]
host=127.0.0.1
user=demoapp
password=SuperFakePassword123!
EOF'
```

Make it readable by everyone (bad):

```bash
sudo chmod 644 /opt/demoapp/config.ini
```

```bash
ls -l /opt/demoapp/config.ini
```

Quick check as `ubuntu`:

```bash
cat /opt/demoapp/config.ini
```
<img width="332" height="96" alt="image" src="https://github.com/user-attachments/assets/d4008389-7e10-4562-bd69-27db5b737674" />

---

### Create a cron job that runs as root every minute

Create a script that the cron job will run:

```bash
sudo bash -c 'cat > /usr/local/bin/demo-backup.sh << "EOF"
#!/bin/bash
# Demo script: writes a timestamp to a log file
date >> /var/log/demo-backup.log
EOF'
```

```bash
sudo chmod +x /usr/local/bin/demo-backup.sh
```

Create a **root cron entry**:

```bash
sudo bash -c 'cat > /etc/cron.d/demo-backup << "EOF"
* * * * * root /usr/local/bin/demo-backup.sh
EOF'
```

Wait a minute, then confirm it’s executing:

```bash
sudo tail -n 5 /var/log/demo-backup.log
```
<img width="723" height="50" alt="image" src="https://github.com/user-attachments/assets/e1eb7cad-1222-4cb5-a06f-d261759f6e88" />

---

### Make the root cron script writable by normal users (intentionally bad)

This is the “obvious problem” we want LinPEAS to scream about:

```bash
sudo chmod 777 /usr/local/bin/demo-backup.sh
```

```bash
ls -l /usr/local/bin/demo-backup.sh
```

<img width="746" height="27" alt="image" src="https://github.com/user-attachments/assets/28562af8-e441-47d3-ae55-b5e998c88f80" />


> A root cron job + a writable script is a serious misconfiguration.
---

## Run LinPEAS

```bash
cd ~/BnB/peass-ng
```

```bash
./linpeas.sh | tee linpeas-after.txt
```

>[!NOTE]
>
>Bare in mind it can take up to 10+ minutes

You’ll likely see some normal system findings (that’s expected). Important are the few **very obvious** misconfigs that we added

### Find the “demoapp credentials” finding

```bash
grep -nE "/opt/demoapp/config.ini|demoapp|SuperFakePassword" linpeas-after.txt
```

### Find cron-related findings

```bash
grep -nEi "cron|/etc/cron.d|demo-backup|demo-backup.sh|writable" linpeas-after.txt | head -n 80
```

<img width="1151" height="405" alt="image" src="https://github.com/user-attachments/assets/d0dec09b-a0a2-4084-b140-16a1fa7caea1" />



- We can see with red on a yellow backround the REALLYY **bad stuff** - which is the cron job we just made

### Find “writable root-owned files” findings

```bash
grep -nEi "writable.*root|root.*writable" linpeas-after.txt | head -n 80
```
<img width="1227" height="50" alt="image" src="https://github.com/user-attachments/assets/43f77a7c-33bd-4666-8be5-fa91b84f119e" />

We can see it found something, it's over at the **6089** line, let's see what it found

```bash
sed -n '6089,6130p' linpeas-after.txt
```

<img width="1139" height="499" alt="image" src="https://github.com/user-attachments/assets/78bc1de8-880d-4e8f-b683-9d723424f0d4" />


---

## What LinPEAS is showing you (quick tour)

Open the output file in a text editor:

```bash
nano linpeas-after.txt
```

As you scroll, look for sections like:

- **System information**: kernel, distro, container/VM hints
- **Users & groups**: who exists, who is in sudo/admin groups
- **Sudo checks**: what commands a user can run with sudo, environment variables, etc.
- **Cron jobs & timers**: scheduled tasks (like our `/etc/cron.d/demo-backup`)
- **Interesting/writable files**: world-writable paths, weak permissions
- **Credentials**: files containing `password=`, tokens, SSH keys, config files
- **Network and processes**: services and ports that might matter

---

## Fix the misconfigurations (defender mode)

### Fix the world-readable config file

Restrict it to root only:

```bash
sudo chmod 600 /opt/demoapp/config.ini
```

```bash
sudo chown root:root /opt/demoapp/config.ini
```

```bash
ls -l /opt/demoapp/config.ini
```

### Fix the writable cron script

Make it only writable by root:

```bash
sudo chmod 755 /usr/local/bin/demo-backup.sh
```

```bash
sudo chown root:root /usr/local/bin/demo-backup.sh
```

```bash
ls -l /usr/local/bin/demo-backup.sh
```

### Remove the demo cron job entirely

```bash
sudo rm -f /etc/cron.d/demo-backup
```

---

## Re-run LinPEAS to verify fixes

```bash
cd ~/BnB/peass-ng
```

```bash
./linpeas.sh | tee linpeas-fixed.txt
```

Now re-run the same filters and compare:

```bash
echo "=== After (insecure) ==="
grep -nEi "demoapp|demo-backup|/etc/cron.d/demo-backup|SuperFakePassword|writable" linpeas-after.txt | head -n 80
```

<img width="1376" height="527" alt="image" src="https://github.com/user-attachments/assets/9d0fae28-5c97-48ad-b997-f3726a8fe462" />


```bash
echo "=== Fixed ==="
grep -nEi "demoapp|demo-backup|/etc/cron.d/demo-backup|SuperFakePassword|writable" linpeas-fixed.txt | head -n 80
```

<img width="1374" height="457" alt="image" src="https://github.com/user-attachments/assets/630a0b8f-18d8-4b13-b38a-1fdd8375275f" />



You should see those “obvious” findings disappear or become less severe.

---

## Cleanup

```bash
sudo rm -rf /opt/demoapp
sudo rm -f /usr/local/bin/demo-backup.sh
sudo rm -f /var/log/demo-backup.log
sudo rm -f /etc/cron.d/demo-backup
```

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Local_Privilege_Escalation.md)

---

> Created by Turcu-Stiolica Alexandru
