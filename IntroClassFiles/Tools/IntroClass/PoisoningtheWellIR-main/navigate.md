# Poisoning the Well - Incident Response Labs
### Lab Objective
In this lab, we will navigate through log files that simulate an attack on a corporate domain. Our goal is to illustrate how to investigate attack logs. Detecting initial intrusion to Domain Admin, we are going to explore the techniques used by threat actors and how we can detect a breach. This walkthrough utilizes [MERlin](https://github.com/her3ticAVI/MERlin/tree/main), [Sysmon](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon), [Wireshark](https://www.wireshark.org/), and any text editor to conduct our investigation.

Download the [logs](https://data.bhislabs.com/PTWLogs.zip) to follow along.

<hr>

## Lab 1 - A Concerning Report

*This lab will require the WS-4 Sysmon, Security Log, and the ws-4_activity to follow along.*

### Lab 1 Objective
In this walkthrough, we will examine log files extracted from Jane Ross's workstation following her submission of a ticket concerning suspicious behavior on her computer.

Our objective is to uncover any suspicious activity and identify potentially malicious executables that have been run on her workstation in the past seven days, coinciding with the onset of the workstation's unusual behavior. We are looking for any abnormal file executions that may have taken place.

![sysmon](./images/sysmon_word.png)

*Upon reviewing the Sysmon log file, we've identified that an executable named *Word.exe* has recently initiated connections to an external IP address from Jane's workstation.  [Event ID 3](https://www.blackhillsinfosec.com/a-sysmon-event-id-breakdown/) is a Sysmon Event ID that indicates a network connection originating from 10.0.0.9 and connecting to an external IP at 13.107.226.40. There is also a note that states the event is masquerading, a sign of deception.*

Jane denies any knowledge of installing a program called Word.exe but claimed she uses "word" all the time. If Jane is unaware of this software installation, it suggests that someone or something else may have downloaded and executed it. But what could be an alternative method for an executable to be downloaded and ran?

### Inspect Jane's Network Traffic
Before the investigation takes a turn for the worse, let's inspect some network traffic from Jane's workstation to see if there is any evidence to support the idea that Word.exe is a malicious file. Malicious files often times have different motives. Malicious files often beacon out to a *C2* or *Command and Control* server so that an attacker can have remote access to a network in order to further aforementioned motives. This will create network traffic that we can capture and review.

![pcap and wireshark](./images/wiretheshark.png)

*There is a substantial amount of traffic originating from 10.0.0.9 to 13.107.226.40. There is a consistent network connection and communication taking place. This is a concerning situation as there appears to be no justifiable reason for prolonged communication with this source address and destination address.*

### Inspect Jane's Security Logs
Lets look at Jane's workstation security logs to see if we can see any commands being issued and recorded in events. 

First, filter for new process creations.

![bad events](./images/setting_filter.png)

Click "OK" at the bottom right and continue.
Now we should see new processes being created, filter through these and look for anything of interest.
After digging through files you will find Word.exe and when it executed, take note of the time stamp.

![word.exe](./images/word_runs_exe.jpg)

To gain more insight into Jane's activities before Word.exe was executed, lets move backwards from here, and look for any programs that were open.

![uhohmacro](./images/moments_before_wordexe.PNG)

We can see that Jane was using Microsoft Word before the Word executable ran. This helps us infer that whatever Microsoft Word did somehow contributed to the files download and execution. Sometimes attackers will stick malicious code into Word documents to run programs that the user would not suspect. We will inspect Janes Sharepoint logs to see what has been happening in the word documents within her Sharepoint. If something malicious has occurred we should be able to track down the cause within Sharepoint Logs. Jane said she downloaded a file called "HRcomplaint something..." before the weird things started happening.
<hr>

## Lab 2 - There's Something In The Water

*This lab will require the audit.log file to follow along.*

### Lab 2 Objective
In the last lab, we found a suspicious file on Jane's workstation. During our investigation, we noticed that Jane had opened Microsoft Word shortly before Word.exe ran. When we asked Jane if she had recently downloaded or opened any Word documents, she mentioned that she had opened a Word file from her [SharePoint](https://www.microsoft.com/en-us/microsoft-365/sharepoint/collaboration).

As investigators, we have a couple of options. <br>

We can either analyze the Word document she opened to understand its content better, or we can examine audit logs to track the activities of users in SharePoint.

### Investigate Sharepoint Audit Logs

Because of the wider view that logs give us, we will look at the Sharepoint audit logs.

![a strange exchange](./images/two_todds.PNG)

We can see that one of the most recent changes was made by Todd Lee. Todd logged in and then edited the file for an unknown reason. At first glance this is normal behavior. After all, SharePoint was built for collaboration... right?

![uhoh](./images/real_todd.PNG)
![italwaysgetsworse](./images/evil_todd.PNG)

After closer examination, we can see that the IP address responsible for the login and the one used to upload the file are different. However both events occurred within a two-minute time frame, Todd logged in from two different locations, and while possible is not probable.

Jane has disclosed that the file she downloaded was an HR complaint that needed to be updated and signed. 

![hrmoment](./images/janes_poisoned.PNG)

The file uploaded from Todd's compromised account was an HR complaint document. An attacker may have found a [Macro](https://support.microsoft.com/en-us/office/protect-yourself-from-macro-viruses-a3f3576a-bfef-4d25-84dc-70d18bde5903) in the Word document and replaced it. When Jane downloaded the seemingly previously trusted document, malicious code inserted by the threat actor in Todd's account was run, effectively poisoning the well. Anyone that downloaded and opened the file has also likely been compromised.

The attacker also got access to Jane's account and the network by poisoning the well. As investigators, we know that an attacker will not stop at compromising one host. A threat actor's kill chain will include trying to gain more access and privilege than they currently have. Our next step is to search for evidence of privilege escalation within the domain.
<hr>

## Lab 3 - Kerberoasting

*This lab will require the DC-1 Sysmon and Security Logs to follow along.*

When an attack occurs, there are [phases to most attacks](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html) that usually happen. 

We saw the attacker gained entry into a workstation by using a Word Macro. The next route the attacker will utilize is privilege escalation.

We received reports of some unexpected [Kerberos ticket](https://learn.microsoft.com/en-us/windows-server/security/kerberos/kerberos-authentication-overview) requests originating from Jane Ross to an [SPN](https://learn.microsoft.com/en-us/windows/win32/ad/service-principal-names) admin account.

### Examine The Sysmon Log
Let's open our Domain Controller security log and Sysmon log to see if we can find some unexpected Kerberoast ticket requests.

There's an important event in the security log to note.

![kerberoastspotted](./images/kerberoast_spotted.PNG)

Jane's account obtained a Kerberoast Service Ticket from Joan King, who as an admin, had created a service principal, most likely by installing software somewhere on the domain. Now, there was no legitimate reason for Jane to request a ticket, and this likely confirmed that the attacker successfully Kerberoasted and has potentially escalated privileges to a higher-level account.

The use of encryption type [0x17](https://redsiege.com/tools-techniques/2020/10/detecting-kerberoasting/) is noteworthy. This encryption type is often easier to crack, serving as another sign of a potential Kerberoasting attack. While this detail alone may not definitively indicate an attack, when combined with other pieces of evidence, it helps us build a more comprehensive picture.

To confirm this, we can cross reference Sysmon logs to see any network requests for SPN accounts in Active Directory. However, there were no significant logs within Sysmon that indicated any malicious activity. Overall, It is always important to verify suspicions by cross-referencing multiple logs and sources.
<hr>

## Lab 4 - DC Sync

*This lab will require the DC-1 dc-1_incident PCAP to follow along*

We've received reports suggesting a potential [DC Sync attack](https://blog.blacklanternsecurity.com/p/detecting-dcsync) on our Active Directory. It's been confirmed that the attacker has managed to access an admin account, likely via Kerberoasting. With the occurrence of an unplanned DC Sync, it's highly likely that the attacker has successfully cracked this hash. Joan has informed us that her password was "Summer2023!" - an easily crackable password.

It's plausible that the attacker used the compromised admin account to initiate a DC Sync, thereby gaining access to all user accounts and their corresponding NTLM hashes within our Active Directory. However, before we conclude this, let's conduct thorough investigation by reviewing the PCAP capture and the Domain Controller Logs to discover the full extent of the breach.

When searching logs for a DC Sync, Event ID 4662 can help you filter down logs. DC Sync accesses Directory service objects, which are logged under Event ID 4662. But there is a problem, these event logs are extremely generic and don't reveal much information. The bulk of the important information will be in a network capture.

Looking at Wireshark we can see a few things that hint at a DC Sync.

![sussy](./images/sus_burst.PNG)

The information on the right side of the Wireshark window provides an overview of the network traffic. Healthy traffic typically shows a consistent, pulsing rhythm, resembling a zebra stripe pattern with small variations. In this particular PCAP file, a significant network event occurred. Let's investigate this further.

![DC/ERP](./images/dcerp.PNG)

The protcol that has caused us some concern is [DCE/RPC](https://en.wikipedia.org/wiki/DCE/RPC). This protocol indicates something is happening with the Domain Controller and it is likely that a [DCSync attack](https://blog.nviso.eu/2021/11/15/detecting-dcsync-and-dcshadow-network-traffic/) is taking place.

![uhoh](./images/dsbind.PNG)

The DSBind request followed by a DSGetNCChanges response can be a legitimate network event, as it is part of the normal operation of a Windows Domain Controller. The danger level of these requests largely depends on whether they are part of a planned and authorized action or if they occur unexpectedly.

If the IT team planned and executed a DC Sync for a legitimate  purpose, then there is no threat, and it does not necessarily indicate a compromise. Examples of legitimate use cases include administrative tasks, migrations, or routine maintenance.

If the DSBind request and DSGetNCChanges response occur unexpectedly and without authorization, it could indicate a security incident and Active Directory breach.

The results are grim, IT has informed us that there was no scheduled DC Sync. It looks like our attacker has taken control of the entire domain.
