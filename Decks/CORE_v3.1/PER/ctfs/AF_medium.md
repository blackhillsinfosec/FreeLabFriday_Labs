## Persistence via Sticky Keys

A workstation was flagged by your SIEM after business hours activity. You pull the event logs and find the following sequence:

```
[22:14:03]  Physical login screen active, no user session
[22:14:11]  sethc.exe triggered via keyboard shortcut
[22:14:11]  PROCESS: sethc.exe spawned cmd.exe (PID 4872)
[22:14:15]  cmd.exe executed: net user backdoor P@ssw0rd123 /add
[22:14:16]  cmd.exe executed: net localgroup administrators backdoor /add
[22:14:20]  New session opened: user "backdoor"
```

No USB devices were logged at this time. The workstation had been compromised remotely three days earlier via a phishing email.
