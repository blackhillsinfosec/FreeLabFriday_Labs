![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Impacket

# Ubuntu VM

## In this lab we will
- Stand up a local SMB server (Samba) as our "target"
- Use **Impacket** to:
  - List **SMB shares**
  - Browse **directories**
  - Upload and download **files**
  - (Optional) query basic SMB/RPC info

## Lab topology
- Your Linux machine (attacker/workstation)
- A Samba container listening on `127.0.0.1:1445` (**target**)

---

## Setup

### Go the the Lab Directory

```bash
cd ~/BnB/impacket
```


### Activate a virtual environment

```bash
source venv/bin/activate
```

### Verify the install

```bash
python -c "import impacket; print('Impacket version:', getattr(impacket,'__version__','(unknown)'))"
```

Also check that some scripts exist:

```bash
which smbclient.py
```

```bash
which smbserver.py
```

If `which` prints paths, you're good

<img width="489" height="69" alt="which_files" src="https://github.com/user-attachments/assets/698c3551-581b-4092-a9ec-01d3e0ef6890" />


---
## Start a local SMB "target" (Samba in Docker)

We'll run Samba on **127.0.0.1:1445** (host port 1445 -> container port 445), so it won't conflict with anything using port 445.

### Create a folder to share

```bash
mkdir target_share
```

```bash
echo "hello from the SMB target" > target_share/hello.txt
```

### Start the Samba container

Run this command exactly:

```bash
sudo docker run -d --name samba-lab \
  -p 127.0.0.1:1445:445 \
  -v "$PWD/target_share:/mount" \
  dperson/samba \
  -p \
  -u "student;Password123!" \
  -s "share;/mount;yes;no;no;student"
```

What you just created:
- SMB user: `student`
- Password: `Password123!`
- Share name: `share`
- Files stored in: `~/BnB/impacket/target_share`

### Confirm the port is listening

```bash
nc -vz 127.0.0.1 1445
```

You should see a "**succeeded**" message

<img width="509" height="32" alt="service_test" src="https://github.com/user-attachments/assets/456fc75b-2dce-4e55-b42e-48fcbd7ac407" />


---
## Use Impacket to list shares and browse files

### List shares on the target

```bash
smbclient //127.0.0.1/SHARE -p 1445 -U student
```

- Enter the password set before - `Password123!`

This opens an interactive SMB shell.

```text
ls
```

You should see `hello.txt`

<img width="695" height="150" alt="smb_list" src="https://github.com/user-attachments/assets/44241513-8582-49ca-b7c6-c6c0f7a7db26" />


### Download a file from the SMB target

```text
get hello.txt
```

<img width="716" height="34" alt="smb_get_file" src="https://github.com/user-attachments/assets/c887a98d-600a-4c59-9c6c-af7358232867" />


Exit the SMB shell:

```text
exit
```

Check that the file downloaded to your current directory:

```bash
ls -l
```

```bash
cat hello.txt
```

<img width="451" height="34" alt="cat_hello" src="https://github.com/user-attachments/assets/0054025b-cde7-40ed-a4c5-8cf137443a1e" />


### Upload a file to the SMB target

Create a new local file:

```bash
echo "this file was uploaded using Impacket" > upload.txt
```

Reconnect:

```bash
smbclient //127.0.0.1/SHARE -p 1445 -U student
```

Inside:

```text
put upload.txt
```

```text
ls
```

```text
exit
```

Verify on the host that the file is in the shared folder:

```bash
ls -l target_share
cat target_share/upload.txt
```

---

## Run an SMB server using Impacket (reverse the roles)

So far, you used Impacket as a client to talk to Samba.

Now you'll run **Impacket's own SMB server** and connect to it.

### Create an "attacker" share folder

```bash
mkdir attacker_share
```

```bash
echo "hello from impacket smbserver" > attacker_share/from_impacket.txt
```

### Start smbserver.py on a safe port

We'll use port **2445** (so you don't need sudo).

In Terminal 1, run:

```bash
smbserver.py -port 2445 -smb2support LABSHARE ./attacker_share -username demo -password DemoPass123!
```

Leave this running

### Connect to your Impacket SMB server

Open Terminal 2 (**new terminal**), and run:

```bash
cd ~/BnB/impacket
```

```bash
source venv/bin/activate
```

```bash
smbclient //127.0.0.1/LABSHARE -p 2445 -U demo
```

- Enter the password set before - `DemoPass123!`

Inside:

```text
ls
```

```text
get from_impacket.txt
```

```text
exit
```

<img width="843" height="166" alt="smb_impk" src="https://github.com/user-attachments/assets/2abcd829-9d96-4f5c-ad53-e10c1c5785b0" />


Back on the host:

```bash
cat from_impacket.txt
```

Stop the SMB server in Terminal 1 with:

```text
Ctrl+C
```

---

# Cleanup

Stop and remove the Samba container:

```bash
sudo docker rm -f samba-lab
```

(If you started `smbserver.py`, make sure it's stopped with **Ctrl+C**)

Deactivate your Python environment:

```bash
deactivate
```


---

# Finished?

[Back to Keberoasting's Main Page](/Cards/PE/Kerberoasting.md)

[Back to Local_Privilege_Escalation's Main Page](/Cards/PE/Local_Privilege_Escalation.md)


[Back to Broadcast-Multicast_Protocol_Poisoning's Main Page](/Cards/PE/Broadcast-Multicast_Protocol_Poisoning.md)

