## Registry Trail

You are investigating a compromised machine. The user says something feels off every time they log in, but nothing obvious shows on the desktop.

You run a registry query and find the following:

```
HKCU\Environment
  UserInitMprLogonScript = \\10.10.10.5\share\init.vbs
```

The IP `10.10.10.5` does not belong to any known internal server.
