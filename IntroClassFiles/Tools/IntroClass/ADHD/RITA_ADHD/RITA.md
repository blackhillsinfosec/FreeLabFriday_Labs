![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **SOC Core Skills** Course:

https://www.antisyphontraining.com/product/soc-core-skills-with-john-strand/

---

# RITA Lab


<hr>

## Lab Objective:
In this lab, you will be using **Real Intelligence Threat Analytics** (RITA) to go through 7 different datasets. 
For each one, you will have to answer some questions.

<hr>

Let's begin by opening a Terminal (or Ubuntu Shell).
![image](/IntroClassFiles/Tools/IntroClass/attachmentsfornewlabs/openshell.png)

To view all of the datasets, we can run the following command:
<pre>rita list</pre>

<hr>

## slow_steady_beacon
**Dataset Description:** Cobalt Strike - HTTP, Delay 3s, Jitter 0

To view this dataset, run the following:
<pre>rita view slow_steady_beacon</pre>

<br>

### slow_steady_beacon Questions
1. Which internal host IP is beaconing?
2. What external IP is being contacted?
3. What protocol and port are used?
4. What is the beacon score?
5. What is the connection count?

<hr>

## beacon_jitter 
**Dataset Description:** Cobalt Strike - HTTP, Delay 30s, Jitter 25%

To view this dataset, run the following: 
<pre>rita view beacon_jitter</pre>

<br>

### beacon_jitter Questions
1. Which internal host IP is contacting the FQDN?
2. What FQDN is being contacted?
3. What protocol and port are used?
4. What is the beacon score?
5. What is the connection count?


