![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Spot the Upload

You are reviewing endpoint logs on a machine that was flagged for unusual behavior.

You notice the following process activity:

```
[10:42:31] svchost.exe       READ   C:\Users\jdoe\Documents\contracts_Q3.zip
[10:42:33] svchost.exe       READ   C:\Users\jdoe\Desktop\passwords_backup.txt
[10:42:35] svchost.exe       CONNECT  accounts.google.com:443
[10:42:36] svchost.exe       POST   https://www.googleapis.com/upload/drive/v3/files
```

`svchost.exe` is a Windows system process. It does not normally read user documents or make Google Drive API calls.

---

## Question

What is most likely happening on this machine?

---

## Flags (Choose One)

- **A)** A legitimate Google Drive sync client is backing up files
- **B)** The machine is running a scheduled antivirus scan
- **C)** A Windows update is uploading diagnostic data to Microsoft
- **D)** Malware is using the Google Drive API to exfiltrate sensitive files

---

Correct Flag: **D**

---

# Finished?
[Next Question](CBSE_easy-2.md) 

[Back to Card's Main Page](../Cloud_Based_Services_As_Exfil.md)
