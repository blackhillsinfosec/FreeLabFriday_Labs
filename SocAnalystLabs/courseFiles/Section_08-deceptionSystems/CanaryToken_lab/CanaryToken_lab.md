![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Deploying a JS Cloned Website CanaryToken

# Any VM

## Step 1: Create the CanaryToken

Go to:

[https://www.canarytokens.org/nest/](https://www.canarytokens.org/nest/)

Choose **JS Cloned Website**  

![JS Cloned Website](Pasted%20Graphic.png)

Enter a domain of your choosing, and the email and notification method you want to receive.  

![Configure Token](Pasted%20Graphic%201.png)

---

## Step 2: Set Up the Honeypot on MetaCTF Windows + Linux VM



- Open **Command Prompt**

<img width="85" height="103" alt="image" src="https://github.com/user-attachments/assets/b2c7dbad-d57b-40d0-9318-ca8d40176c22" />

- **SSH** into the **Linux** machine
```bash
ssh ubuntu@linux.cloudlab.lan
```
<img width="270" height="22" alt="image" src="https://github.com/user-attachments/assets/87dd5663-83a3-4dd3-ae6e-3e9bb1deb2dc" />


Become root:
```bash
sudo su -
```

Navigate to the honeypot directory:
```bash
cd /opt/owa-honeypot
```
<img width="453" height="46" alt="image" src="https://github.com/user-attachments/assets/50ed0c06-534c-41dd-9682-a54e3e54f1d2" />


> **Note:** This directory contains the core components of the OWA honeypot.  
> `owa_pot.py` is the main Flask app that mimics an OWA login page and logs credentials.  
> `dumpass.log` stores login attempts (username, password, IP, and user-agent).  
> `requirements.txt` lists Flask as the only dependency.  
> `templates/` holds the fake login and error HTML pages.  
> `env/` is a virtual environment folder.  
> `instance/` is used by Flask for local configs.  
> `README.md` provides setup and usage details.

## Step 3: Inject the CanaryToken JavaScript

Change into the `templates` directory:
```bash
cd templates
```
<img width="628" height="211" alt="image" src="https://github.com/user-attachments/assets/93200b98-1b31-4980-af3a-2d845edcd1cf" />



Edit the `outlook_web.html` template using `nano`:
```bash
nano outlook_web.html
```

After the `<head>` tag, add a line with:
```html
<SCRIPT>
```

Then go back to your CanaryToken page and copy the JavaScript snippet.  

<img width="472" height="360" alt="image" src="https://github.com/user-attachments/assets/8200dd34-ff9d-4a41-a1d5-12e7e2637fce" />


>[!IMPORTANT]
>
> ⚠️ **Do NOT close the CanaryToken page after copying the JavaScript!**

Paste the script into the `nano` editor.  

<img width="896" height="248" alt="image" src="https://github.com/user-attachments/assets/cbd36ff2-0d1c-4886-bedb-54edd10ca3f4" />


Then add the closing `</SCRIPT>` tag.  

<img width="896" height="272" alt="image" src="https://github.com/user-attachments/assets/0f914fc2-f504-4c03-b119-831edd4296c7" />


Save the file:

- Press `Ctrl + O`
- Hit `Enter`
- Exit with `Ctrl + X`

Navigate back to the previous directory:
```bash
cd ..
```
<img width="745" height="45" alt="image" src="https://github.com/user-attachments/assets/2d5af590-8bf3-48c4-88fb-925415eece75" />


Start the honeypot server:  

<img width="897" height="210" alt="image" src="https://github.com/user-attachments/assets/cc2d8971-41fb-4b85-b554-2e10fdfe5556" />


---

## Step 4: Monitor Token Activity

Return to the CanaryToken page. Scroll down and click on **Manage Canarytoken**. 

![Manage Token](Pasted%20Graphic%209.png)

You should see that the token has **not** yet been triggered. 

![Not triggered yet](Pasted%20Graphic%2010.png)

---

## Step 5: Trigger the Honeypot

Any good hacker will try and test their site.

Back on the Windows system, open a browser and visit the honeypot site.  
![Visit site](Pasted%20Graphic%2011.png)

Return to your CanaryToken management page and refresh it.

Your token should now be triggered!
 
![Token triggered](Pasted%20Graphic%2012.png)  

![Alert](Pasted%20Graphic%2013.png)

---
[Back to the Section](/SocAnalystLabs/courseFiles/Section_08-deceptionSystems/deceptionSystems.md)
