![image](/FilesForLabs/images/blueantisyphon.png)

### Hands-On Lab : [Hayabusa Lab](https://freelabfridays.com/labs/introclassfiles/tools/introclass/hayabusa/)

## What is Log Analysis?

Log analysis involves reviewing system and security logs to detect unusual or malicious activity. Each log entry typically includes a timestamp, source, user account, event type, and a unique Event ID.<br>
Some of the most important IDs are:
- **4624** = Successful Logon
- **4625** = Failed logon
- **4688** = Process creation
- **4670** = Permission changes

Effective log analysis involves:
- Filtering noise
- Correlating events over time (easy using special tools like [Hayabusa](https://freelabfridays.com/labs/introclassfiles/tools/introclass/hayabusa/)
- Flagging anomalies like brute-force logins or unusual logon times

<hr>

## Sysmon Logs

Sysmon (System Monitor) is a Windows system service that logs detailed system activity to the Event Log, beyond what standard logs capture. It’s often used in security monitoring and DFIR.<br>

Sysmon logs appear under the Microsoft-Windows-Sysmon/Operational and include details like:
- **Event ID 1** – Process creation (with full command line, parent/child PID)
- **Event ID 3** – Network connections
- **Event ID 10** – Process access (used for example in credential dumping detection)
- **Event ID 11** – File creation

<hr>

## Authentication Logs
Authentication logs include detailed information about the device used to access the service, the user’s location, and other considerations that might influence risk. Generally, these logs only include information about the following events:

- Successful logins
- Login attempts
- Login errors
- Logouts, with additional information shows whether a logout was manual or due to session expiration.

Identity breaches may be detected with the help of this information. For instance, brute force credential-guessing attempts can be detected using authentication logs since they will appear in the audit trail as unsuccessful authentications. They are able to identify the users who were impacted by the breach, but they are unable to determine what those user accounts could access or do. Authorization audit logs are useful in this situation. By using authorization decision logs, we will be able to determine the breach's blast radius.

<hr>

## Tools to Learn
Viewing alerts and logs is key to detecting suspicious activity on a system. Tools like [Hayabusa](https://freelabfridays.com/labs/introclassfiles/tools/introclass/hayabusa/) allow analysts to quickly analyze Windows event logs (.evtx), apply detection rules, and generate timelines or alerts for threats such as privilege escalation, malware, or lateral movement as well as the built in [Windows Event Viewer](/SocAnalystLabs/courseFiles/tools/WinEventViewer.md).