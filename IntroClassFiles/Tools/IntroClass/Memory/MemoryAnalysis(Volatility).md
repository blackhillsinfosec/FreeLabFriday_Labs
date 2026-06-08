![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)


---

This is a lab from **John Strand**'s **SOC Core Skills** Course:

https://www.antisyphontraining.com/product/soc-core-skills-with-john-strand/

---

# Memory Analysis

# Ubuntu VM

In this lab we will be looking at a memory dump of a compromised system.  

To do this, we need to decompress it and use **Volatility** to examine the network connections and process information for the malware.  

>[!NOTE]
>Please keep in mind that we are using a free tool for this lab.  While **Volatility** is great, it has some limitations.  Specifically, in the area of network PIDs.  While we use **Volatility**, the same concepts can also be applied to any commercial tools you may be using in your environment.

>[!TIP]
>This memory dump was created from **VMWare** snapshot feature. There are multiple tools like **winpmem** and **FTK Imager** that can also create memory dumps.

To start, we will open a terminal. 

<img width="45" height="51" alt="image" src="https://github.com/user-attachments/assets/d8073cce-6bb4-4515-8121-79b0e1b60481" />


Gain root access by using the following command.

```bash
sudo su -
```

Next, we need to navigate to the appropriate directory. 

```bash
cd Intro_To_SOC/
```

Download and unzip volatility(copy-paste is your firned:

```bash
wget https://github.com/volatilityfoundation/volatility3/archive/refs/tags/v1.0.0.zip
unzip v1.0.0.zip
cd volatility3-1.0.0
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
python -m pip install pycryptodome
```

Lets begin by finding pages in the memory that have read, write, and execute privileges.

```bash
python3 vol.py -f ../memdump.vmem windows.malfind.Malfind
```

Patience, Padawan! This can take up to several minutes to complete.

<img width="1268" height="134" alt="2026-06-08_14-36" src="https://github.com/user-attachments/assets/f4636815-21b3-49d6-9ded-28dc80cb6009" />


Right away, we notice that the file **"TrustMe.exe"** looks very suspicious.

Let's continue by looking at the network connections.

```bash
python3 vol.py -f ../memdump.vmem windows.netscan
```

<img width="1310" height="135" alt="2026-06-08_14-43" src="https://github.com/user-attachments/assets/c2aaf0b1-5b90-4f03-a974-629e0426b35b" />


The above screenshot is... concerning.

Because there is a SMB (port 445) connection to another computer, we need to investigate further. We know it is compromised, (because it is a lab), but any time a **"suspect"** computer has another open connection to an internal system it is, without question, a cause for concern.

Now, let's look at the processes on this system.

```bash
python3 vol.py -f ../memdump.vmem windows.pslist
```

<img width="1493" height="250" alt="2026-06-08_14-44" src="https://github.com/user-attachments/assets/71eb5cc5-e7d3-4f73-87d7-17de1f997312" />


The **cmd.exe** should catch your attention. Generally, usage of a system does not spawn a **cmd.exe** session. There is a chance that it can appear briefly as part of a sysadmin script, but it is not a normal sight and very often not seen in day-to-day life.  

Let's look at **pstree** to see a bit more detail on what spawned what.

```bash
python3 vol.py -f ../memdump.vmem windows.pstree
```

<img width="1478" height="555" alt="2026-06-08_14-46" src="https://github.com/user-attachments/assets/ed8ceb76-2841-443f-a372-a366c9196ea6" />


You can see that we traced back the parent process for one of the cmd.exe files back to **TrustMe.exe**. When hunting down these processes it helps to track the parent processes. It can help create a sort of timeline for the actions on the system.

In the above example, we can also see that the parent process for **TrustMe.exe** was **Explorer.exe**. This means it was invoked by the user on the system, as **Explorer.exe** is the GUI process for Windows 10.

Let's now dive into the **TrustMe.exe** process a bit further with **dlllist**. For this command, we will use the PID of **TrustMe.exe**, which is 5452.

```bash
python3 vol.py -f ../memdump.vmem dlllist --pid 5452
```

<img width="1453" height="220" alt="image" src="https://github.com/user-attachments/assets/e2280049-0c81-4588-9902-08f02d38a3d2" />


You can see the **dll's** associated with the **TrustMe.exe** process.

We can also see the command line invocation of this process. These lines tell us any flags used to start the process as well as where on the system it was executed from.  

***                                                                 
<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---

