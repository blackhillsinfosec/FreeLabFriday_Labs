![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Web Testing

# Windows VM

In this lab we will be standing up a simple **Python Web Server** and a vulnerable web server called **DVWA**.  These are designed from the ground up to teach people about a number of web application attacks.

While a full intro to web attacks is out of the scope of this class, it is great to show you how to use tools like **ZAP** to automatically look for some vulnerabilities, and to show you that automated tools do not always catch everything.

You will need to start an **Linux** terminal.




- **Double-click** `Ubuntu Shell` on Desktop

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/196f7867-877b-4a37-bc02-1214e50e96a5" />






Navigate into the proper directory:

```bash
cd ~/Intro_To_SOC/Web_Testing
```

Please note your **Linux** IP:

```bash
ifconfig
```

<img width="1534" height="372" alt="Get_IPLinuxFromWindows" src="https://github.com/user-attachments/assets/03a424b9-3dcd-4d64-a2eb-4f9e2282b1e2" />


>[!NOTE]
>
>**YOUR IP WILL BE DIFFERENT!**

Launch the python script

```bash
python3 ./dsvw.py
```

<img width="696" height="141" alt="2026-03-14_14-38" src="https://github.com/user-attachments/assets/a74a0640-3091-4182-89d8-e595141f31e7" />


It's time to start **ZAP**! Go ahead and launch it from the desktop icon.

<img width="77" height="97" alt="2026-03-14_14-26" src="https://github.com/user-attachments/assets/29673ac5-f788-453c-8f79-e7291bf7b329" />

Once **ZAP** loads, you will see this pop-up on your screen. Ensure that **No, I do not want to persist this session at this moment in time** option is selected, and hit **"Start"**

![](attachments/nopersist.png)

Let's do a quick test of the **Python Web Server**:

Select **"Automated Scan"**

![](attachments//automatedscanselect.png)

Put in **your** Linux IP and port **"65412"** in as the URL to attack.

<pre>http://[YOUR LINUX IP]:65412</pre>

Then, select **"Use traditional spider"** and then select **"Attack"**:

![](attachments/AutomatedScanSetup.png)


>[!IMPORTANT]
>The scan will probably break **DSVW**, you might have to start it again during during the scan:

<img width="697" height="426" alt="2026-03-14_14-41" src="https://github.com/user-attachments/assets/f155ab76-3722-445a-9f4b-0cb18ea0e37c" />



Scan progress will be shown by the progress bar in the center of your screen.
When it gets done crawling and scanning, select **"Alerts"**:

![](attachments/Alerts.png)

This shows that **ZAP** does a pretty good job of finding the easy to identify vulnerabilities.

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ACHCEIntroClass/ACHunterCE.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/Sysmon/Sysmon.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---




<!--

REMOVED PER JOHNS REQUEST


#OPTIONAL DVWA LAB!

Let's get started by opening a Terminal as Administrator

![](attachments/Clipboard_2020-06-12-10-36-44.png)

When you get the User Account Control Prompt, select Yes.

PS C:\Users\adhd> `docker run --rm -it -p 80:80 vulnerables/web-dvwa`

![](attachments/Clipboard_2020-06-16-13-29-31.png)

In another Command Prompt window run ipconfig and record your IP address.  Remember, your IP address may be different from mine.

C:\Users\adhd>`ipconfig`


![](attachments/Clipboard_2020-06-16-13-29-46.png)
Now, let's start Chrome and play with DVWA. Please note that our class has a track record of DoSSing the Docker download for this section.  I recomend doing this after class when less than 100 people are hitting it at the same time.

![](attachments/Clipboard_2020-06-16-13-31-13.png)

When your browser runs, it usually connects to the Internet directly.  In this lab, however, we need it to connect to a local proxy (ZAP) to intercept and attack the web traffic.  To do this, we need to configure Chrome to use ZAP as the proxy.

Now, lets configure the proxy:

![](attachments/Clipboard_2020-06-16-13-32-34.png)



 Now, we will need to surf to your IP address.  You recorded it above with the ipconfig command. Simply put http://<YOUR_IP> into the browser.

You will get an error.  This is normal.  This is because the traffic is being intercepted by a proxy.  Normally, this would be very, very bad.   However, in this lab, we are proxying the traffic to test the app.  Go ahead and select Advanced:

![](attachments/Clipboard_2020-06-16-13-33-08.png)
Then, select Proceed.

![](attachments/Clipboard_2020-06-16-13-33-19.png)

The credentials are admin:password

Please log in.

For the first run, you will need to configure the database. 

Please select Create / Reset Database

![](attachments/Clipboard_2020-06-16-13-34-28.png)

Now, log back in

IF you go back to ZAP you will see that it is capturing the site data.  We could do this manually.  Simply clicking every page.  But, that would take a long time.  We can have ZAP do this for us automatically.  This is called crawling or spidering a website.

Now, from ZAP lets spider the app:

![](attachments/Clipboard_2020-06-16-13-35-51.png)

When the pop-up hits, select Start Scan

While scanning a site for links is cool.  We want to actively scan the site for vulnerabilities.   ZAP can do this as well.  This is called an active scan.

Now, let's start the active scan:

![](attachments/Clipboard_2020-06-16-13-36-47.png)

When prompted, select Start Scan

Scan Running:
![](attachments/Clipboard_2020-06-16-13-37-27.png)

When done, select Alerts

![](attachments/Clipboard_2020-06-16-13-39-33.png)

Did it find anything interesting?  Here is a problem with simply trusting automated tools. They tend to miss things.  Sure, it is great for finding the "easy" stuff.  But, they don't catch everything.  Not even close. 

What vulnerabilities did your scan find? Share them with others on Discord.  Did they find anything different?

If so, why do you think that is?


I wanted to take a few moments and show you some things the scanner may have missed.

Let's see if it missed anything..

Here is just one example.

![](attachments/Clipboard_2020-06-16-13-41-13.png)

`%' or '0'='0' union select user, password from dvwa.users #`

![](attachments/Clipboard_2020-06-16-13-44-15.png)
-->
