![image](/FilesForLabs/images/blueantisyphon.png)

## File Recon

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
