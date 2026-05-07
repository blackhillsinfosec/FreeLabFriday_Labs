# Wazuh Cloud SIEM & XDR
# Ubuntu & Windows VM
## The objective of this lab is to deploy Wazuh Agents to a cloud-hosted SIEM environment, configure File Integrity Monitoring (FIM), simulate malicious activities across two different OS environments, and perform Blue Team analysis on the generated alerts.

---

### **Documentation and scenario** :
**What is Wazuh?**

 - Wazuh is a free, open-source security platform that unifies XDR (Extended Detection and Response) and SIEM (Security Information and Event Management) capabilities. It protects endpoints and cloud workloads by identifying threats and responding to them in real-time.

**What we will be focusing on:**

 - *File Integrity Monitoring (FIM)*: Wazuh monitors the file system, identifying changes in content, permissions, ownership, and attributes of files that you specify. It is crucial for detecting unauthorized configuration changes or backdoors.

 - *Malware Detection*: Wazuh uses out-of-the-box integration with various threat intelligence sources to detect known malicious files (like malware or ransomware) dropped onto the filesystem.

 - *Cloud Deployment* : Instead of hosting the heavy server components locally, we are using Wazuh Cloud to process and index our logs. The endpoints only run a lightweight agent.

If you want to dive a bit deeper, check the [Wazuh Documentation](https://github.com/wazuh/wazuh).

>[!WHY?]
>In the real world, attackers often attempt to modify critical system configuration files to maintain persistence (e.g., adding a new user to /etc/passwd on Linux) or drop malicious payloads on user endpoints (Windows). Being able to detect both simultaneously in a single dashboard is the primary advantage of a centralized SIEM.

---

### SCENARIO :
 - In this lab, we are simulating a multi-stage incident. The Windows VM represents a corporate workstation, and the Ubuntu VM represents an internal database/web server.

 - We will connect both machines to our Wazuh Cloud instance.

 - *The Attack:* We will simulate an attacker downloading a known malicious payload on the Windows endpoint. Simultaneously, we will simulate an attacker who has gained SSH access to the Ubuntu server and is modifying a highly sensitive configuration file to establish a backdoor.

The Defense: We will switch to the Blue Team perspective, log into the Wazuh Cloud Dashboard, and hunt down these specific Indicators of Compromise (IoCs).

>[!IMPORTANT]
>All actions will be performed from the Windows VM. You will use the Google Chrome browser to view the Wazuh Cloud Dashboard, Windows PowerShell for the Windows attack simulation, and the "Ubuntu Shell" Desktop shortcut (SSH) to interact with the Ubuntu VM. You do not need the Ubuntu GUI for this lab.

## Phase 1 : Setup and Agent Enrollment
First, we need to deploy the Wazuh Agents to our endpoints so they can start forwarding telemetry to the cloud.

Open Google Chrome on your Windows VM, log into your Wazuh Cloud Console, and navigate to Agents -> Deploy New Agent.

Select Windows, put in your Wazuh Manager address, and copy the generated PowerShell command. Open an Administrator PowerShell terminal and paste it to install and start the agent:

``` PowerShell
Invoke-WebRequest -Uri [https://packages.wazuh.com/4.x/windows/wazuh-agent-4.x.msi](https://packages.wazuh.com/4.x/windows/wazuh-agent-4.x.msi) -OutFile ${env.tmp}\wazuh-agent.msi; msiexec.exe /i ${env.tmp}\wazuh-agent.msi /q WAZUH_MANAGER='<YOUR_WAZUH_CLOUD_URL>' WAZUH_REGISTRATION_SERVER='<YOUR_WAZUH_CLOUD_URL>' 
NET START WazuhSvc 
```

 - Now, open your Ubuntu Shell shortcut on the Windows Desktop. Select Debian/Ubuntu in the Wazuh Cloud interface, copy the Linux enrollment command, and paste it into the Ubuntu shell:

```Bash
curl -so wazuh-agent-4.x.deb [https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.x.deb](https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.x.deb) && sudo WAZUH_MANAGER='<YOUR_WAZUH_CLOUD_URL>' dpkg -i ./wazuh-agent-4.x.deb
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

 - Go back to the Wazuh Cloud Dashboard. You should now see both agents marked as Active.

## Phase 2: Configuring File Integrity Monitoring (FIM)
By default, Wazuh monitors certain system directories. We want to explicitly monitor a custom "sensitive" directory on our Ubuntu VM to simulate a targeted data breach or config alteration.

 - In your Ubuntu Shell, let's create a fake sensitive file:

```Bash
sudo mkdir -p /var/www/html/secure_portal
sudo touch /var/www/html/secure_portal/db_config.php
sudo nano /var/www/html/secure_portal/db_config.php
```

 - **Add some dummy text inside** (like db_password=SuperSecret), save, and exit.

 - Now, we tell the Wazuh Agent to watch this specific directory. Open the agent configuration file:

```Bash
sudo nano /var/ossec/etc/ossec.conf
```

 - Scroll down to the <syscheck> section (which handles FIM) and add the following line to monitor our new directory in real-time:

```XML
<directories check_all="yes" realtime="yes">/var/www/html/secure_portal</directories>
```

 - Restart the Wazuh agent to apply the changes:

```Bash
sudo systemctl restart wazuh-agent
```

>[!NOTE]
>FIM takes a few minutes to run its initial baseline scan. It hashes all the files in that directory so it has something to compare against when a change happens.

## Phase 3: Execution (Simulating the Attack)
Now we play the role of the attacker on both machines.

**Attack 1**: Malware Drop on Windows

The attacker manages to execute a script on the Windows endpoint that downloads a malicious payload. We will simulate this using the standard EICAR test file (a harmless file flagged as malware by all security vendors).

 - Open your Windows PowerShell and run:

```PowerShell
Invoke-WebRequest -Uri "[https://secure.eicar.org/eicar.com](https://secure.eicar.org/eicar.com)" -OutFile "$env:USERPROFILE\Desktop\malware_payload.exe"
```

**Attack 2**: Backdoor Configuration on Ubuntu

The attacker (already SSH'd into the system via the Ubuntu Shell) modifies the database configuration file to route traffic to their own server.

```Bash
echo "db_password=HACKED_PASSWORD_123" | sudo tee -a /var/www/html/secure_portal/db_config.php
```

## Phase 4: Blue Team Detection

**The attacks are complete**. Now, switch to your Google Chrome browser on Windows and open the Wazuh Cloud Dashboard.

Hunting the Windows Malware:
Navigate to Modules -> Security Events. Filter by agent: Windows VM.
Look for alerts labeled with Rule: 100201 or mentions of malicious files. You will clearly see an alert showing that a known threat (EICAR) was created on the Desktop.

Hunting the Ubuntu FIM Violation:
Navigate to Modules -> Integrity Monitoring. Filter by agent: Ubuntu VM.
You will see a critical alert showing that /var/www/html/secure_portal/db_config.php was modified.
If you expand the alert, Wazuh will show you the exact timestamp, the user who made the change (root, via sudo), and even the hash differences before and after the attack.

Analysis: As a SOC Analyst, seeing a sudden malware drop on an endpoint correlated with a critical configuration change on an internal server within minutes would immediately trigger a High-Severity Incident Response plan.

Cleanup
Let's clean up the environment so no alerts continue to trigger.

On the Windows VM: Delete the fake malware payload from your Desktop.

```PowerShell
Remove-Item "$env:USERPROFILE\Desktop\malware_payload.exe"
```

On the Ubuntu VM: Delete the fake sensitive directory.

```Bash
sudo rm -rf /var/www/html/secure_portal
```
(Optional) If you want to remove the Wazuh agents completely, you can uninstall them via appwiz.cpl on Windows and sudo apt remove wazuh-agent on Ubuntu.


---

## Conclusion
In this lab, you successfully deployed an enterprise-grade SIEM/XDR architecture using Wazuh Cloud. You learned how to configure File Integrity Monitoring (FIM) to protect sensitive server configurations over an SSH connection, and you simulated a malware infection on a Windows endpoint. Most importantly, you navigated the Wazuh Dashboard to perform threat hunting, proving that centralized logging is essential for detecting multi-vector attacks across different operating systems.


Finished?