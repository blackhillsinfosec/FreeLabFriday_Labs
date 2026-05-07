![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - USB Drop Investigation

A USB device was found in a company parking lot and, unfortunately, someone plugged it in. The endpoint security tool logged the following activity seconds after it was connected:

```
[PROCESS]   explorer.exe spawned cmd.exe
[FILE]      cmd.exe copied to C:\Windows\System32\osk.exe
[REGISTRY]  No changes detected
[DURATION]  Total execution time: 8 seconds
```

The USB device was automatically ejected after the script finished running.

---

## Question

Based on the log, what did the USB device do?

---

## Flags (Choose One)

- **A)** It replaced the On-Screen Keyboard executable with a command prompt
- **B)** It installed a keylogger that runs on startup
- **C)** It exfiltrated files from the desktop to a remote server
- **D)** It scanned the local network for open ports

---

Correct Flag: **A**

---

# Finished?
[Next Question](AF_medium.md)  
[Back to Card's Main Page](../Accesibility_Features.md)
