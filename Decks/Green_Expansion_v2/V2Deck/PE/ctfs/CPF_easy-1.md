![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - File Recon

You have just gained a low-privilege shell on a target Linux machine during a penetration test. You start poking around the filesystem and come across the following file at `/var/www/html/config.php`:

```php
<?php
$db_host = "localhost";
$db_name = "appdb";
$db_user = "root";
$db_pass = "Passw0rd123!";
?>
```

The file has world-readable permissions (`-rw-r--r--`).

---

## Question

What is the most immediate risk this file creates?

---

## Flags (Choose One)

- **A)** The PHP code will crash the web application on the next request
- **B)** An attacker with any local access can read the database password in plain text
- **C)** The file exposes the database hostname to the internet directly
- **D)** The `root` username is reserved and cannot be used for database connections

---

Correct Flag: **B**

---

# Finished?

[Next Question](CPF_easy-2.md)  
[Back to Card's Main Page](../Cleartext_Passwords_in_Files.md)
