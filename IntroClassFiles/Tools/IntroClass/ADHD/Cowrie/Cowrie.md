![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Cowrie

# Ubuntu VM

Website
-------

<https://github.com/adhdproject/cowrie>

Description
-----------

Cowrie is a medium interaction SSH honeypot designed to log brute force attacks and, most importantly, the entire shell interaction performed by the attacker.

>[!TIP]
>
>Cowrie is developed by <b>Michel Oosterhof</b> and is based on <i>Kippo</i> by <b>Upi Tamminen</b> (desaster).

The first thing we need to do is install and start Cowrie.

To begin, let's open a terminal. 

Then become root by running the following command:

```bash
sudo su -
```

Getting Cowrie running is really easy if you have docker installed on your system.

All you need to do is run the following:

```bash
docker run -p 2222:2222 cowrie/cowrie
```

This will take a few moments.

You will see an output like this:

<img width="1265" height="317" alt="docker_cowrie_run" src="https://github.com/user-attachments/assets/8f92440c-721d-41fa-85a9-7006336a8db5" />

Once you see **"Ready to accept SSH connections"** in the command output, you are ready to continue.

Open another terminal while keeping the first terminal open with the logs open as well. 

<img width="311" height="52" alt="GetUbuntuTerminalFromUbuntuVM" src="https://github.com/user-attachments/assets/7860eaaa-bb6b-48b8-b5a0-7e1248684363" />

We need to delete any other previous `ssh known_hosts` connections to the honeypot.

This helps reduce any errors from starting and restarting the honeypot.

```bash
rm ~/.ssh/known_hosts
```

>[!IMPORTANT]
>You might not even have any `known_hosts` file, but:
>
>The above command is critical because the key fingerprint for Cowrie changes every time you restart it!

Then, try to connect to the honeypot with the following command:

```bash
ssh -p 2222 root@localhost
```

When you get prompted to accept the key fingerprint, type `yes`:

<img width="872" height="114" alt="2026-03-07_11-59" src="https://github.com/user-attachments/assets/2289320f-7e10-42dc-8581-59692c9c2a72" />

For the password, try `12345`:

<img width="853" height="330" alt="2026-03-07_12-01" src="https://github.com/user-attachments/assets/1c4657d6-43dc-4f5d-8963-6011b6e09edd" />

Now, run the following commands:

`id`

`whoami`

`pwd`

`AAAAAAAAAAAAAAAAAAAAAAAAAA`

<img width="524" height="242" alt="2026-03-07_12-05" src="https://github.com/user-attachments/assets/6bdb9f45-758c-400f-a68c-935d81daf5e7" />


Notice, the commands and authentication are being tracked in the other terminal with the log info:

<img width="805" height="152" alt="shell_logs" src="https://github.com/user-attachments/assets/85705716-0145-4eb1-9795-82061370b207" />

Take a few moments and notice that the results are always the same... for all Cowrie instances.

Let's change a few things about our Cowrie honeypot to make it unique.

Did you notice the system name in the prompt?

<img width="756" height="167" alt="2026-03-07_12-06" src="https://github.com/user-attachments/assets/c8b6784e-7f9a-4b1c-821d-0eb0d441df63" />


It is the same for all default installations. Let's change that.

First, we need to kill our Cowrie session.  

To do this, click into the first terminal with our log output and press `ctrl + c` at the same time.

<img width="1110" height="86" alt="docker_shut_down" src="https://github.com/user-attachments/assets/8065afec-043b-4c3b-ab77-7904344c658a" />

>[!TIP] 
>
>If done correctly, you should see **"Server Shut Down"**

As we said above, one of the ways that people have been detecting honeypots like Cowrie for years is looking at the key fingerprint and the hostname. 

Because the key fingerprint changes every time you restart Cowrie, we need to next focus on changing the hostname. 

To do this we need to change the following file as root on our cowrie container:

<pre>/cowrie/cowrie-git/etc/cowrie.cfg.dist</pre>

>[!NOTE]
>
>This is not a command, just the directory of the file we will be changing.

Before editing the container file, we must find the container ID of the cowrie. As root, run the following:

```bash
docker ps -a
```

<img width="1059" height="124" alt="docker_ps" src="https://github.com/user-attachments/assets/060fafe5-6955-4fb8-ae14-3cd19409c1ef" />

So now that we have the container ID, let's edit this file using `vim`.

As root, run the following (with your own container ID):

```bash
docker cp <container ID>:/cowrie/cowrie-git/etc/cowrie.cfg.dist .
```

<img width="524" height="29" alt="docker_copy_file" src="https://github.com/user-attachments/assets/58740da5-d035-4f06-982d-53193a0136da" />

```bash
vim cowrie.cfg.dist
```

<img width="263" height="16" alt="vim_cowrie" src="https://github.com/user-attachments/assets/ea38c352-353f-44ea-92a3-5c68600ef96a" />

>[!TIP]
>
>Copy and paste are your friends!

Once in the file, use the down arrow and go to roughly line 30 and change the hostname

<img width="446" height="74" alt="vim_hostname" src="https://github.com/user-attachments/assets/b1b7de00-530f-42c3-9322-4f3eb4248a57" />

To do this in vim, press `a` then make the change.

<img width="443" height="71" alt="vim_hostname_adjust" src="https://github.com/user-attachments/assets/02bd30ce-c86c-4fdb-91e4-3005f384a6cc" />

When done, hit the following keys in the following order

`esc`

`:`

`wq!`

`return`

Then update `cowrie.cfg.dist` file in the docker with the adjusted one.

```bash
docker cp cowrie.cfg.dist <container ID>:/cowrie/cowrie-git/etc/cowrie.cfg.dist
```

<img width="614" height="29" alt="docker_copy_adjusted" src="https://github.com/user-attachments/assets/90d87966-e741-4182-8e9b-43adcf66c304" />

Now, let's restart and connect:

```bash
docker start -a <container ID>
```

<img width="1266" height="249" alt="docker_run_1" src="https://github.com/user-attachments/assets/62152236-93d0-41c4-ad2f-ead2099cc068" />

Then, in another terminal connect with a password of 12345:

```bash
rm ~/.ssh/known_hosts
```

```bash
ssh -p 2222 root@localhost
```

Then type `yes` on the key fingerprint verification.

<img width="644" height="251" alt="docker_changed_hostname" src="https://github.com/user-attachments/assets/3aaadbdc-e289-40f8-94fd-9f2a9001e723" />


Your hostname should now be changed.


Now, let’s edit the Message of the Day (MOTD).  Because the default one is not fun at all.

As before, we must download the file `/cowrie/cowrie-git/honeyfs/etc/motd` from the docker, adjust it and then update it in the docker.

Terminate the Cowrie session with `Ctrl+C` and run as root the following (with your own container ID):

```bash
docker cp <container ID>:/cowrie/cowrie-git/honeyfs/etc/motd .
```

<img width="511" height="28" alt="docker_copy_motd" src="https://github.com/user-attachments/assets/03ea08d7-4811-43ac-8bd8-eae574f74a1e" />

```bash
vim motd
```

<img width="203" height="17" alt="vim_motd" src="https://github.com/user-attachments/assets/d3566bcf-d304-4133-9377-f9a4d9a4fb6c" />

In the `motd` file, erase the previous message and change it to something better!

```
WARNING WARNING WARNING!

Oh freddled gruntbuggly,
Thy micturitions are to me, with big yawning
As plurdled gabbleblotchits,
On a lurgid bee,
That mordiously hath blurted out,
Its earted jurtles, grumbling
Into a rancid festering confectious organ squealer, drowned out by moaning and screaming.
Now the jurpling slayjid agrocrustles,
Are slurping hagrilly up the axlegrurts,
And living glupules frart and stipulate,
Like jowling meated liverslime,
Groop, I implore thee, my foonting turlingdromes,
And hooptiously drangle me,
With crinkly bindlewurdles.
Or else I shall rend thee in the gobberwarts with my blurglecruncheon,
See if I don’t
```

<img width="1259" height="533" alt="vim_motd_new_message" src="https://github.com/user-attachments/assets/a7186cd5-7e20-44fe-bdde-e6d3af6ab0e1" />

When done, hit the following keys in the following order

`esc`

`:`

`wq!`

`return`

Then update `motd` file in the docker with the adjusted one.

```bash
docker cp motd <container ID>:/cowrie/cowrie-git/honeyfs/etc/motd
```

<img width="530" height="29" alt="docker_copy_motd_adjusted" src="https://github.com/user-attachments/assets/5d3a336d-fd9f-48cf-bdc5-3526255762d4" />

Now, let's restart and connect:

```bash
docker start -a <container ID>
```

<img width="1268" height="248" alt="docker_run" src="https://github.com/user-attachments/assets/ad4c25e1-c010-472e-83d9-4aa02030dd53" />

Then, in another terminal connect with a password of 12345:

```bash
rm ~/.ssh/known_hosts
```

```bash
ssh -p 2222 root@localhost
```

Then type `yes` on the key fingerprint verification.

<img width="688" height="437" alt="ssh_new_message" src="https://github.com/user-attachments/assets/5d931f8e-99b2-4bdc-9f7d-268b5f25beee" />


There!

That is much better!

There is far more than we can change in this short lab.

For a great resource on changing the way Cowrie looks and feels, check out the following site:

https://cryptax.medium.com/customizing-your-cowrie-honeypot-8542c888ca49

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Portspoof/Portspoof.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Spidertrap/Spidertrap.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---

<!--

THIS SECTION IS BEING REMOVED FOR THE TIME BEING PER JOHN



Install Location
----------------

`/opt/cowrie`

Usage
-----

Cowrie is incredibly easy to use.

It basically has two parts you need to be aware of:

  * A config file
  * A launch script

The config file is located at

`/opt/cowrie/etc/cowrie.cfg`


Example 1: Running Cowrie
------------------------

By default Cowrie listens on port 2222 and emulates an ssh server.

To run Cowrie, cd into the Cowrie directory and execute:

`~$` **`cd /opt/cowrie`**
`~$` **`./bin/cowrie start`**

        Not using Python virtual environment
        version check
        Starting cowrie: [twistd   --umask=0022 --pidfile=var/run/cowrie.pid --logger cowrie.python.logfile.logger cowrie ]...

We can confirm Cowrie is listening with Cowrie's own `status` command:

`~$` **`./bin/cowrie status`**

        cowrie is running (PID: 21473).

We can also confirm Cowrie is listening with lsof:

`~$` **`sudo lsof -i -P | grep twistd`**

        twistd  548 adhd    6u  IPv4 523637      0t0  TCP *:2222 (LISTEN)

Looks like we're good.

Example 2: Cowrie In Action
--------------------------

Assuming Cowrie is already running and listening on port 2222, (if not see [Example 1: Running Cowrie]),
 we can now ssh to Cowrie in order to see what an attacker would see.

`~$` **`ssh -p 2222 localhost`**

        The authenticity of host '[localhost]:2222 ([127.0.0.1]:2222)' can't be established.
        RSA key fingerprint is 05:68:07:f9:47:79:b8:81:bd:8a:12:75:da:65:f2:d4.
        Are you sure you want to continue connecting (yes/no)? yes
        Warning: Permanently added '[localhost]:2222' (RSA) to the list of known hosts.
        Password:
        Password:
        Password:
        adhd@localhost's password:
        Permission denied, please try again.

It looks like our attempts to authenticate were met with failure.

Example 3: Viewing Cowrie's Logs
-------------------------------

Change into the Cowrie log Directory:

`~$` **`cd /opt/cowrie/var/log/cowrie`**

Now tail the contents of cowrie.log:

`/opt/cowrie/var/log/cowrie$` **`tail cowrie.log`**

        2016-02-17 21:52:12-0700 [-] unauthorized login:
        2016-02-17 21:54:51-0700 [SSHService ssh-userauth on HoneyPotTransport,0,127.0.0.1] adhd trying auth password
        2016-02-17 21:54:51-0700 [SSHService ssh-userauth on HoneyPotTransport,0,127.0.0.1] login attempt [adhd/asdf] failed
        2016-02-17 21:54:52-0700 [-] adhd failed auth password
        2016-02-17 21:54:52-0700 [-] unauthorized login:
        2016-02-17 21:54:53-0700 [SSHService ssh-userauth on HoneyPotTransport,0,127.0.0.1] adhd trying auth password
        2016-02-17 21:54:53-0700 [SSHService ssh-userauth on HoneyPotTransport,0,127.0.0.1] login attempt [adhd/adhd] failed
        2016-02-17 21:54:54-0700 [-] adhd failed auth password
        2016-02-17 21:54:54-0700 [-] unauthorized login:
        2016-02-17 21:54:54-0700 [HoneyPotTransport,0,127.0.0.1] connection lost

Here we can clearly see my login attempts and the username/password combos I employed as I tried
to gain access in [Example 2: Cowrie In Action].  This could be very useful!

Also, when you get a chance, take a look at the command configuration files in the `/opt/cowrie/honeyfs` directory.

Finally, user accounts for logging into the fake ssh server can be placed in a `/opt/cowrie/etc/userdb.txt` file. This file no longer exists by default, so Cowrie uses credentials specified near the top of `/opt/cowrie/src/cowrie/core/auth.py` by default

An example userdb file can be found in `/opt/cowrie/etc/userdb.example`. Cowrie
credentials can be specified using patterns. These patterns are explained in the
example file.

What happens when you log in with one of the valid userID and password combos?

What happens when you exit the session?

What are some solid IOCs that this is a honeypot?
--!>
 
