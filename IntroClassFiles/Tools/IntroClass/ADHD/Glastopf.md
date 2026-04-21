![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# Glastopf

# Ubuntu VM

**Goal:** Run a working Glastopf web-application honeypot, generate simple attacks against it, and inspect captured requests and payloads

---

### Start Glastopf container

- Go the its directory

```bash
cd ~/ADCD/glastopf
```

```bash
sudo docker run -d --rm \
  --name glastopf \
  -p 8080:80 \
  -v $(pwd)/data:/var/lib/glastopf \
  -v $(pwd)/logs:/var/log/glastopf \
  decepot/glastopf:latest
```

---

### Verify Glastopf is running and listening

- Check process or Docker container, run:

```bash
ps aux | grep glastopf
```

<img width="1199" height="67" alt="2026-03-23_14-12" src="https://github.com/user-attachments/assets/d782b8fa-8680-4de1-86da-9c5aa1afc750" />


- Tail the main **log**

```bash
sudo docker logs -f glastopf
```

<img width="1247" height="208" alt="2026-03-23_14-14" src="https://github.com/user-attachments/assets/3c969171-b913-4890-a1c3-1048b126ca0e" />

---

## Generate attacks 

- Open another **terminal** (attacker) and try the following. These simulate common web malicious requests.

### Simple directory traversal / LFI attempts

```bash
curl -v "http://localhost:8080/index.php?page=../../etc/passwd"
```

<img width="1059" height="976" alt="2026-03-23_14-19" src="https://github.com/user-attachments/assets/1c0fa528-eaee-4b27-a3f5-1d91c0321ebf" />

```bash
curl -v "http://localhost:8080/?file=../boot.ini"
```

<img width="1904" height="944" alt="2026-03-23_14-22" src="https://github.com/user-attachments/assets/0de57c7c-9c69-4cca-a2b8-39bea7173798" />


- That is how it looks from a **hacker**'s perspective(**fake information**)

- When in reality, all that is **fake** and it is being logged on the **defender**'s side:

<img width="1193" height="57" alt="2026-03-23_14-23" src="https://github.com/user-attachments/assets/81a6f433-fa7b-45b3-9239-4362269c3c42" />

### SQL injection-like payloads

```bash
curl 'http://localhost:8080/index' \
  -X POST \
  -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Accept-Encoding: gzip, deflate, br, zstd' \
  -H 'Referer: http://localhost:8080/index' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Origin: http://localhost:8080' \
  -H 'Connection: keep-alive' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Priority: u=0, i' \
  --data-raw 'login=admin&password=%27+OR+%271%27%3D%271%27--&submit=Submit'
```

OR (pun intended)

```bash
curl -v "http://localhost:8080/search.php?q=1%27%20UNION%20SELECT%20NULL--"
```

- Look at the **fake information** and then back to see how it has been **logged** on the **defender**'s terminal

### Remote command injection attempts

```bash
curl -v "http://localhost:8080/?cmd=whoami"
curl -v "http://localhost:8080/?cmd=;id"
```

### Use automated scanners

Install basic testing tools and run quick scans against `localhost`.

```bash
nikto -h http://localhost:8080
```

```bash
sqlmap -u "http://localhost:8080/index.php?id=1" --batch --level=1
```

> Each of the above requests are recorded by **Glastopf** and should show up in **logs** and the event store.

>[!IMPORTANT]
>To stop **Glastopf** do:
>
>`sudo docker stop glastopf`



***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/ModSecurity.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/webhoneypot/webhoneypot.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
