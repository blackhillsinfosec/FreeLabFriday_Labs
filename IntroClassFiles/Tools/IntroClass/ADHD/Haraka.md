![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

---

This is a lab from **John Strand**'s **Active Defense and Cyber Deception** Course:

https://www.antisyphontraining.com/product/active-defense-and-cyber-deception-with-john-strand/

---

# For the Ubuntu VM

# Haraka 

**Goal:** Build a simple Haraka SMTP that demonstrates SMTP interaction, using the `tarpit` plugin to slow and frustrate attackers

---

# Start

- Open a **terminal**

- Go to the lab directory and make sure **Haraka** is set up

```bash
cd ~/ADCD/haraka
```

```bash
haraka -i .
```

```bash
ls -la
```

<img width="598" height="201" alt="Screenshot From 2026-03-14 22-10-01" src="https://github.com/user-attachments/assets/9d02f1f3-e767-4ac9-ab5a-6d17c135ebb9" />



- You now have a **Haraka** instance with `config/`, `plugins/`, etc.

---

## Configure Haraka for tarpit deception

1. Set **Haraka** to listen on **port 2525**. Edit `config/smtp.ini`:

```bash
nano config/smtp.ini
```

- Add at the end:

```ini
listen=0.0.0.0:2525
```

- To exit and save the file do `Ctrl + x` and `y` and `Enter`

2. Enable a tiny **HTTP endpoint** for live observation. Create `config/http.ini`:

```bash
nano config/http.ini
```

```ini
listen=0.0.0.0:8080
```

- To exit and save the file do `Ctrl + x` and `y` and `Enter`

3. Edit `config/plugins` so it contains these lines (order matters - keep `tarpit` early):

```bash
rm config/plugins
```

```bash
nano config/plugins
```

- Paste the following:

```
tarpit
tarpit_demo
access
helo.checks
rcpt_to.in_host_list
data.headers
queue/smtp_forward
save_msg
```

- To exit and save the file do `Ctrl + x` and `y` and `Enter`

4.

```bash
nano plugins/tarpit_demo.js
```

- Paste:

```js
// plugins/tarpit_demo.js
exports.hook_connect = function (next, connection) {
    const seconds = 3; // delay per hook
    connection.notes.tarpit = seconds;
    connection.loginfo(this, 'tarpit_demo: setting tarpit to ' + seconds + ' seconds');
    next();
};
```

- To exit and save the file do `Ctrl + x` and `y` and `Enter`

* `tarpit` will slow connections (deception).
* `save_msg` (we will add next) stores message files for analysis.

---

## Add a simple message‑saving plugin

- Create `plugins/save_msg.js` with this content. It writes received messages to `logs/msgs/`:

```bash
nano plugins/save_msg.js
```

- Paste the following:

```javascript
// plugins/save_msg.js
const fs = require('fs');
const path = require('path');

exports.hook_data_post = function (next, connection) {
    const txn = connection.transaction;
    if (!txn) return next();

    const outdir = path.join(__dirname, '..', 'logs', 'msgs');
    fs.mkdirSync(outdir, { recursive: true });

    const fname = path.join(
        outdir,
        Date.now() + '-' + Math.floor(Math.random() * 10000) + '.eml'
    );

    const from = (txn.mail_from && txn.mail_from.original) ?
        txn.mail_from.original : '<unknown>';

    const rcpts = (txn.rcpt_to || [])
        .map(r => r.original)
        .join(', ');

    const header =
        'From: ' + from + '\n' +
        'To: ' + rcpts + '\n\n';

    const ws = fs.createWriteStream(fname);
    ws.write(header);

    txn.message_stream.pipe(ws);

    ws.on('finish', () => {
        connection.loginfo(this, 'saved message to ' + fname);
        next();
    });

    ws.on('error', (err) => {
        connection.logerror(this, 'failed to save message: ' + err.message);
        next();
    });
};
```

- To exit and save the file do `Ctrl + x` and `y` and `Enter`

- Make the plugin executable:

```bash
chmod 644 plugins/save_msg.js
```

---

## Tarpit configuration

- Create `config/tarpit.ini` to customize tarpit behavior. Example (conservative delays):

```bash
nano config/tarpit.ini
```

- Paste the following:

```ini
# config/tarpit.ini
# base delay in seconds
base_delay=2
# random extra delay (0..n seconds)
rand_delay=3
# apply to all connections
enabled=1
```


- To exit and save the file do `Ctrl + x` and `y` and `Enter`

- You can increase `base_delay` and `rand_delay` to make attacks slower during demonstrations

---

## Start Haraka and confirm it is listening

```bash
haraka -c .
```

<img width="1156" height="1008" alt="2026-03-14_22-58" src="https://github.com/user-attachments/assets/7574f4f4-0417-440d-b536-29da11c23c2d" />

- Open another **Terminal**

```bash
# check listen port
ss -ltnp | grep 2525
```

<img width="970" height="48" alt="2026-03-14_23-00" src="https://github.com/user-attachments/assets/fba65ea7-b81f-4748-97bb-cbc373b1742a" />


---

## Simulate attacker behavior and observe tarpit

### a) Manual SMTP session (telnet / netcat)

```bash
nc localhost 2525
```

- Then type:

```bash
HELO attacker.example.com
```

```bash
MAIL FROM:<evil@attacker.test>
```

```bash
RCPT TO:<victim@localhost>
```

- Check the logs on the **Haraka** Terminal

<img width="1281" height="136" alt="2026-03-14_23-04" src="https://github.com/user-attachments/assets/bf980f25-1574-411c-b92f-4707d093cecb" />

- Now back at the **Attacker** Termianl

```bash
QUIT
```

- Watch the **logs** on the first **terminal**. Connections will be slower depending on `tarpit.ini` settings

### b) Scripted load with `swaks`

```bash
# single message
swaks --server localhost:2525 --from attacker@evil.test --to victim@localhost --data "Subject: swaks test

hello"
```

<img width="781" height="350" alt="2026-03-14_23-07" src="https://github.com/user-attachments/assets/cd936150-f10b-4028-9810-5660de1ca436" />

```bash
# rapid loop to show tarpit effect
for i in {1..8}; do
  swaks --server localhost:2525 --from t$i@x.test --to victim@localhost --data "Subject: loop $i

hello $i" &
done
```

Because `tarpit` intentionally delays responses, the loop will take noticeably longer than without tarpit. Observe connection times in `haraka.out`

---

## Demonstrate attacker frustration (timing comparison)

- Stop **haraka**, from the **haraka** terminal do `Ctrl + c`

1. Let's comment out `tarpit_demo` in plugin

```bash
nano config/plugins
```

- Put a `#` in before `tarpit_demo`

<img width="209" height="199" alt="0" src="https://github.com/user-attachments/assets/f322e329-dada-4a48-b3b1-819838b478c7" />

- To exit and save the file do `Ctrl + x` and `y` and `Enter`

- Start it again

2. Run the same `swaks` loop and measure how long it takes:

```bash
time bash -c 'for i in {1..8}; do swaks --server localhost:2525 --from t$i@x.test --to victim@localhost --data "Subject: quick $i

ok" & done; wait'
```

<img width="177" height="72" alt="1" src="https://github.com/user-attachments/assets/5ff4c22e-2e22-4d6d-a671-33a267f10321" />

3. Re-enable tarpit (set delays back) and run the same `time` command again. The second run should take longer - this demonstrates the deceptive slowdown.

<img width="180" height="74" alt="2" src="https://github.com/user-attachments/assets/d37f194c-7478-444a-985d-80259993bce2" />



***                                                                 
<b><i>Continuing the course? </br>[Next Lab](/IntroClassFiles/Tools/IntroClass/ADHD/dionaea.md)</i></b>

<b><i>Want to go back? </br>[Previous Lab](/IntroClassFiles/Tools/IntroClass/ADHD/ModSecurity.md)</i></b>

<b><i>Looking for a different lab? </br>[Lab Directory](/IntroClassFiles/navigation.md)</i></b>

***Finished with the Labs?***

Please be sure to destroy the lab environment!

[Click here for instructions on how to destroy the Lab Environment](/IntroClassFiles/Tools/IntroClass/LabDestruction/labdestruction.md)

---
