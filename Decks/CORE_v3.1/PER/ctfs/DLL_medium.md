## Privilege Through a Hijacked Load

During an incident response, you find the following on a compromised machine:

```
C:\Program Files\Scheduler\
    TaskRunner.exe        <- runs as SYSTEM at boot
    cryptbase.dll         <- dropped 3 days ago, unknown origin

Event Log:
[Boot]  services.exe spawned TaskRunner.exe  (User: SYSTEM)
[Boot]  TaskRunner.exe loaded cryptbase.dll from C:\Program Files\Scheduler\
[Boot]  cmd.exe spawned by TaskRunner.exe    (User: SYSTEM)
[Boot]  net.exe  ->  "net user backdoor P@ssw0rd /add"
[Boot]  net.exe  ->  "net localgroup administrators backdoor /add"
```

The real `cryptbase.dll` lives in `C:\Windows\System32\`.
