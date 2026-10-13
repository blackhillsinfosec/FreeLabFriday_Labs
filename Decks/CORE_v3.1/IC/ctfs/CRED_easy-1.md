![image](/FilesForLabs/images/blueantisyphon.png)

## Password Reuse Discovery

You are reviewing authentication logs from a web application after users reported account lockouts.

You notice the following events:

```
10:01 - Login failed - user: alice@example.com
10:02 - Login failed - user: bob@example.com
10:02 - Login failed - user: charlie@example.com
10:03 - Login failed - user: diana@example.com
10:04 - Login successful - user: bob@example.com
```

All login attempts came from the same IP address within a few minutes.
