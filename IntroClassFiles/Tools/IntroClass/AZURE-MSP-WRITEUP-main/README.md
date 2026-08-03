![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **Information Security Core Skillss** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Azure AD Lab - Hackable MSP
### Lab Objective
In this lab we will navigate through log files of an attack simulation on an MSP to illustrate how an attacker got in and compromised the network. From initial intrusion all the way to full network exploitation, we are going to explore the techniques used by the attacker(s) and how they were able to compromise our Azure MSP
<hr>

## Lab 1 - Initial Intrusion
### Azure login activity logs

[*Download the log file to follow along*](./logs/InteractiveSignIns_Domain_spray_logs.csv)

In this **walkthrough** we will be taking a look at a log file that was pulled from **Azure**.

[Azure](https://azure.microsoft.com/en-us) is a service provided by Microsoft to move a **Domain** into the cloud. While we know the **Domain Controller** records logins if the user used Azure, we need to pull logs to see the failed, attempted, and successful logins.

Our goal is to find how attackers may have initially accessed our **domain network**.

When we first crack open our log file in **notepad**, we notice a few things. First, this log file contains **IP addresses**. This is useful for us trying to identify which systems are logging into which **account**. This logging supplies the time stamp, the account attempting to be accessed, and how they accessed us. With this in mind let’s continue our investigation.

![Login Times](./images/login_times.PNG)

After scrolling down for a bit, the first thing we should notice is the number of logins all within **seconds** of each other. The chances of every employee attempting to login at the same exact time is nearly **impossible**. This could be an indication that someone is trying to **brute force** login credentials.

Let's look closer at the **remote IP addresses**. If they're all the same IP that can give us an indication that either one person is trying to login to all of these accounts or that all the employees are logging in from the same network **(possible, not probable)**.

![Login IPs](./images/login_ips.PNG)

All of these **logins** that are within a few seconds of each other come from the same exact **IP**. If you look closer, you can see that **almost all** attempts failed.

That is not a good sign.  That means that someone was doing a [brute force spray attack](https://owasp.org/www-community/attacks/Password_Spraying_Attack) at our **domain**. But there's nothing to worry about as long as no user got compromised right?

Let's go through the logs and make sure all attempts are **failed** before we escalate this incident.

[Found Creds](./images/found_creds.PNG)

It looks like **Paul Bowman’s** password was discovered by an attacker during this domain spray. Did the attacker realize that the password was correct and log in? Let's look above all the attempted logins for any activity from **Paul Bowman**.

![successful login](./images/successful_login.PNG)

It looks like the attacker found his way into the domain through **Paul Bowman's** login information. We can see the success message from a login attempt to the domain.

>[!IMPORTANT]
>Always when an attack has occured, look for **persistance** and **lateral movement**, ALWAYS!

<hr>

## Lab 2 - Machine Pivoting
### Suspicious Executables and Workstations

[*Download the log file to follow along*](./logs/ws-3-security.csv)

After the discovery of the compromised user, **(Paul Bowman)**, we decided to go through the security logs of each workstation to look for any suspicious files being run or used by other users.

The compromised user may try to **pivot** to other computers and try to gain access to other systems. [Pivoting](https://www.geeksforgeeks.org/pivoting-moving-inside-a-network/) is a technique used by an attacker to try to compromise additional systems and try to escalate there privileges from a regular user to an **administrator**. So, where do we start? **Workstation 3** has suspicious activity in its security log files we should take a look at.

>[!NOTE]
>The log file for this portion is a different file. Please **download** it above.

**Open** the log file in notepad and press `ctrl + f` and type `Process Name:` and hit `Enter` then `Tab` to every executable that has run on the **workstation**.

We are looking for **anything out of the ordinary**. We are starting on process names because it is the most likely attack vendor. If any **malicious files** were ran it may be in the audit logs. As a way to confirm strange behavior.  We should also look to see if the user running the file is anyone other than **Paul Bowman**. This can help us understand if the attacker tried to spread through our network.

![Sysmon Extract All](./images/search.PNG)

After tabbing through the log file and carefully looking over **executables** we should take note of this...

![Sysmon Extract All](./images/find_next.PNG)

At first it may not be totally obvious, but the name seems *slightly* suspicious and is not a normal system file like **mmc** or **event viewer**. It looks like the file was served through a file share on **Workstation 1**, which was the machine that **Paul Bowman** was using. It is also important to take notice of the username, the attacker has moved from Paul into a **new** user. This means the attacker was **pivoting** in this environment.
<hr>

## Lab 3 - Cookie Theft
###



* [Lab 3 - Cookie Theft](./cookie_theft.md)
* [Lab 4 - Full Domain PWN](./rmm_takeover.md)


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/AZURE-MSP-WRITEUP-main/azure_logs.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
