![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# OpenCanary

#### For The Ubuntu VM

<hr>

## Lab Objective
Deploy a simple **OpenCanary** honeypot, trigger a few attacks (port scan, **SSH/SMB probe**, simple **HTTP request**), and observe **alerts**

<hr>

## Step 1: Setting Up OpenCanary

Install mysql client for the use in the lab:
```bash
sudo apt install mysql-client-core-8.0
```

Go to its directory:
```bash
cd ~/ADCD/openCanary
```

Activate the **Virtual Environment**:
```bash
source env/bin/activate
```

<br>

### Create & Edit The Config
Still inside your virtualenv:

Create the default config (this prints the location)
```bash
opencanaryd --copyconfig
```

![image](/FilesForLabs/images/opencanarydefaultconfig.png)

Make sure it is there

```bash
sudo ls -l /etc/opencanaryd/opencanary.conf
```

![image](/FilesForLabs/images/opencanary_checkitsthere.png)

Now open the config and make small edits. Example uses `nano` (or `vi`):

```bash
sudo nano /etc/opencanaryd/opencanary.conf
```

Inside the JSON config make these **minimal** changes to enable a few services and a log file:

1. Locate the `"device.node_id"` and set a friendly name like `"opencanary-lab"`

```
"device.node_id": "opencanary-lab"
```

2. In the `"modules"` (or top-level service entries) enable the following:

```json
"ftp": {"enabled": true},
"http": {"enabled": true},
"http": {"port": 8082},
"mysql": {"enabled": true},
"mysql": {"log_connection_made": true},
"portscan": {"enabled": true},
"ssh": {"enabled": true},
"ssh": {"port": 222},
"telnet": {"enabled": true}
```

![image](/FilesForLabs/images/opencanary_modulesenable.png)
![image](/FilesForLabs/images/opencanary_modules2.png)
![image](/FilesForLabs/images/opencanary_modules3.png)

Save and exit with `Ctrl + x` and `y` and `Enter`

<hr>

## Step 2: Start OpenCanary

Run it.

>[!NOTE]
> Make sure you are in **~/ADCD/openCanary** with **venv** activated

```bash
opencanaryd --start
```

To stop:
```bash
opencanaryd --stop
```

![image](/FilesForLabs/images/opencanary_start.png)

If you configured file logging as above, check the log:

```bash
sudo tail -n 50 /var/tmp/opencanary.log
```

![image](/FilesForLabs/images/opencanary_checklog.png)

<hr>

## Step 3: Simple Attacker 
Perform these actions from a second terminal (or another device on the same network).<br>
Replace `<CANARY_IP>` with the IP address of the VM.

1. Port scan (nmap)
```bash
sudo nmap -sV -sC -Pn -p 21,23,222,3306,8082 localhost
```

![image](/FilesForLabs/images/opencanary_portscan.png)

**OpenCanary's** `portscan` module should flag the scan, so let's check!

```bash
sudo tail -n 50 /var/tmp/opencanary.log
```

![image](/FilesForLabs/images/opencanary_flagscan.png)

BOOM!

2. SSH probe (attempt to connect)
```bash
ssh fakeuser@localhost -p 222
```
This triggers the `ssh` canary

3. HTTP request
```bash
curl http://127.0.0.1:8082/index.html
```
This triggers the `http` canary logs

4. MySQL login attempt
```bash
mysql -h 127.0.0.1 -u root -p
```

5. FTP login attempt
```bash
ftp 127.0.0.1
```

6. TELNET login attempt
```bash
telnet 127.0.0.1
```

After each action, check the canary log or journal on the honeypot host to see alerts:

```bash
sudo tail -n 50 /var/tmp/opencanary.log
```

![image](/FilesForLabs/images/opencanary_checkhoneypotjournal.png)