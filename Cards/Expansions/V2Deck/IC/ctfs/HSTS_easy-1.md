![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Spotting the Strip

You are analyzing HTTP traffic captured on a public Wi-Fi network. A user visited their bank's website, which is supposed to always use HTTPS.

You find the following in the capture:

```
GET http://www.securebank.com/login HTTP/1.1
Host: www.securebank.com
User-Agent: Mozilla/5.0
```

The bank's server does respond over HTTPS - but the user's browser never made an HTTPS request to begin with.

---

## Question

What does this traffic pattern most likely indicate?

---

## Flags (Choose One)

- **A)** The bank's SSL certificate expired
- **B)** The user manually typed HTTP instead of HTTPS
- **C)** An SSL stripping attack downgraded the connection before it reached the browser
- **D)** The bank's server does not support HTTPS

---

Correct Flag: **C**

---

# Finished?
[Next Question](HSTS_easy-2.md)  
[Back to Card's Main Page](../Exploitation_Of_Missing_HSTS.md)
