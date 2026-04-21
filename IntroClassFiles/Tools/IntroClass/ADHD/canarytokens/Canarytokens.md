![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Canarytokens 

# Any VM

First, we will need to navigate to the canarytokens server from a system with Microsoft Word on it: 

https://www.canarytokens.org/generate#

Search for ```Microsoft Word```

<img width="1034" height="608" alt="canarytokens_site" src="https://github.com/user-attachments/assets/6601eba1-4dab-4b56-a5d6-7284ac54981b" />

   
Now, let's create a token Word Document: 

<img width="638" height="430" alt="word_token" src="https://github.com/user-attachments/assets/145c6b7c-4aa2-4a36-8d39-3d431962196d" />
  

Then select Create Token. 

  

When you get the next screen, select Download your MS Word File.  

  

Then, download it and open it. 

<img width="640" height="514" alt="MS_word_token" src="https://github.com/user-attachments/assets/cd3f4c7f-ea4a-42ce-8d2f-48a03cca0480" />


Notice that it is just an empty Word document. You can add whatever you want in it. 

  

Now, check your email. 

  

You should have gotten an alert: 

<img width="612" height="1161" alt="ms_token_triggered" src="https://github.com/user-attachments/assets/20591922-35bc-4daa-9c15-cd9b73b6a4e8" />


Now, let's play with the site cloner: 


Search for ```JS cloned website```

<img width="140" height="144" alt="web_clone" src="https://github.com/user-attachments/assets/966e4f1d-9e09-4f98-912f-32c5fbed5f89" />
  

Next, fill in the appropriate fields: 

<img width="606" height="500" alt="web_clone_fields" src="https://github.com/user-attachments/assets/e85a0e4c-7d41-4c95-bb1d-07f2f730897f" />


Now, select Create my Canarytoken. 

  

Now we will need to copy the JavaScript and put it somewhere so it triggers: 

<img width="572" height="604" alt="web_generated_token" src="https://github.com/user-attachments/assets/cadba2ee-abce-4ee7-8a74-6092c6f80034" />


Now, let's test out the JavaScript Canary token. Open a Linux terminal and execute the following command:

```bash
cd ~/ADCD/canaryToken
```

In this directory, we have a HTML file called ```index.html```. In this file, we will write the generated JavaScript token.

Open the HTML file with a text editor and at the very bottom of the file inside the ```<script> </script>``` tags write the generated JavaScript token.

Then, save it and close it.

Now we have a page that has the role of a cloned site. In order to test the functionality of the canary token through this page, we must add a domain to the ```/etc/hosts```.

>[!IMPORTANT]
>
>The domain we will add must be completely different from the domain we gave at the token creation!!
>(e.g. If we gave ```yourorg.com``` as a domain at the token creation, we must give a completely different domain at the new /etc/hosts record like ```clonedsite.com```)

For this purpose, execute the following:

```bash
echo "127.0.0.1 clonedsite.com" | sudo tee -a /etc/hosts
```

<img width="743" height="284" alt="echo_domain" src="https://github.com/user-attachments/assets/9c5c4bf2-42f5-4412-a1ee-b20cdd67e84a" />


Now everything is ready. Time for action!

First things first, we must run a server in order to be able to access our page.

```bash
sudo python3 -m http.server 80
```

Then open a browser and access the domain you just added in the ```/etc/hosts```. In our case:
```
http://clonedsite.com
```

<img width="1276" height="558" alt="test_page" src="https://github.com/user-attachments/assets/0cdf5e00-db1f-4e8b-9a54-9742c7a366d8" />


In a few moments you should get an email alert: 

<img width="565" height="1207" alt="web_token_triggered" src="https://github.com/user-attachments/assets/b48928af-8ad7-4da9-a137-1f0f7bab9060" />

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/GoPhish.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/FakeNet-NG.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
