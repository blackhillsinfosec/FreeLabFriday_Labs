![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 – Basic Log Investigation

You are reviewing web server access logs after suspicious activity was reported.

You find the following request:

```
POST /upload.php HTTP/1.1  
User-Agent: Mozilla/5.0  
File: shell.php
```

Shortly after, you see repeated access to:

`/uploads/shell.php`

---

## Question

What most likely happened?

---

## Flags (Choose One)

- **A)** The attacker uploaded a web shell
- **B)** A user uploaded a normal image
- **C)** The request failed due to permissions
- **D)** A vulnerability scan was running

---

Correct Flag: **A**



---

# Finished?

[Next Question](CWS_medium.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/IC/Compromised_Web_Server.md)
