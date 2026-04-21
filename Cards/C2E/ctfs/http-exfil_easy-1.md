![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 1 – Odd Outbound Traffic

You are reviewing outbound proxy logs from a compromised web server.

You notice this pattern repeated every few minutes:

```
POST /api/update HTTP/1.1
Host: updates-storage.net
Content-Length: 48213
User-Agent: curl/7.68.0
```

The server normally only serves website content and does not run update scripts.

---

## Question

What is the **most likely** explanation for this traffic?

---

## Flags (Choose One)

- **A)** Data being exfiltrated over HTTP
- **B)** Normal software updates from the web server
- **C)** Users uploading files through the website
- **D)** A monitoring tool checking server health

---

Correct Flag: **A**

---

# Finished?

[Next Question](http-exfil_easy-2.md)

[Back to Card's Main Page](/Cards/C2E/HTTP_As_Exfil.md)
