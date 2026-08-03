![image](/FilesForLabs/images/blueantisyphon.png)

---

This is a lab from **John Strand**'s **Information Security Core Skills** Course:

https://www.antisyphontraining.com/product/information-security-core-skills-tm/

---

# Password Cracking

# Ubuntu VM

### Lab Objective
In this lab we will be getting started with the fundamentals of password cracking.  We will be using **Hashcat** to do this.

Before we begin, let's delete any old leftover pot files

```bash
rm ~/.local/share/hashcat/hashcat.potfile  
```

If you get an error that the file does not exist, that is fine. It just means the file does not exist. Carry on.
<hr>

## Step 1: Attempt To Crack MD5 Hashes
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

<img width="2288" height="994" alt="img1" src="https://github.com/user-attachments/assets/32be0203-98e3-4718-ae2a-307df15cb1a7" />

<img width="1253" height="1018" alt="img2" src="https://github.com/user-attachments/assets/2e343326-6910-4a4d-9e4f-c29892cea473" />

<br>

Lets crack some NT hashes.  These are the hashes that almost all modern **Windows** systems store these days.  Older systems may store **LANMAN**, but that is very rare.

Lets run the following command:

```bash
hashcat -a 0 -m 1000 -r/usr/share/hashcat/rules/Incisive-leetspeak.rule sam.txt password.lst
```

When this command is complete, it should look like this:

<img width="1158" height="347" alt="img1" src="https://github.com/user-attachments/assets/37d01dca-7ffd-4dc3-a88e-5212d88b40d7" />

<img width="573" height="329" alt="img2" src="https://github.com/user-attachments/assets/7f20975c-c121-406d-937d-e251455166fe" />


***                                                                 
<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---





