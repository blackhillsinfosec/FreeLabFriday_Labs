![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Password Cracking

# Ubuntu VM


In this lab we will be getting started with the fundamentals of password cracking.  We will be using **Hashcat** to do this.

After you open a terminal, we need to gain root access by running the following:

Now, let's delete any old leftover pot files

```bash
rm ~/.local/share/hashcat/hashcat.potfile  
```

If you get an error that the file does not exist, that is fine.  It just means the file does not exist.  Carry on.

We need to navigate to the appropriate directory. Run the following:

```bash
cd ~/Intro_To_Security/Password_Cracking
```

Lets begin by attempting to crack some **MD5 hashes**. 

Run the following command:

```bash
hashcat -a 0 -m 0 -r /usr/share/hashcat/rules/Incisive-leetspeak.rule MD5.txt password.lst
```

The result will look like this:

<img width="1335" height="838" alt="2026-02-10_13-54" src="https://github.com/user-attachments/assets/65ce6739-e080-4861-93c8-2ff424d6c497" />


Lets crack some NT hashes.  These are the hashes that almost all modern **Windows** systems store these days.  Older systems may store **LANMAN**, but that is very rare.

Lets run the following command:

```bash
hashcat -a 0 -m 1000 -r/usr/share/hashcat/rules/Incisive-leetspeak.rule sam.txt password.lst
```

When this command is complete, it should look like this:

<img width="1333" height="821" alt="image" src="https://github.com/user-attachments/assets/af468a02-3513-4705-ac6d-ceba91684ad2" />


***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/PasswordSpray/PasswordSpray.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/Nmap/Nmap.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---





