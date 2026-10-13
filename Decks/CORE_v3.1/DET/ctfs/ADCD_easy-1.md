![image](/FilesForLabs/images/blueantisyphon.png)

## First Interaction with a Decoy

You are reviewing alerts from a deception platform.

A fake SSH server was deployed inside the network. It is not used by any real employees.

The alert shows:

```
Source IP: 10.10.22.45
Destination: decoy-ssh.internal
Action: Successful login attempt
Username: admin
Password: admin123
```

No legitimate automation or users should ever connect to this system.
