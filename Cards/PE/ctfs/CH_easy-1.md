![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Exposed Config File

You are doing a security review of a company's internal file share. While browsing through the `\\FILESERVER\IT\Scripts\` directory, you come across a PowerShell script called `backup.ps1`.

Inside the script, you find the following lines:

```powershell
$username = "svc_backup"
$password = "W!nter2023!"
$target = "\\PRODSERVER\Backups"

net use $target /user:$username $password
```

---

## Question

What is the main security problem with this script?

---

## Flags (Choose One)

- **A)** The script is using an outdated PowerShell version
- **B)** The target server path is incorrectly formatted
- **C)** Credentials are hardcoded in plaintext inside the script
- **D)** The script is missing error handling

---

Correct Flag: **C**

---

# Finished?
[Next Question](CH_easy-2.md)  
[Back to Card's Main Page](../Credential_Harvesting.md)
