## USB Drop Investigation

A USB device was found in a company parking lot and, unfortunately, someone plugged it in. The endpoint security tool logged the following activity seconds after it was connected:

```
[PROCESS]   explorer.exe spawned cmd.exe
[FILE]      cmd.exe copied to C:\Windows\System32\osk.exe
[REGISTRY]  No changes detected
[DURATION]  Total execution time: 8 seconds
```

The USB device was automatically ejected after the script finished running.
