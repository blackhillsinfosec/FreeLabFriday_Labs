![image](/FilesForLabs/images/blueantisyphon.png)

## Weak File Permissions

You have low-privileged shell access on a Linux server as user `student`

While enumerating the system, you run:

<pre>
ls -l /etc/passwd
</pre>

Output:

<pre>
-rw-rw-r-- 1 root root 2480 /etc/passwd
</pre>

You are able to edit the file
