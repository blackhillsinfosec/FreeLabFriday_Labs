## Session Hijack

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
