![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Credential Pivot

You are on an internal Windows machine as a low-privilege user. You run Snaffler and it comes back with a hit on a network share:

```
[Share]  \\FILESERVER01\deployments
[File]   deploy.ps1
[Match]  Line 14: $adminPass = "Corp@dmin2022"
[Match]  Line 15: $adminUser = "svc_deploy"
```

You check Active Directory and find that `svc_deploy` is a service account. You also notice the account is listed as a member of the `Domain Admins` group.

You attempt to authenticate to the domain controller using these credentials over WinRM:

```
Enter-PSSession -ComputerName DC01 -Credential corp\svc_deploy
```

The session opens successfully.

---

## Question

Which attack technique best describes what just happened, from the perspective of MITRE ATT&CK?

---

## Flags (Choose One)

- **A)** Brute Force (T1110) - the attacker guessed the password through repeated attempts
- **B)** Pass the Hash (T1550.002) - the NTLM hash was captured and reused without cracking
- **C)** Valid Accounts with Credentials from Files (T1552.001 -> T1078) - a cleartext password found in a file was used to authenticate as a privileged account
- **D)** Kerberoasting (T1558.003) - the service account ticket was requested and cracked offline

---

Correct Flag: **C**

---

# Finished?

[Next Question](CPF_hard.md)  
[Back to Card's Main Page](../Cleartext_Passwords_in_Files.md)
