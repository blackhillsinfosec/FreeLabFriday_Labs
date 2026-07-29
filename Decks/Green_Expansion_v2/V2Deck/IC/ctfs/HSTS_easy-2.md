![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 2 - Cookie Grab

You are reviewing a Wireshark capture from a compromised network segment. A victim logged into a web application while connected to a rogue access point.

You spot the following unencrypted HTTP request:

```
GET /dashboard HTTP/1.1
Host: app.internaltools.com
Cookie: session=eyJ1c2VyIjoiYWRtaW4ifQ==
User-Agent: Mozilla/5.0
```

The application never sent an HSTS header, so the browser never enforced HTTPS.

---

## Question

What can the attacker do with the captured `session` cookie?

---

## Flags (Choose One)

- **A)** Nothing - cookies are encrypted separately from the connection
- **B)** Crack the user's password using the cookie value
- **C)** Replay the cookie to impersonate the victim without needing their credentials
- **D)** Use it to locate the server's private SSL key

---

Correct Flag: **C**

---

# Finished?
[Next Question](HSTS_medium.md)  
[Back to Card's Main Page](../Exploitation_Of_Missing_HSTS.md)
