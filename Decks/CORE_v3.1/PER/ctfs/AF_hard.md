![image](/FilesForLabs/images/blueantisyphon.png)

# Hard CTF – Full Physical Attack Simulation

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

---

## Questions

Answer all three to complete the challenge:

**1.** What device was used in the initial physical attack, and how did it avoid being detected as a USB storage device?

**2.** The attacker modified `utilman.exe` directly AND added a registry key under Image File Execution Options. What does the registry method do differently, and why might an attacker prefer it?

**3.** Three days passed between the physical attack and the remote login. What does this tell you about the attacker's intent, and what detection opportunity was missed during that window?

---

## Flags (Choose One)

- **A)** A USB Rubber Ducky was used; the registry key runs cmd.exe instead of utilman.exe without touching the binary; the attacker was waiting for the right moment and the missed opportunity was reviewing USB events
- **B)** A standard USB drive was used; the registry key creates a new admin account silently; the attacker was testing defenses and the missed opportunity was network monitoring
- **C)** A USB Rubber Ducky was used; the registry key runs cmd.exe as a debugger for utilman.exe, meaning the binary is untouched and harder to detect via file hash; the attacker was being deliberate to avoid quick detection, and the missed opportunity was reviewing the Image File Execution Options registry hive for new entries
- **D)** An OMGCable was used; the registry key disables UAC prompts for accessibility tools; the attacker was exfiltrating data slowly and the missed opportunity was egress traffic analysis

---

Correct Flag: **C**

---

# Finished?
[Back to Card's Main Page](../Accesibility_Features.md)
