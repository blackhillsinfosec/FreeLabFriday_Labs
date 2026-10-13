![image](/FilesForLabs/images/blueantisyphon.png)

## Spot the Upload

You are reviewing endpoint logs on a machine that was flagged for unusual behavior.

You notice the following process activity:

```
[10:42:31] svchost.exe       READ   C:\Users\jdoe\Documents\contracts_Q3.zip
[10:42:33] svchost.exe       READ   C:\Users\jdoe\Desktop\passwords_backup.txt
[10:42:35] svchost.exe       CONNECT  accounts.google.com:443
[10:42:36] svchost.exe       POST   https://www.googleapis.com/upload/drive/v3/files
```

`svchost.exe` is a Windows system process. It does not normally read user documents or make Google Drive API calls.
