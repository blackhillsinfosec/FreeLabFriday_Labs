![image](/FilesForLabs/images/blueantisyphon.png)

## Capturing a Hash

You are on a penetration test inside a corporate Windows network. You run Responder on your machine and wait. A few minutes later, you see the following output in your terminal:

```
[*] [LLMNR] Poisoned answer sent to 192.168.1.45 for name FILESERV01
[*] [SMB] NTLMv2-SSP Client   : 192.168.1.45
[*] [SMB] NTLMv2-SSP Username : CORP\jsmith
[*] [SMB] NTLMv2-SSP Hash     : jsmith::CORP:4a3b1c...<truncated>
```
