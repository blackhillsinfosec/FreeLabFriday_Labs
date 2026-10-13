## Deception-Based Detection Scenario

During an incident, you see the following timeline:

```
08:12 - Access to decoy AWS credentials stored on a server
08:14 - Outbound connection to an unknown IP
08:16 - Alert from CanaryToken tied to those credentials
08:18 - Attempts to enumerate cloud storage resources
```

The credentials were intentionally fake and only existed for detection purposes.
