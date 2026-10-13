![image](/FilesForLabs/images/blueantisyphon.png)

## Exposed Config File

You are doing a security review of a company's internal file share. While browsing through the `\\FILESERVER\IT\Scripts\` directory, you come across a PowerShell script called `backup.ps1`.

Inside the script, you find the following lines:

```powershell
$username = "svc_backup"
$password = "W!nter2023!"
$target = "\\PRODSERVER\Backups"

net use $target /user:$username $password
```
