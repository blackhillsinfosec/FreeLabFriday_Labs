![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Nessus Lab

In this lab we will be looking at a vulnerability report.

However, we will be looking at it in a different way.  We will not be looking at the **"Highs and Criticals"**.  Instead, we want to focus on the **"Lows and Mediums"**.  We are doing this because these are often the vulnerabilities we exploit and are often missed by the organizations we test.

Specifically, look at service headers and files.

To open this lab, start file explorer:

<img width="534" height="48" alt="OpenFileExplorer" src="https://github.com/user-attachments/assets/e185c888-7dfb-4add-ae73-55c4c9b4278f" />

Then, navigate to the tools folder and open the **NessusLab** file:

![](attachments/Navintolabs.png)

<img width="1118" height="555" alt="2026-02-23_12-43" src="https://github.com/user-attachments/assets/99d6da3e-9545-46b2-9427-e5ef7fa35bab" />

When the file opens, please focus on service banners and files.

![](attachments/nessus_home.png)


Now, we are going to have you hunt for **"Low and Medium"** Vulnerabilities that needed to be addressed.

No cheating...
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
Seriously...
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
\
Ok.

Below is the Telnet server that has issues.

Notice that it is a prompt.  This means there is no authentication to access this server. 

![](attachments/nessus_telnetserver.png)

Note that two of the servers require authentication and one does not.

Check out the office files shown with the web server sitemap:

![](attachments/nessus_officefiles.png)

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/Nmap/Nmap.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/deepbluecliIntroClass/DeepBlueCLI.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---




