![image](/FilesForLabs/images/blueantisyphon.png)

## Wrong Place, Right Name

A developer reports that after installing a new application, something feels off. You inspect the application folder and find this:

```
C:\Program Files\LegitApp\
    LegitApp.exe
    version.dll        <- placed here by unknown source
    
C:\Windows\System32\
    version.dll        <- the real one
```

The application loads `version.dll` at startup and does not use an absolute path.
