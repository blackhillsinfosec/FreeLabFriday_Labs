## Missing DLL Hunt

You are analyzing a process monitor log captured on a workstation. You notice the following entries:

```
[09:14:22]  LegitApp.exe  ->  SearchOrder: C:\Users\john\Downloads\helper.dll  ->  NOT FOUND
[09:14:22]  LegitApp.exe  ->  SearchOrder: C:\Windows\System32\helper.dll      ->  NOT FOUND
[09:14:22]  LegitApp.exe  ->  SearchOrder: C:\Windows\helper.dll               ->  NOT FOUND
```

The next day, after a complaint about slow performance, you run the same capture:

```
[10:02:01]  LegitApp.exe  ->  SearchOrder: C:\Users\john\Downloads\helper.dll  ->  LOADED
```
