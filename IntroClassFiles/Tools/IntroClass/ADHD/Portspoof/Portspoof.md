![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Portspoof

# Windows VM

Website
-------

<http://portspoof.org/>

Description
-----------

Portspoof is meant to be a lightweight, fast, portable and secure addition to any firewall system or security system. The general goal of the program is to make the reconnaissance phase as slow and bothersome as possible for your attackers. This is quite a change to the standard aggressive Nmap scan, which will give a full view of your system's running services.

By using all of the techniques mentioned below:

* your attackers will have a tough time while trying to identify all of your listening services.
* the only way to determine if a service is emulated is through a protocol probe (imagine probing protocols for 65k open ports!).
* it takes more than 8 hours and 200MB of sent data in order to get all of the service banners for your system (nmap -sV -p - equivalent).

---

The Portspoof program's primary goal is to enhance OS security through a set of new techniques:

#### Technique 1: All TCP ports are always open

Instead of informing an attacker that a particular port is CLOSED or FILTERED, a system with Portspoof will return SYN+ACK for every port connection attempt.

As a result it is impractical to use stealth (SYN, ACK, etc.) port scanning against your system, since all ports are always reported as OPEN. With this approach it is really difficult to determine if a valid software is listening on a particular port (check out the screenshots).

#### Technique 2: Every open TCP port emulates a service

Portspoof has a huge dynamic service signature database, which will be used to generate responses to your attackers scanning software service probes.

Scanning software usually tries to determine a service that is running on an open port. This step is mandatory if one would want to identify port numbers on which you are running your services on a system behind the Portspoof. For this reason Portspoof will respond to every service probe with a valid service signature, which is dynamically generated based on a service signature regular expression database.

As a result an attacker will not be able to determine which port numbers your system is truly using.

Install Location
----------------

`/usr/local/bin/portspoof`

Config File Location
--------------------

`/usr/local/etc/portspoof.conf`
`/usr/local/etc/portspoof_signatures`

Usage
-----

```bash
portspoof -h
```

```
Usage: portspoof [OPTION]...
Portspoof - service emulator / frontend exploitation framework.

-i			  ip : Bind to a particular  IP address
-p			  port : Bind to a particular PORT number
-s			  file_path : Portspoof service signature regex. file
-c			  file_path : Portspoof configuration file
-l			  file_path : Log port scanning alerts to a file
-f			  file_path : FUZZER_MODE - fuzzing payload file list
-n			  file_path : FUZZER_MODE - wrapping signatures file list
-1			  FUZZER_MODE - generate fuzzing payloads internally
-2			  switch to simple reply mode (doesn't work for Nmap)!
-D			  run as daemon process
-d			  disable syslog
-v			  be verbose
-h			  display this help and exit
```


Example 1: Starting Portspoof
-----------------------------

When ran, Portspoof listens on a single port. By default this is port 4444. In order to fool a port scan, we have to allow Portspoof to listen on *every* port. To accomplish this we will use an `iptables` command that redirects every packet sent to any port to port 4444 where the Portspoof port will be listening. This allows Portspoof to respond on any port.




- Open **Ubuntu Shell**

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/ae6d408b-7622-4545-b849-aef3d8fa0cb4" />


Let's become root:

```bash
sudo su -
```

Let's add the firewall rules.

```bash
iptables -t nat -A PREROUTING -p tcp -m tcp --dport 1:20 -j REDIRECT --to-ports 4444
```

Then run Portspoof with no options, which defaults it to "open port" mode. This mode will just return OPEN state for every connection attempt.

```bash
portspoof
```

<img width="1007" height="67" alt="image" src="https://github.com/user-attachments/assets/3664f938-381c-4e12-969b-a482788fb47b" />



If you were to scan using Nmap from another Windows command prompt. Now you would see something like this:

>[!IMPORTANT]
>
>You *must* run Nmap from a different machine. Scanning from the same machine will not reach Portspoof.

Open a Windows command prompt:

<img width="74" height="91" alt="Screenshot From 2026-02-07 17-59-56" src="https://github.com/user-attachments/assets/c2a1f12a-b377-478d-9416-ff4c8291dc01" />

Then, run nmap:

```bash
nmap -p 1-10 linux.cloudlab.lan
```

<img width="456" height="326" alt="example_1_nmap" src="https://github.com/user-attachments/assets/ff637541-be82-408d-b121-7ff378ef7ba9" />


All ports are reported as open! When run this way, Nmap reports the service that typically runs on each port.

To get more accurate results, an attacker might run an Nmap service scan, which would actively try to detect the services running. But performing an Nmap service detection scan shows that something is amiss because all ports are reported as running the same type of service.

```bash
nmap -p 1-10 -sV linux.cloudlab.lan
```

<img width="646" height="340" alt="example_1_nmap_2" src="https://github.com/user-attachments/assets/2919c008-df2c-416e-8997-3e6a49eef32c" />


Example 2: Spoofing Service Signatures
--------------------------------------

Showing all ports as open is all well and good, but the same thing could be accomplished with a simple netcat listener:

```bash
nc -l -k 4444
```

To make things more interesting, how about we have Portspoof fool Nmap into actually detecting real services running?

Let's kill the running version of Portspoof with `Ctrl + C` then restart it with signatures:

```bash
portspoof -s /etc/portspoof/portspoof_signatures
```

<img width="506" height="130" alt="example_2_portspoof_s" src="https://github.com/user-attachments/assets/4db6053f-4070-4fd8-8fee-d5bd69a4d990" />


This mode will generate and feed port scanners like Nmap bogus service signatures.

Now running an Nmap service detection scan against the top 100 most common ports (a common hacker activity) will turn up some very interesting results.

```bash
nmap -p 1-10 -sV linux.cloudlab.lan
```

<img width="1190" height="581" alt="example_2_nmap" src="https://github.com/user-attachments/assets/9916a35c-9a60-420d-a2ef-4a25446ec4bb" />


Notice how all of the ports are still reported as open, but now Nmap reports a unique service on each port. 

This will either: 
1) Lead an attacker down a rabbit hole investigating each port while wasting their time...
2) or the attacker may discard the results as false positives and ignore this machine altogether, leaving any legitimate service running untouched.

Example 3: Cleaning Up
----------------------

To reset our VM, you can reboot (recommended) or:

1. Kill Portspoof by pressing `Ctrl + C`.
2. Flush all iptables rules by running the command (as root): 
```bash
sudo iptables -t nat -F
```

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/HoneyPorts/HoneyPorts.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Cowrie/Cowrie.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
