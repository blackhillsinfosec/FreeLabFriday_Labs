![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Spidertrap

# Ubuntu VM

Website
-------

<https://github.com/adhdproject/spidertrap>

Description
-----------

Trap web crawlers and spiders in an infinite set of dynamically
generated webpages.

Install Location
----------------

`~/ADCD/spidertrap`

Usage
-----

```bash
python3 spidertrap.py --help
```
```
Usage: spidertrap.py [FILE]

FILE is file containing a list of webpage names to serve, one per line.
If no file is provided, random links will be generated.
```

## Example 1: Basic Usage

- Let's get started by getting into the proper directory:

```bash
cd ~/ADCD/spidertrap
```

<img width="470" height="46" alt="Screenshot From 2026-03-07 11-35-46" src="https://github.com/user-attachments/assets/5eb14d5e-b9fa-49f0-96ef-8f69caaeba78" />

- Now, lets start Spidertrap by running the following command:

```bash
python3 spidertrap.py
```

<img width="645" height="68" alt="Screenshot From 2026-03-07 11-36-38" src="https://github.com/user-attachments/assets/2a5d40ff-a8be-42b9-8bb1-75d1013a8b00" />


- Then visit the following site in a web browser:

```
http://localhost:8000
``` 

- You should see a page containing randomly generated links. If you click on a link it will take you to a page with more randomly generated links.

<img width="587" height="291" alt="2026-03-07_11-38" src="https://github.com/user-attachments/assets/f255a713-0cb0-483a-abe0-60e6de7311a8" />

<img width="599" height="363" alt="2" src="https://github.com/user-attachments/assets/ef0d15bb-070d-48b0-96b4-cbcb03b1be8b" />


## Example 2: Providing a List of Links

- For this example, we are going to start Spidertrap again, but this time, we are going to give it a file to generate its links.

- Let's start Spidertrap again but with the following options:

```bash
python3 spidertrap.py directory-list-2.3-big.txt
```

>[!TIP]
>
>You may need to press `ctrl + c` to kill your existing Spidertrap session.


<img width="908" height="76" alt="2026-03-07_11-40" src="https://github.com/user-attachments/assets/6c1ee1ea-cd52-4db5-9421-7bd7fdf18abc" />


- Then visit the following site in a web browser:

```bash
http://localhost:8000
```
 
- You should see a page containing links taken from the file. If you click on a link it will take you to a page with more links from the file.

<img width="607" height="281" alt="1" src="https://github.com/user-attachments/assets/f3c4370a-6158-41ab-95e0-ce868ce407c9" />

<img width="617" height="250" alt="2" src="https://github.com/user-attachments/assets/ba81eb09-dfd3-408e-8fd0-47fc7c1ccb1b" />

## Example 3: Trapping a Wget Spider

- For this example, follow the instructions in [Example 1: Basic Usage](#example-1-basic-usage) or [Example 2: Providing a List of Links](#example-2-providing-a-list-of-links) to start Spidertrap. 

- Once Spidertrap starts, open a new terminal

<img width="311" height="52" alt="GetUbuntuTerminalFromUbuntuVM" src="https://github.com/user-attachments/assets/65df2abb-03ca-4f8f-b0db-172de6aaf990" />

- We are going to use `wget` to mirror the website. 

>[!IMPORTANT]
>
>`wget` will run until either it or Spidertrap is killed.
>To stop the command output, type `ctrl + c`

- Let's run the following command:

```bash
sudo wget -m http://127.0.0.1:8000
```


<img width="863" height="985" alt="2026-03-07_11-47" src="https://github.com/user-attachments/assets/08551cbe-44fb-4e41-96f5-ca2435dcab41" />


- When finished, type `ctrl + c` to kill wget

***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/Cowrie/Cowrie.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
