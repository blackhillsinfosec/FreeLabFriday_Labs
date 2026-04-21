![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Advanced C2 PCAP Analysis - vsagent HTTP Beaconing

# Ubuntu VM

- First, we will need to open the Ubuntu Terminal

- Now, we should move to the proper directory

```bash
cd ~/ADCD/advancedC2
```

- Let's run a tcpdump command to do an initial review of the capture

```bash
sudo tcpdump -nA -r vsagent_c2.pcap | less
```

- The `-nA` option tells tcpdump not to resolve names (`n`) and print the ASCII text of the packet (`A`). You are reading in a file with the `-r` option and piping the data (`|`) through `less` so you can view it section by section

<img width="1291" height="836" alt="2026-03-12_11-43" src="https://github.com/user-attachments/assets/9bde375a-2e1a-4378-9c93-97f1e62f8812" />


- Hit spacebar to page through the output. Look for HTTP traffic - you will see `GET /beacon`, `POST /beacon`, and response bodies mixed in with ARP, DNS, and NTP background noise

- Press `q` to close the tcpdump session

- One of the interesting things about many malware specimens we review is how they "wait" for the attacker to communicate with them. In this sample, the **vsagent** backdoor **beacons** out every 30 seconds

- This is for two reasons. One is because the attacker might not be at a system waiting for a command shell. Secondly, because long-term established sessions tend to attract attention - with HTTP, sessions are generally short burst connections. vsagent is designed to mimic that behaviour

- In the capture, the **SYN** packets are roughly 30 seconds apart for the beacon traffic

- To see the SYN packets, simply run the following command:

```bash
sudo tcpdump -r vsagent_c2.pcap 'tcp[13] = 0x02'
```

<img width="1019" height="195" alt="2026-03-12_11-45" src="https://github.com/user-attachments/assets/83857c94-a957-4357-9722-32fc6052b6c4" />


- This filter shows all packets with the SYN bit (`0x02`) set in the 13th byte offset of the TCP header (`tcp[13]`)

- Note the time difference between packets. You can see they are almost all 30 seconds apart for each beacon cycle

- Now, let's identify the **User-Agent** string the implant is using

```bash
sudo tcpdump -nA -r vsagent_c2.pcap | grep -i "user-agent"
```

<img width="1006" height="176" alt="2026-03-12_11-47" src="https://github.com/user-attachments/assets/508c947b-a1e1-412b-a1da-0db06e2b7fb0" />


- You will see two kinds of User-Agent strings - one long `Mozilla/5.0` string from background noise, and the short `vsagent/1.0` string repeating on every beacon connection. A hardcoded, non-browser User-Agent appearing every 30 seconds is a strong indicator of implant traffic

- Run the following command to isolate all HTTP GET beacons:

```bash
sudo tcpdump -nA -r vsagent_c2.pcap | grep "GET /beacon"
```

- It should look like this:

<img width="1323" height="264" alt="2026-03-12_12-05" src="https://github.com/user-attachments/assets/80d51d0a-6696-441b-a472-a6537fbf2245" />

- Notice the fixed URI path `/beacon` across every request, the absence of `Referer` and `Accept-Encoding` headers, and no cookies - all hallmarks of an implant rather than a browser

- Now let's look for commands delivered by the C2 server:

```bash
sudo tcpdump -nA -r vsagent_c2.pcap | grep -i "cmd="
```

<img width="1129" height="154" alt="2026-03-12_12-21" src="https://github.com/user-attachments/assets/a81307a3-1b9f-4e2b-8223-530a5d778378" />


- You should see a number of returned lines. Some will show just `cmd=` with nothing after it - those are idle check-ins. At least one will show `cmd=` followed by what appears to be random data ending with an `=` sign. That trailing `=` padding is a strong indicator the data is **Base64** encoded

- Does this mean it is evil? Not necessarily. It just means it is interesting

- You can quickly prove or disprove this by using Python to decode the data. If it is Base64, it will decode cleanly to ASCII. If not, you will keep looking

- Next, look for the exfiltration traffic:

```bash
sudo tcpdump -nA -r vsagent_c2.pcap | grep "POST"
```

<img width="1335" height="88" alt="2026-03-12_12-22" src="https://github.com/user-attachments/assets/837b9fcf-dfd9-4408-b8ca-a93910870ac2" />


- You will see a `POST /beacon` request - the implant shipping stolen data back to the operator using the same URI path it uses for check-ins

- Run the following to see the exfiltrated data blob:

```bash
sudo tcpdump -nA -r vsagent_c2.pcap | grep "output="
```

<img width="1903" height="112" alt="2026-03-12_12-23" src="https://github.com/user-attachments/assets/aa7638b6-10d8-4b76-8300-499e7ff025d5" />


- You should see `output=` followed by a Base64 encoded blob - larger than the `cmd=` strings, because task output is typically much longer than the command that produced it

- Now for the fun part. Let's decode the C2 command. Take the Base64 string you found after `cmd=` in the tasked response and run:

```bash
python3 -c "import base64; print(base64.b64decode('<paste_base64_here>').decode())"
```

<img width="1904" height="290" alt="2026-03-12_12-27" src="https://github.com/user-attachments/assets/5bc0a493-fe8c-4dba-8cc1-e74c51e289e1" />


- When you do this, you will quickly see that the **Base64** encoded data is a PowerShell command to download and execute a remote script - a classic stager that pulls a second-stage payload into memory without writing it to disk

- Now decode the exfiltrated output blob the same way. Take the Base64 string after `output=` and run:

```bash
python3 -c "import base64; print(base64.b64decode('<paste_base64_here>').decode())"
```

- It should look like this:

<img width="1901" height="315" alt="2026-03-12_12-25" src="https://github.com/user-attachments/assets/52d6caf0-07bc-461e-81cc-7bb90ec79fa5" />

- You can now see exactly what data the implant shipped to the operator - in this case a `whoami` result and a directory listing of the user's Documents folder


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/webhoneypot/webhoneypot.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHDhoneyuser/honeyuser.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
