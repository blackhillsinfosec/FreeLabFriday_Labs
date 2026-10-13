![image](/FilesForLabs/images/blueantisyphon.png)

## Spotting the Strip

You are analyzing HTTP traffic captured on a public Wi-Fi network. A user visited their bank's website, which is supposed to always use HTTPS.

You find the following in the capture:

```
GET http://www.securebank.com/login HTTP/1.1
Host: www.securebank.com
User-Agent: Mozilla/5.0
```

The bank's server does respond over HTTPS - but the user's browser never made an HTTPS request to begin with.
