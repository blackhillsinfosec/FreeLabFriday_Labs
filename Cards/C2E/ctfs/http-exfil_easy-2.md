![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 – Basic Log Investigation

You are reviewing web server access logs after suspicious activity was reported.

You find the following request:

```
POST /collect.php HTTP/1.1
User-Agent: Mozilla/5.0
X-Data: YWRtaW46cGFzc3dvcmQ=
```

The same host sends similar requests every minute, each with different encoded values in the header.

---

## Question

What is the **most likely** purpose of these requests?

---

## Flags (Choose One)

- **A)** A broken web form repeatedly submitting data
- **B)** Automated health checks from a load balancer
- **C)** Credentials or data being sent out through HTTP headers
- **D)** A normal browser caching issue

---

Correct Flag: **C**

---

# Finished?

[Next Question](http-exfil_medium.md)

[Back to Card's Main Page](/Cards/C2E/HTTP_As_Exfil.md)
