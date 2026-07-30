![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **SOC Core Skills** Course:

https://www.antisyphontraining.com/product/soc-core-skills-with-john-strand/

---

# TCPDump
### Lab Objective
In this lab, we will be looking at some basic **tcpdump** filters that every SOC and security analyst should know.
<hr>

## Part 1: Running the Command.
Let’s get started by opening a Terminal (or Ubuntu Shell).

<img width="49" height="49" alt="image" src="https://github.com/user-attachments/assets/07e58580-5e41-41a2-ae2a-b9017983b271" />

Navigate to the appropriate directory. 

```bash
cd ~/Intro_To_SOC/
```

We are going to start with a very basic filter that simply shows us the data associated with a specific host.

The filter in this case, is host.

```bash
tcpdump -n -r magnitude_1hr.pcap host 192.168.99.52
```

For this command, we are telling **tcpdump** to do two things: do not resolve hostnames **(-n)** and read in the data from a file **(-r)**.

<img width="1389" height="554" alt="image" src="https://github.com/user-attachments/assets/2bcd6e52-c127-4d7c-82f0-2ebda51e3a33" />
<hr>

## Part 2: Breaking Down The Output.
What exactly is this showing us?

Well, it is showing each packet's timestamp:
<img width="157" height="24" alt="image" src="https://github.com/user-attachments/assets/fa38f4e7-bc78-4275-8796-11902d856a9a" />


Its protocol:
<img width="32" height="179" alt="image" src="https://github.com/user-attachments/assets/22989634-6a47-4150-bc60-605e4cdeb514" />


Its **source** IP address + port direction and **destination** IP address + port :
<img width="404" height="22" alt="image" src="https://github.com/user-attachments/assets/c5d66759-2315-41b8-ba9c-b306a05613e3" />


Its control bit flags and sequence numbers:
<img width="350" height="24" alt="image" src="https://github.com/user-attachments/assets/5d09835f-022c-4158-8b52-fa9635040d75" />


And data size:
<img width="119" height="29" alt="image" src="https://github.com/user-attachments/assets/507e5c82-a09b-47f3-a4bf-1a14cbcdc939" />
<hr>

## Part 3: Learning To Filter.
We can get the filter to be a bit more granular.  In fact, you can create filters for literally every part of a packet!

Let's add port number.

```bash
tcpdump -n -r magnitude_1hr.pcap host 192.168.99.52 and port 80
```

<img width="1903" height="506" alt="image" src="https://github.com/user-attachments/assets/3c44c256-c0f9-4e04-b074-bf59f2f9e848" />


In the screenshot above, you can see we now have all the packets that are either sent or received by port 80 on 192.168.99.52.

While getting the overall metadata from the packets is nice, we can get the full **ASCII** decode of the packet and the payload of the packet.

On one hand, getting the metadata from the packets is nice.  On the other hand, why not get the full ASCII decode and payload of the packet?

```bash
tcpdump -n -r magnitude_1hr.pcap host 192.168.99.52 and port 80 -A
```

>[!TIP]
>You can hit **ctrl + c** after a few seconds.

<img width="1905" height="447" alt="2026-06-08_17-00" src="https://github.com/user-attachments/assets/6dab42d3-9f37-49a8-82c5-de9eea919868" />


As you can see above, we now can see the actual http GET requests and the responses.  

Lets dig into the packet with the timestamp of 15:14:32.638976

Ouch, it looks like **PowerShell!!!**  A favorite of attackers and pentesters alike.  

<img width="1905" height="317" alt="2026-06-08_17-01" src="https://github.com/user-attachments/assets/13a1996e-422f-43c4-be4b-7138d5b8efd8" />


Furthermore, it looks like there is **Base64** data.

<img width="1903" height="273" alt="2026-06-08_17-02" src="https://github.com/user-attachments/assets/647b1033-f9e9-4fc5-ab77-36849c42a1da" />


Still not enough?  We can also see the raw **Hex** values with the -X flag:

```bash
tcpdump -n -r magnitude_1hr.pcap host 192.168.99.52 and port 80 -AX | less
```

>[!TIP]
> Press **q** to exit the **less** interface

<img width="1901" height="882" alt="Screenshot 2026-06-08 170423" src="https://github.com/user-attachments/assets/0a0e30c4-9ad2-406c-9822-81aeed388a9b" />


We can also show specific protocols of interest.

For example:

```bash
tcpdump -n -r magnitude_1hr.pcap ip6
```

<img width="1375" height="547" alt="image" src="https://github.com/user-attachments/assets/f56d3f6f-d417-483e-b96b-75c550d7d440" />


This is showing all the **ipv6** traffic.

We can show network ranges.  This is very useful when you are seeing traffic either to or from a range of IP addresses.  For example, this can help us answer questions like, "Are there any other systems talking to this IP address range?" 

Think of an attacker using multiple systems on a network range to disperse their **C2** traffic.

```bash
tcpdump -n -r magnitude_1hr.pcap net 192.168.99.0/24
```

<img width="1388" height="726" alt="image" src="https://github.com/user-attachments/assets/ce386eb3-413d-4e2a-8ab4-8e2adf61a57a" />
<hr>

## Looking For More Practice?
Want more Pcaps to practice with?
Please check out, "Malware of the Day" from **Active Countermeasures**!

`https://www.activecountermeasures.com/category/malware-of-the-day/`

Below are the commands to download some of the capture files.  Try and run through the basic level analysis we just did with them.

`https://www.dropbox.com/s/zyqn3nn5ygfki59/teamviewer_1hr.pcap`

`https://www.activecountermeasures.com/pcap/apt1virtuallythere_1hr.pcap`

`https://www.dropbox.com/s/51uzphl1f3ca691/lateral_backup_c2_1hr.pcap`

`https://www.dropbox.com/s/bhgvpablx11u8yb/taidoor_1hr.pcap`

Here is a great resource to try some more options in **TCPDump**:

`https://danielmiessler.com/study/tcpdump/`























