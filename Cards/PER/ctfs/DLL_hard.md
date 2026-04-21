![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Hard CTF - Persistence via Boot-Time Hijack

Your team is investigating a machine that keeps beaconing out to an external IP even after malware was supposedly cleaned. You collect the following evidence:

**Autoruns output (at boot):**
```
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
    "UpdateHelper" -> C:\ProgramData\UpdateHelper\updater.exe
```

**Process Monitor (boot sequence):**
```
updater.exe  ->  CreateFile: C:\ProgramData\UpdateHelper\uxtheme.dll  ->  SUCCESS
updater.exe  ->  ImageLoad:  C:\ProgramData\UpdateHelper\uxtheme.dll
updater.exe  ->  TCP Connect: 185.220.xx.xx:443
```

**File system check:**
```
C:\ProgramData\UpdateHelper\uxtheme.dll
    Size:       87,552 bytes
    Signed:     NO
    Created:    2024-11-14 03:12 AM

C:\Windows\System32\uxtheme.dll
    Size:       561,152 bytes
    Signed:     YES (Microsoft)
    Created:    2019-03-18
```

**Memory strings extracted from the loaded uxtheme.dll:**
```
"WS2_32.dll"
"connect"
"VirtualAlloc"
"CreateRemoteThread"
"stage2.bin"
```

---

## Question

The previous analyst concluded the machine was clean after removing the malware from the registry and deleting `updater.exe`. Two days later, the beaconing resumed. Which statement best explains why the cleanup failed AND what should have been done?

---

## Flags (Choose One)

- **A)** The registry key was recreated automatically by Windows; the fix is to disable the Windows Update service
- **B)** The malicious `uxtheme.dll` in `C:\ProgramData\UpdateHelper\` was never removed - it only needs a new loader to beacon again, and the full folder along with any other writable-path DLLs should have been audited and removed as part of cleanup
- **C)** The real `uxtheme.dll` in System32 was also infected; reimaging is the only option
- **D)** The beaconing is coming from a different process; the analyst should focus on network logs instead of the file system

---

Correct Flag: **B**

---

# Finished?
[Back to Card's Main Page](../Dynamic_Link_Library_Hijacking.md)
