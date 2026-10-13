![image](/FilesForLabs/images/blueantisyphon.png)

## Odd Outbound Traffic

You are reviewing outbound proxy logs from a compromised web server.

You notice this pattern repeated every few minutes:

```
POST /api/update HTTP/1.1
Host: updates-storage.net
Content-Length: 48213
User-Agent: curl/7.68.0
```

The server normally only serves website content and does not run update scripts.
