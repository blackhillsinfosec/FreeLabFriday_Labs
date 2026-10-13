![image](/FilesForLabs/images/blueantisyphon.png)

## Account Enumeration

You are a junior analyst reviewing Kerberos traffic on your internal network. A colleague flagged an unusual spike in `AS-REQ` packets coming from a single workstation over a short period of time.

You pull the capture and see hundreds of requests like this, each with a different username:

```
AS-REQ: john.smith@corp.local
AS-REQ: jane.doe@corp.local
AS-REQ: admin@corp.local
AS-REQ: helpdesk@corp.local
AS-REQ: ...
```

Each request comes from `192.168.1.47` within a 3-minute window.
