![image](/FilesForLabs/images/blueantisyphon.png)

## The Forgotten Admin Panel

You’re doing external recon for a permitted engagement. A single public IP is in scope.

A quick service check gives you this:

```
80/tcp   open  http
443/tcp  open  https
8080/tcp open  http-proxy
```

Browsing `http://<TARGET>:8080/` shows a login page titled:

**“Jenkins”**

You also notice the server responds differently depending on the URL:

- `/login` → login page
- `/api/json` → returns data without prompting for login

---

## Goal

Pick the **most likely** initial path to get a foothold **fast** (CTF-style), based on what you see.
