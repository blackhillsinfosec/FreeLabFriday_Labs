## Chained Escalation

You have a low-privileged shell on a Linux server.

Enumeration reveals:

* A writable script executed by a root cron job
* The script calls `tar` without using an absolute path
* Your user controls the `PATH` variable
