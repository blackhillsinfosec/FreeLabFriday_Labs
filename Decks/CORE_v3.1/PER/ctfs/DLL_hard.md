## Persistence via Boot-Time Hijack

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
