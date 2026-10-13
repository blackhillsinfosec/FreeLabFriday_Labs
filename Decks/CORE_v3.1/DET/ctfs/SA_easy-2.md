## Suspicious Process Discovery

During routine monitoring, you run a process listing and find:

```
root   1842  0.0  /usr/sbin/nginx
www-data 2910  0.3  /tmp/.update/checker
www-data 2915  0.2  /tmp/.update/checker
```

You check the system and confirm that nothing in `/tmp` should run as a persistent service.
