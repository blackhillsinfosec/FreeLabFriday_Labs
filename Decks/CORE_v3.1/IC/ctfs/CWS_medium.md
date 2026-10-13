## Post-Exploitation

An attacker exploited a vulnerable web application and obtained a shell as the user `www-data`.

After some enumeration, they discover:

- `sudo` is installed
- A script called `backup.sh` can be run with sudo without a password
- The script calls `/bin/tar` without using a full path
