## Flash Memory Tampering

During an incident response engagement, you collect a memory dump and a firmware dump from a compromised server. You run a hash comparison between the firmware currently installed on the machine and the vendor's official release:

```
$ sha256sum current_firmware.bin official_firmware.bin

a3f1c2e9b847d6051f2398c4e1720dab3f6c891e44b2f97a3c10d5e8b24f6c01  current_firmware.bin
7d94bc3e12a4f8d02c6e517b3f9084ec1a2d56f0c83e4b21a97d6c0e5f3b8a74  official_firmware.bin
```

You then use Impacket's `wmiexec` logs to check what commands were run on the system before the compromise was detected:

```
[2024-03-12 02:14:33] cmd.exe /c flashrom -p internal -w malicious.bin
[2024-03-12 02:14:51] cmd.exe /c shutdown /r /t 0
```
