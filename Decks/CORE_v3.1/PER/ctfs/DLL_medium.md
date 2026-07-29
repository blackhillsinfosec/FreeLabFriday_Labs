![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Privilege Through a Hijacked Load

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

---

## Question

What outcome did the attacker achieve by placing `cryptbase.dll` inside the Scheduler folder?

---

## Flags (Choose One)

- **A)** They crashed the TaskRunner service to cause a denial of service
- **B)** They intercepted network traffic from the SYSTEM process
- **C)** They replaced the real cryptbase.dll in System32 with a malicious copy
- **D)** They executed arbitrary commands as SYSTEM every time the machine boots, creating a persistent backdoor account

---

Correct Flag: **D**

---

# Finished?
[Next Question](DLL_hard.md)  
[Back to Card's Main Page](../Dynamic_Link_Library_Hijacking.md)
