## Log Hunt

You are reviewing Windows Security event logs on a domain controller. The logs were pulled after a threat hunter flagged unusual activity overnight.

You find the following log entry:

```
Event ID: 4720
Time:      2024-11-14 02:47:33
Message:   A user account was created.

  Subject:
    Account Name:   SYSTEM
    Account Domain: WORKSTATION-11

  New Account:
    Account Name:   net_svc_mgr
    Account Domain: WORKSTATION-11
```

You also notice that five minutes later, Event ID **4732** fires - the new account was added to the **Administrators** group.
