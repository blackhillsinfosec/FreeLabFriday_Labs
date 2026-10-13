## Cookie Grab

You are reviewing a Wireshark capture from a compromised network segment. A victim logged into a web application while connected to a rogue access point.

You spot the following unencrypted HTTP request:

```
GET /dashboard HTTP/1.1
Host: app.internaltools.com
Cookie: session=eyJ1c2VyIjoiYWRtaW4ifQ==
User-Agent: Mozilla/5.0
```

The application never sent an HSTS header, so the browser never enforced HTTPS.
