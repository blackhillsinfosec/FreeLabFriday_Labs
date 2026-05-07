![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Session Hijack

You are a security analyst reviewing an incident. A user reported that their account was accessed by someone else, even though they never shared their password. The user was working from a coffee shop that day.

You pull the application logs and find two sessions for the same account within minutes of each other:

```
[10:42:13] LOGIN SUCCESS  user=jsmith  ip=192.168.1.45  session=a3f9c1
[10:44:07] LOGIN SUCCESS  user=jsmith  ip=10.0.0.88    session=a3f9c1
```

Both sessions share the **same session token**. The application has no HSTS header configured.

You also find this in the network capture from that morning:

```
HTTP/1.1 200 OK
Set-Cookie: session=a3f9c1; path=/
```

Note: The `Secure` flag is absent from the cookie, and the site had no HSTS policy.

---

## Question

Which combination of missing protections allowed this attack to succeed?

---

## Flags (Choose One)

- **A)** Missing firewall rules and an expired SSL certificate
- **B)** No HSTS header and no `Secure` flag on the session cookie, allowing it to be transmitted and captured over HTTP
- **C)** Weak password policy and missing two-factor authentication
- **D)** The server did not validate the user's IP address on each request

---

Correct Flag: **B**

---

# Finished?
[Next Question](HSTS_hard.md)  
[Back to Card's Main Page](../Exploitation_Of_Missing_HSTS.md)
