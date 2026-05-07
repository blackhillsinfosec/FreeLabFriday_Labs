![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Flash Memory Tampering

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

---

## Question

Based on the evidence, what is the correct sequence of events?

---

## Flags (Choose One)

- **A)** The vendor pushed a legitimate firmware update that accidentally corrupted the BIOS
- **B)** A scheduled task rebooted the machine and caused firmware corruption on restart
- **C)** The hashes match, meaning the firmware is clean and the logs are misleading
- **D)** An attacker gained remote code execution, used Flashrom to overwrite the firmware with a malicious image, then rebooted the machine to activate it

---

Correct Flag: **D**

---

# Finished?
[Next Question](MF_hard.md)  
[Back to Card's Main Page](/Decks/CORE_v3.1/PER/Malicious_Firmware.md)
