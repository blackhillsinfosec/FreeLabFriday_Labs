## Full Kernel Rootkit Investigation

Your SOC receives an alert from an EDR tool that briefly fired on a host before going silent. You pull what logs you can and piece together the following timeline:

```
[08:14:22]  PowerShell executed:  
            sc.exe create VulnHelper binPath= "C:\Windows\System32\drivers\dbutil_2_3.sys" type= kernel

[08:14:35]  PowerShell executed:  
            sc.exe start VulnHelper

[08:14:38]  EDR process terminated unexpectedly

[08:14:41]  New kernel module loaded: [unnamed, unsigned, 41KB]

[08:15:02]  Outbound connection established to 185.220.xx.xx:443

[08:15:10]  EDR process restart attempt - failed
```

You research `dbutil_2_3.sys` and find it is a legitimate but **known-vulnerable** Dell driver with a CVE that allows arbitrary kernel memory read/write.
