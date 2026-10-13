## Backdoor Behavior

Your UEBA platform flags an anomaly on a build server. You pull the relevant logs:

```
[2024-03-14 03:12:44] Process: python3 | PID: 4821 | Parent: ci-runner
[2024-03-14 03:12:44] Network: 4821 -> 91.108.4.200:443 (encrypted)
[2024-03-14 03:12:45] File write: /tmp/.x11/.sock (hidden dir)
[2024-03-14 03:12:46] Cron added: */5 * * * * python3 /tmp/.x11/.sock
[2024-03-14 03:12:46] File read: ~/.ssh/id_rsa
```

The CI runner executed a build job that used a third-party Python package called `build-helpers`. No developer was logged in at the time.
