## Basic Log Investigation

You are reviewing web server access logs after suspicious activity was reported.

You find the following request:

```
POST /upload.php HTTP/1.1  
User-Agent: Mozilla/5.0  
File: shell.php
```

Shortly after, you see repeated access to:

`/uploads/shell.php`
