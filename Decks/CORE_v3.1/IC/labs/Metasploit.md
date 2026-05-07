![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Metasploit

# Ubuntu VM

## In this lab we will
- Install Metasploit Framework (simple, standard install)
- Learn the Metasploit console basics (`search`, `use`, `info`, options)
- Create a **safe local target** service (an FTP server on localhost)
- Use Metasploit **scanners** to discover services and identify versions
- Use a **controlled credential check** against the local FTP service
- Learn to save results into Metasploit’s database (`hosts`, `services`, `workspace`)

---

### Start a local FTP server (with a test user)
We will use:
- Username: `student`
- Password: `Password123!`

Run this **in a terminal window** and keep it running:
```bash
python3 -m pyftpdlib -p 2121 -w -d ~/BnB/metasploit/ftp-share -u student -P 'Password123!'
```

You should see output that the server is listening on port `2121`

<img width="723" height="87" alt="image" src="https://github.com/user-attachments/assets/33d4af5f-6e40-484a-bc72-6b071e73760f" />

---

## Metasploit Console Basics

>[!NOTE]
>This should be done in another terminal, open a new window!

Start Metasploit:
```bash
msfconsole
```

### Confirm database connection inside msfconsole
Inside `msfconsole`, run:
```text
db_status
```

If it says connected, great. If not, you can still continue (scans will work, but saving results may be limited)

### Helpful navigation commands
Try these inside `msfconsole`:
```text
help
version
show -h
search -h
```

---

## Scan localhost

We’ll treat `127.0.0.1` as our “target”.

### Create a workspace (keeps your lab results separate)
If connected to the DB:
```text
workspace -a msf_beginner_lab
```

```text
workspace
```

<img width="363" height="120" alt="image" src="https://github.com/user-attachments/assets/324e654f-e486-4702-a5bb-b10f224ec560" />


### Port scan with Metasploit
Use a TCP port scanner module:
```text
search portscan tcp
```

<img width="974" height="320" alt="image" src="https://github.com/user-attachments/assets/f4d988a7-5956-4904-99ab-e100b5de37d2" />


Pick this common module:
```text
use auxiliary/scanner/portscan/tcp
```

Show options:
```text
show options
```

<img width="1319" height="373" alt="image" src="https://github.com/user-attachments/assets/21115925-aefb-47e3-a6bc-dd2535df3d3e" />

Set the target and ports:
```text
set RHOSTS 127.0.0.1
```

```text
set PORTS 21,22,80,443,2121
```

```text
run
```

You should see `2121` open

<img width="598" height="167" alt="image" src="https://github.com/user-attachments/assets/ac869c82-5b03-456a-8b8a-a1f18cde7d7a" />


### View discovered hosts/services (database)
If DB is connected:
```text
hosts
```

```text
services
```

<img width="668" height="333" alt="image" src="https://github.com/user-attachments/assets/5ff89440-a1ae-436d-b466-6d3f5f6cd302" />

---

## Identify the FTP service (version scanning)

Metasploit has scanner modules that grab banners and versions

### Use the FTP version scanner
```text
use auxiliary/scanner/ftp/ftp_version
```

```text
show options
```

<img width="1318" height="333" alt="image" src="https://github.com/user-attachments/assets/b701d74e-8fbc-403e-8515-c1eeafe5c8b4" />


Set target and port:
```text
set RHOSTS 127.0.0.1
```

```text
set RPORT 2121
```

```text
run
```

<img width="697" height="165" alt="image" src="https://github.com/user-attachments/assets/a0f06e54-5a88-423a-904b-7bfffba26bd5" />


Check services again:
```text
services -p 2121
```

Notice how the **info** column has updated

---

## Controlled credential check (local FTP login scanner)

This demonstrates Metasploit’s credential modules in a **safe** way: you’re testing a service you started yourself.

### Create a tiny password list
In a **new terminal** (not msfconsole):
```bash
cat > ~/BnB/metasploit/passwords.txt << 'EOF'
123456
password
Password123!
letmein
EOF
```

### Run the FTP login scanner in Metasploit
Back in `msfconsole`:
```text
use auxiliary/scanner/ftp/ftp_login
```

```text
show options
```


<img width="1510" height="615" alt="image" src="https://github.com/user-attachments/assets/653b9400-93ce-48dc-8bd4-cf41f09e6621" />

Set the target and port:
```text
set RHOSTS 127.0.0.1
```

```text
set RPORT 2121
```

Set the username:
```text
set USERNAME student
```

Point Metasploit to the password list:
```text
set PASS_FILE /home/ubuntu/BnB/metasploit/passwords.txt
```

Run it:
```text
run
```

<img width="817" height="142" alt="image" src="https://github.com/user-attachments/assets/d6caac57-ea9d-45f2-8dbe-9ae2d7c8aa87" />

Successful login for `student:Password123!`!!!

### See stored credentials (if DB is connected)
```text
creds
```

<img width="1119" height="150" alt="image" src="https://github.com/user-attachments/assets/ee8742d5-45a9-4a3b-a83d-d02ce0c1325a" />






---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/External_Service_Exploitation.md)

---

> Created by Turcu-Stiolica Alexandru
