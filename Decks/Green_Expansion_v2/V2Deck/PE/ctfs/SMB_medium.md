## Relay Attack

You are investigating an incident. The logs show the following sequence of events:

```
14:45:01 - LLMNR request broadcast by WS-04 for "BACKUPS"
14:45:01 - Unknown host (192.168.1.88) responded claiming to be "BACKUPS"
14:45:02 - WS-04 initiated SMB connection to 192.168.1.88
14:45:02 - NTLMv2 authentication attempt from CORP\dbadmin observed
14:45:03 - SMB connection opened from 192.168.1.88 to SERVER-02
14:45:03 - Authentication on SERVER-02 succeeded as CORP\dbadmin
14:45:04 - New admin share access: \\SERVER-02\C$
```

No cracking took place. CORP\dbadmin never logged into SERVER-02 directly.
