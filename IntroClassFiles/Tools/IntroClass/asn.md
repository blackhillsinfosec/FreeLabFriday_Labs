
![image](/FilesForLabs/images/blueantisyphon.png)

# Understanding ASN's
### Lab Objective

In this lab, we will get familiar with what Autonomous System Numbers (ASN’s) are and how they work.

Think of an ASN as a ZIP (or postal code) on the Internet.  <br>
When you send packets out on the Internet they get routed to the router that is advertised to have responsibility for that part of the Internet. 

We can take a list on known bad IP addresses and do a count on which ASNs have the most “bad” IP address on them with the following commands.
<hr>

## Step 1: Getting A List of "Bad" IP's
First, let's open an Ubuntu Shell:
![image](/IntroClassFiles/Tools/IntroClass/attachmentsfornewlabs/openshell.png)

Now, let's pull down an open source list of "bad" IP addresses:

<pre>wget https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt</pre>

![image](/IntroClassFiles/Tools/IntroClass/attachmentsfornewlabs/wget.png)
<hr>

## Step 2: Finding The Associated ASN's
Next, let's pull the ASN each of those IP addresses is associated with:

<pre>netcat whois.cymru.com 43 < ipsum.txt | grep -v "AS Name" > asn_merge.txt</pre>

![image](/IntroClassFiles/Tools/IntroClass/attachmentsfornewlabs/netcat.png)

## Step 3: Analyze The Data
Now, let's do a quick count and sort on those ASNs and the number of "bad" IP addresses per ASN:

<pre>awk -F"|" '{ print $1, $4 }' asn_merge.txt | sort | uniq -c | sort -nr | less</pre>



The first column is the count of “bad” IP addresses in the ASN and the second column is the ASN number.

See how quickly the number of “bad” IP addresses drop off?  

