![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Suspicious Process Hunt

You are reviewing endpoint telemetry from a Windows workstation after a user reported their machine was "acting slow."

You find the following process tree in your EDR console:

```
winword.exe (PID 3120)
  └─ powershell.exe (PID 4488)
       └─ cmd.exe (PID 5012)
            └─ net.exe (PID 5200)
```

The PowerShell process was launched with the following command:

```
powershell.exe -nop -w hidden -enc JABjAGwAaQBlAG4AdA...
```

---

## Question

What does the `-enc` flag in the PowerShell command most likely indicate?

---

## Flags (Choose One)

- **A)** PowerShell is running in safe mode
- **B)** The script requires elevated privileges to execute
- **C)** The command is base64-encoded to avoid detection
- **D)** PowerShell is downloading a Windows update

---

Correct Flag: **C**

---

# Finished?
[Next Question](EPA_easy-2.md)  
[Back to Card's Main Page](/Cards/DET/Endpoint_Security_Protection_Analysis.md)
