![image](/FilesForLabs/images/blueantisyphon.png)

## Suspicious BYOD Connection

A firewall alert shows a personal laptop connecting to the company VPN for the first time.

Minutes later, the device starts making connections to an external IP address every 60 seconds.

Firewall logs show:

```
Source: 10.8.14.23  
Destination: 185.203.119.44  
Protocol: HTTPS  
Interval: 60 seconds (consistent)
```

No employee applications are known to contact this IP.
