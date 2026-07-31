![image](/FilesForLabs/images/blueantisyphon.png)
# RITA Lab
# Ubuntu VM

During these parts you will be going through 7 datasets and you will have to answer some questions for each, you will find the answers if you keep scrolling down

You can view all of them via
```bash
rita list
```

<img width="742" height="242" alt="Screenshot From 2026-03-17 10-53-41" src="https://github.com/user-attachments/assets/11c61de5-a251-428c-b6ec-6b94e290eb08" />

## slow_steady_beacon

**Dataset Description:** Cobalt Strike - HTTP, Delay 30s, Jitter 0
```bash
rita view slow_steady_beacon
```

1. Which internal host IP is beaconing?
2. What external IP is being contacted?
3. What protocol and port are used?
4. What is the beacon score?
5. What is the connection count?


**1. Answer:** 192.168.2.77
**2. Answer:** 143.198.3.13
**3. Answer:** HTTP (tcp 80)
**4. Answer:** 1.0
**5. Answer:** 2853

Please use the Network Ubuntu VM for this lab.

Do these labs first:

https://github.com/doergestim/SOC_Analyst_Labs/blob/main/courseFiles/Section_05-networkingAndTelemetry/rita_lab/ritaLab1.md


Below are some commands to download and process other Zeek datasets.

`mkdir icmplogs`

`cd icmplogs`

`wget https://acm-motd.s3.us-east-1.amazonaws.com/zeek_icmp_gosh_24hr.zip`

`unzip zeek_icmp_gosh_24hr.zip`

Specail note!!!  You can use 7zip if you like it!!!!!!!

`rita import --logs=./ --database=icmpgosh`

`rita list`

`rita view icmpgosh`

Ctrl+c closes the session

Full writreup below:

https://www.activecountermeasures.com/malware-of-the-day-c2-over-icmp-icmp-gosh/

What more???

Like a lot more??

https://www.activecountermeasures.com/category/malware-of-the-day/

b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>
