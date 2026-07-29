![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# net use

# Windows VM


`net use` is a built in Windows command that connects to, disconnects from, and lists shared network resources (file shares, printers). It has existed since the early NT days and is still one of the fastest ways to map a drive, authenticate to a remote share with different credentials, or check what shares a machine is exposing. It is also one of the most common tools used for lateral movement once an attacker has valid credentials, so it is worth understanding from both sides.

## In this lab we will
- Map and disconnect network drives from the command line
- Connect to a share using alternate credentials
- View what shares a machine is exposing and who is connected to them
- Understand how `net use` is used for lateral movement via administrative shares
- Look at the Windows Event Log artifacts this activity leaves behind


## Let's start

Open **Command Prompt**

<img width="82" height="98" alt="image" src="https://github.com/user-attachments/assets/8de53dad-60f7-4069-af8a-4015800ac360" />

### Part 1 - confirm net use is available

```cmd
net use /?
```

<img width="623" height="501" alt="image" src="https://github.com/user-attachments/assets/efa90bef-0267-4e7b-8490-a41008237fe3" />


You will see the full help output

### Part 2 - create and share a test folder

```cmd
mkdir C:\ShareLab
echo This is a test file for the net use lab > C:\ShareLab\notes.txt
```

Share it out with full permissions for testing purposes:

```cmd
net share LabShare=C:\ShareLab /grant:everyone,full
```

Confirm the share exists:

```cmd
net share
```

<img width="890" height="480" alt="2026-07-26_12-53" src="https://github.com/user-attachments/assets/21a0acaa-da8d-4362-8a64-5f10455ff0ed" />


You should see `LabShare` listed alongside the default hidden shares like `ADMIN$`, `C$`, and `IPC$` (more on those later).

### Part 3 - create a lab user account

We will use this account later to test connecting with alternate credentials.

```cmd
net user labuser Password123! /add
```

### Part 4 - find your computer name

```cmd
hostname
```

<img width="306" height="54" alt="image" src="https://github.com/user-attachments/assets/0e25d051-d5b3-465e-a7e9-fb52c9e13eab" />


You can use this hostname instead of `localhost` in any command below if you prefer.

### Part 5 - view current connections

```cmd
net use
```

At this point it should say there are no entries in the list, since we have not connected to anything yet.

### Part 6 - browse shares with net view

```cmd
net view \\localhost
```

This lists every share the machine is exposing, including `LabShare`. `net view` is the enumeration Part an attacker or analyst runs first, it tells you what is reachable before you try to connect to anything.

### Part 7 - map a drive

```cmd
net use Z: \\localhost\LabShare
```

Confirm it worked:

```cmd
net use
```

<img width="731" height="191" alt="image" src="https://github.com/user-attachments/assets/3b3df209-bff4-485f-a6fe-11c8b3627c68" />


Navigate to it like a normal drive:

```cmd
Z:
```

```cmd
dir
```

```cmd
type notes.txt
```

<img width="522" height="338" alt="image" src="https://github.com/user-attachments/assets/43066e5d-da27-430e-885c-2953f136686d" />


### Part 8 - reconnect using alternate credentials

Disconnect first:

```cmd
net use Z: /delete
```

Press **Y** when prompted

<img width="659" height="61" alt="image" src="https://github.com/user-attachments/assets/2a3bdf14-79a6-4d76-9a15-150d4f3ad48e" />


Now reconnect specifying the `labuser` account instead of your own:

```cmd
cd /d C:\
net use Z: \\localhost\LabShare /user:labuser Password123!
```

This is the same technique used any time you need to access a resource as someone other than the currently logged on user, for example a service account or an account on a different domain

---

## Attacker perspective - admin shares and lateral movement

Every Windows machine automatically exposes a set of hidden administrative shares:

| Share | Points to | Purpose |
|---|---|---|
| C$ | C:\ | Root of the C drive |
| ADMIN$ | C:\Windows | Remote administration |
| IPC$ | N/A | Named pipes, used for authentication and RPC |

These exist by default and cannot be seen by browsing the network (the trailing `$` hides them), but they can still be connected to directly if you have valid administrator credentials for the target. This is exactly how tools like PsExec and Impacket's psexec.py work under the hood, they drop a file onto `ADMIN$` or `C$` and then trigger execution with a second technique like a service or scheduled task.

> [!TIP]
> If you cracked a set of credentials in a previous lab (for example with Hydra against Dionaea), the next real world Part is exactly this, test those credentials against `net use \\target\C$` on other hosts on the network to see if they grant access anywhere else.

### Part 9 - enable the built in Administrator account for this test

On Windows 10 and 11 the built in Administrator account (RID 500) is disabled by default. We are enabling it temporarily so this Part works cleanly, and we will disable it again during cleanup.

```cmd
net user administrator /active:yes
net user administrator LabAdminPass1!
```

> [!NOTE]
> If you try this with a different local admin account instead of the built in Administrator, you may get "Access is denied" even though the account is a local administrator. Since Windows Vista, local accounts other than the built in Administrator receive a filtered, non admin token over the network by default (UAC remote restrictions). Domain admin accounts are not affected by this. It is why real world lateral movement so often relies on domain admin credentials rather than local admin ones.

### Part 10 - connect to the C$ admin share

```cmd
net use * /delete /y
net use \\localhost\C$ /user:administrator
```

Enter the password ( **LabAdminPass1!** ) when prompted

### Part 11 - move a file through the share

With the connection from Part 10 still active, you can address the target directly by UNC path without ever mapping a drive letter:

```cmd
copy C:\ShareLab\notes.txt \\localhost\C$\Windows\Temp\notes_copied.txt
```

`C:\Windows\Temp` is one of the most common staging locations for dropped tools in real intrusions, since it is writable and rarely monitored as closely as user folders.

<img width="709" height="174" alt="image" src="https://github.com/user-attachments/assets/c9682535-b743-424c-be66-176a64fce17e" />


---

## Defender perspective - seeing what net use leaves behind

### Part 12 - net session, who is connected to your shares

```cmd
net session
```

<img width="729" height="156" alt="image" src="https://github.com/user-attachments/assets/ac0403e7-0817-4f75-bf8a-f4b9b8714c1c" />


This shows every client currently connected to shares on this machine, along with idle time. On a real file server, this is one of the first places to check when you suspect something is pulling data off a share it should not be touching.

### Part 13 - enable file share auditing

Share access auditing is off by default on Windows, so nothing gets logged until you turn it on:

```cmd
auditpol /set /subcategory:"File Share" /success:enable /failure:enable
```

Generate a fresh event by reconnecting to the share:

```cmd
net use Z: \\localhost\LabShare
```

### Part 14 - check Event Viewer

Open Event Viewer 

<img width="836" height="790" alt="image" src="https://github.com/user-attachments/assets/cf91acf6-41cf-4291-89cc-a14eee255661" />


Go to Windows Logs -> Security, and look for these Event IDs:

- **5140** - A network share object was accessed. Logged once per session the first time a share is touched. This is your "someone connected to a share" event.
- **4624**, Logon Type 3 - the underlying successful network logon that happens every time `net use` authenticates to a remote machine.

> [!TIP]
> Event 5140 also fires for loopback connections like the ones in this lab (source address 127.0.0.1 or ::1). In a real hunt you would exclude loopback traffic, since it is just local services talking to themselves and is not meaningful for tracking lateral movement between hosts.


<img width="1350" height="382" alt="2026-07-26_13-19" src="https://github.com/user-attachments/assets/b6adebc2-a94a-45bc-88b3-c3040915b710" />




---

# Finished?

[Back to Card's Main Page](/Decks/CORE_v3.1/PE/Internal_Password_Spray.md)
