![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **SOC Core Skills** Course:

https://www.antisyphontraining.com/product/soc-core-skills-with-john-strand/

---

# Firewall Log Review

# Ubuntu VM

In this lab we will be looking at a log with r-base-core from an **ASA firewall** from Cisco. 

**And wow....  They are bad to work with.**

With the power of **Bash scripting** we can get some useful information.

Next, let's get your **Linux** system to do some math!

Open a terminal

We need to navigate to the correct directory with the following command:

```bash
cd ~/Intro_To_SOC/firewall_log
```

Let's look into the logs.  The logs file is quite extensive, so in order to narrow our scope, we will use **"grep".**

```bash
grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | less
```

<img width="1919" height="1061" alt="2026-03-23_12-17" src="https://github.com/user-attachments/assets/ad255b73-60b0-4bbb-92c1-e33039d56e19" />


**That is a nightmare...**

Not only is there a ton of information here, you might now feel like you are stuck in your terminal window.

No worries though, just hit **"q"** to return to your terminal.

Let's refine the output a little more by running the following command:

```bash
grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | cut -d ' ' -f 1,3,4,5,7,8,9,10,11,12,13,14
```

This command focuses on the closed connections **(FIN)** and pull just specific fields out of the data to clean it up.   We use cut with the **"-d"** switch to specify the delimiter, which is a space.  Then, we tell it what fields or columns of the output we are interested in. 

When it is all put together, our output looks something like this:

<img width="1238" height="333" alt="2026-03-23_12-19" src="https://github.com/user-attachments/assets/bcb1a577-46f5-4d17-9f17-e479075f5f37" />


It's looking a lot better, but I think we can do better. But how?

If you look at our previous output, you may notice that outside connections are being made to two different addresses:
**"13.107.237.38"** and **"18.160.185.174"**

So why don't we look at just the connections made to **"13.107.237.38"** by running the following command:

```bash
grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | grep 13.107.237.38 | cut -d ' ' -f 1,3,4,5,7,8,9,10,11,12,13,14
```

<img width="1850" height="865" alt="2026-03-23_12-21" src="https://github.com/user-attachments/assets/a91d273b-fff1-4a99-b6ff-91b4d2f7ec71" />



This output shows us all of the data coming from **"13.107.237.38"**

Don't forget, there were also a lot of connections from **"18.160.185.174"**.  Here, let's zoom in on that IP as well:

```bash
grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | grep 18.160.185.174 | cut -d ' ' -f 1,3,4,5,7,8,9,10,11,12,13,14
```

<img width="1248" height="754" alt="2026-03-23_12-24" src="https://github.com/user-attachments/assets/37716c89-26bf-4ebe-ad70-1aca4872042a" />


Look at the last field.  See a pattern?  Is there one?  Let's see just that field!

```bash
grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | grep 18.160.185.174 | cut -d ' ' -f 14
```

All we should see now is this:

<img width="1594" height="901" alt="2026-03-23_12-24_1" src="https://github.com/user-attachments/assets/1ed40f1f-2518-4955-b374-f4d1215f8389" />


Now let's do some math in that field!

```bash
grep 192.168.1.6 ASA-syslogs.txt | grep -v 24.230.56.6 | grep FIN | grep 18.160.185.174 | cut -d ' ' -f 8,14 | tr : ' ' | tr / ' '  | cut -d ' ' -f 4 | Rscript -e 'y <-scan("stdin", quiet=TRUE)' -e 'cat(min(y), max(y), mean(y), sd(y), var(y), sep="\n")'
```
 
Your output should look something like this:

<img width="660" height="158" alt="2026-03-23_12-26" src="https://github.com/user-attachments/assets/87f020f7-c0fe-4987-913e-1c96ef9761d1" />


There are a lot of commands you can use to alter your view of the logs.  

***                                                              

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/Velociraptor/Velociraptor.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---



