## Basic Log Investigation

You are reviewing web server access logs after suspicious activity was reported.

You find the following request:

```
POST /collect.php HTTP/1.1
User-Agent: Mozilla/5.0
X-Data: YWRtaW46cGFzc3dvcmQ=
```

The same host sends similar requests every minute, each with different encoded values in the header.
