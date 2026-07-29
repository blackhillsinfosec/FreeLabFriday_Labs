![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF - Hunting the Exfil Channel

Your SIEM has triggered an alert on a developer's workstation. You pull the correlated events and find the following timeline:

```
[09:14:02] FILE ACCESS   python.exe  READ  C:\Projects\src\db_config.py
[09:14:02] FILE ACCESS   python.exe  READ  C:\Projects\src\api_keys.json
[09:14:03] FILE ACCESS   python.exe  READ  C:\Projects\deploy\prod_credentials.env
[09:14:05] NETWORK       python.exe  CONNECT  slack.com:443
[09:14:06] NETWORK       python.exe  POST  https://hooks.slack.com/services/T04XXX/B07XXX/XXXXXXX
[09:14:06] NETWORK       python.exe  BYTES_OUT: 87,412
```

The developer has a Python environment set up, but no Slack bots or automation scripts were approved for this machine. The Slack webhook URL in the logs does not match any internal workspace the company uses.

---

## Question

A junior analyst on your team says: *"It's probably fine, Python and Slack are both legitimate tools we use every day."*

What is wrong with that reasoning, and what has most likely happened?

---

## Flags (Choose One)

- **A)** The analyst is right — Python and Slack together cannot be used maliciously
- **B)** The concern is the file size; 87 KB is too large for Slack to accept
- **C)** Python is flagged because it is not an approved application on developer machines
- **D)** A script read sensitive credential files and posted them to an external Slack webhook, which is a classic cloud exfiltration channel

---

Correct Flag: **D**

---

# Finished?
[Next Question](CBSE_hard.md)  
[Back to Card's Main Page](../Cloud_Based_Services_As_Exfil.md)
