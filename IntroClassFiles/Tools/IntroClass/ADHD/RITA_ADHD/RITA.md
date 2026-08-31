![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **SOC Core Skills** Course:

https://www.antisyphontraining.com/product/soc-core-skills-with-john-strand/

---

# RITA Lab


<hr>

## Lab Objective
In this lab, you will be using **Real Intelligence Threat Analytics** (RITA) to go through 7 different datasets.<br> 
For each one, you will have to answer some questions.

<hr>

Let's begin by opening a Terminal (or Ubuntu Shell).
![image](/IntroClassFiles/Tools/IntroClass/attachmentsfornewlabs/openshell.png)

To view all of the datasets, we can run the following command:
<pre>rita list</pre>

<hr>

## Dataset 1: slow_steady_beacon
**Dataset Description:** Cobalt Strike - HTTP, Delay 3s, Jitter 0

To view this dataset, run the following:
<pre>rita view slow_steady_beacon</pre>

<br>

### Dataset 1 Questions
1. Which internal host IP is beaconing?
2. What external IP is being contacted?
3. What protocol and port are used?
4. What is the beacon score?
5. What is the connection count?

<hr>

## Dataset 2: beacon_jitter 
**Dataset Description:** Cobalt Strike - HTTP, Delay 30s, Jitter 25%

To view this dataset, run the following: 
<pre>rita view beacon_jitter</pre>

<br>

### Dataset 2 Questions
1. Which internal host IP is contacting the FQDN?
2. What FQDN is being contacted?
3. What protocol and port are used?
4. What is the beacon score?
5. What is the connection count?

<hr>

## Dataset 3: icedid
**Dataset Description:** Cobalt Strike, Delay 300s, Jitter 99%, http 8080; ScreenConnect, Long connection, tcp 443; CSharp-Streamer Long connection, http 80

To view this dataset, run the following:
<pre>rita view icedid</pre>

<br>

### Dataset 3 Questions
1. Which internal host IP appears in this dataset?
2. Primary external IP:port (Cobalt Strike-like)?
3. What is the beacon score for that entry?
4. Name one long-connection external IP observed.

<hr>

## Dataset 4: randomized_redirectors
**Dataset Description:** Cobalt Strike via multiple redirectors — Delay 5s, Jitter 50%

To view this dataset, run the following:
<pre>rita view randomized_redirectors</pre>

<br>

### Dataset 4 Questions
1. Which internal host IP uses multiple redirectors?
2. Redirector FQDN #1?
3. Redirector FQDN #2?
4. Beacon score to redirector #1?
5. Total connection count (for redirector 1)?
6. Protocol and port used?

<hr>

## Dataset 5: teamviewer
**Dataset Description:** TeamViewer — Egress via TCP 443

To view this dataset, run the following:
<pre>rita view teamviewer</pre>

<br>

### Dataset 5 Questions
1. Which internal host is flagged Critical for TeamViewer activity in teamviewer_view.csv
2. How many connections are recorded for the Critical TeamViewer entry
3. How many total kilobytes are reported for the Critical TeamViewer entry
4. What is the exact Port:Proto:Service string for the Critical TeamViewer entry
5. RITA also shows a High-severity flow from the same host to a public IP over TeamViewer’s well-known port with a 0% beacon score. What destination IP and port are used in that entry
6. How many total megabytes moved over that TeamViewer port (from Q5) in that single entry

<hr>

## Dataset 6: specula
**Dataset Description:** Hijacks Outlook, egress via HTTPS tcp 443

To view this dataset, run the following:
<pre>rita view specula</pre>

<br>

### Dataset 6 Questions
1. One host shows an extremely high connection count (34,873) to an external IP with a rare signature ACMS/1.0. What is the destination IP?
2. A High-severity entry shows a very low Beacon Score (0.087) despite a very long total duration (>79,000 seconds). What FQDN was contacted?
3. A Medium-severity flow goes to an external IP on a non-standard high port (32526) and is tagged with a mime_type_mismatch. What was the full Port:Proto:Service string for this entry?
4. One entry shows Outlook communicating with its cloud infrastructure and includes a rare signature revealing a User-Agent string with an Office/Outlook build. What is the exact rare signature value?
5. An entry (Severity: None) shows a Microsoft delivery host (1a.tlu.dl.delivery.mp.microsoft.com) transferring an unusually large volume of bytes (~78 million), flagged with a mime_type_mismatch. What is the exact total megabytes value shown in the dataset?
6. One entry (Severity: None) shows communication with an external IP over port 443 but with two different protocols listed (UDP + TCP). What is the destination IP?

<br>

## Dataset 7: rdp_msdt (rdp_ms_dev_tunnels)
**Dataset Description:** Inbound RDP connection tunnelled via outbound MS Dev Tunnels, tcp 443

To view this dataset, run the following: 
<pre>rita view rdp_msdt</pre>

<br>

### Dataset 7 Questions
1. Which external IP is contacted with the rare signature ACMS/1.0, generating nearly 35,000 connections?
2. One High-severity entry shows a Beacon Score of 0.23, despite a long connection duration of over 85,000 seconds. What FQDN was contacted?
3. Which entry shows a single connection moving over 300,000,000 bytes of data to a Microsoft domain (*.visualstudio.com)? Provide the FQDN.
4. An entry communicates with the same suspicious IP (168.63.129.16) but on a non-standard port (32526). What modifier is attached to this connection?
5. Two None-severity flows go to unusual external IPs (143.198.3.13 and 70.24.242.145) on strange ports (8808 and 7707). What is the total connection count for the 143.198.3.13 entry?
6. At the bottom of the dataset, one entry shows communication with an external IP where the same destination port (443) is listed with both SSL and UDP. What is the destination IP?

<hr>

## Want More RITA Practice?
Below are some commands to download and process other Zeek datasets.

<pre>mkdir icmplogs</pre>

<pre>cd icmplogs</pre>

<pre>wget https://acm-motd.s3.us-east-1.amazonaws.com/zeek_icmp_gosh_24hr.zip</pre>

<pre>unzip zeek_icmp_gosh_24hr.zip</pre>

>[!Note]
>You can use a tool like 7zip if you like it better!

rita import --logs=./ --database=icmpgosh

rita list

rita view icmpgosh

