## Full Physical Attack Simulation

You are a SOC analyst investigating a reported incident at a branch office. An employee noticed the screen on an unattended reception desk PC acting strangely for a few seconds. No one saw what happened. You are handed the following data to work with.

---

## Evidence 1 – USB Event Log

```
[09:02:41]  USB device connected: VID_F000 PID_0232 (HID Keyboard)
[09:02:41]  Device recognized as: HID-compliant keyboard
[09:02:42]  Keystrokes injected via HID interface
[09:02:49]  USB device disconnected
```

---

## Evidence 2 – File System Changes

```
[09:02:43]  C:\Windows\System32\utilman.exe - MODIFIED
[09:02:44]  C:\Windows\System32\osk.exe - MODIFIED
[09:02:45]  C:\Temp\r.bat - CREATED then DELETED
```

---

## Evidence 3 – Registry

```
[09:02:46]  HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\utilman.exe
            Debugger = "C:\Windows\System32\cmd.exe"
```

---

## Evidence 4 - Network Log (three days later)

```
[11:45:02]  RDP session initiated from external IP 185.220.xx.xx
[11:45:09]  Login screen reached, no credentials entered
[11:45:11]  Win + U shortcut triggered
[11:45:11]  cmd.exe spawned as SYSTEM
[11:45:14]  net user /add ...
[11:45:17]  RDP session authenticated as new local admin
```
