![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **SOC Core Skills** Course:

https://www.antisyphontraining.com/product/soc-core-skills-with-john-strand/

---

# Web Log Review

# Windows VM

In this lab we will be standing up a vulnerable web server called DVWA.  It is designed from the ground up to teach people about a number of web application attacks.

While a full intro to web attacks is out of the scope of this class, it is great to show you how to use tools like ZAP to automatically look for some vulnerabilities, and to show you that automated tools do not always catch everything.




- Open **Ubuntu Shell**

<img width="90" height="104" alt="Screenshot From 2026-02-23 10-28-37" src="https://github.com/user-attachments/assets/ae6d408b-7622-4545-b849-aef3d8fa0cb4" />



```bash
sudo su -
```

Get your **Linux IP address**

```bash
ifconfig
```

<img width="716" height="175" alt="Get_IP" src="https://github.com/user-attachments/assets/cc1893c9-3a96-4ddb-a16a-45f0bdad0e10" />


```bash
docker run --rm -it -p 80:80 vulnerables/web-dvwa
```

<img width="1102" height="317" alt="image" src="https://github.com/user-attachments/assets/bbb8b00e-1ae1-4896-8ce5-3c9affbc5c79" />


Now, let's start ZAP.

<img width="89" height="96" alt="image" src="https://github.com/user-attachments/assets/551b5e0b-1319-4c68-8619-02f6ae0a02e8" />



![](attachments/Clipboard_2020-06-16-13-30-46.png)

First, select the Automated Scan button: 

![](attachments/Clipboard_2020-12-11-06-43-22.png)

Then enter the URL of your Docker system.  It will be in `http://<LINUXIP>` syntax like below:

<img width="455" height="152" alt="image" src="https://github.com/user-attachments/assets/36a48d43-c0ff-4b65-97db-8e9fb845a00a" />


Then select the Attack button:

![](attachments/Clipboard_2020-12-11-06-45-46.png)

This will start the scan.  You should be able to see the scan activity in the lower part of ZAP.


<img width="947" height="362" alt="image" src="https://github.com/user-attachments/assets/49633ae1-1b42-4664-9950-ca334152e08d" />


Now, let's go back to the **Command Prompt** window and see the logs:

<img width="1106" height="622" alt="image" src="https://github.com/user-attachments/assets/0d8192d6-13b3-4b37-828f-f8b88d461a26" />


What are some things to look for?

First, notice the high number of requests from an IP address in a very, very short time.

Also, look for odd things like below:

![](attachments/Clipboard_2020-12-11-06-52-26.png)

But what would qualify as odd? Let's think this through. First, look at timing. Notice how fast the connections are comming in from a single IP. Also, notice how many of the same connections are going after the exact same thing again and again. Now, lets look for odd encodings. Looking for characters like %. Finally. spend some time getting to know what attacks look like at OWASP.

The key for any SOC analysts is to first learn what is normal log traffic from the apps we monitor. Then, slowly we start attacking and seeing what the different attack patterns look like. There is no simple signature-based detection approach that works for all applications. The security industry has been trying this for years with various levels of success. 

Start by baselining normal. 

Then attack. 

It is all about knowing our networks ad apps.

### Going further

https://owasp.org/

https://www.zaproxy.org/

https://cirt.net/Nikto2

***                                                                 

<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/WindowsCLI/WindowsCLI.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/TCPDump/TCPDump.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---





















