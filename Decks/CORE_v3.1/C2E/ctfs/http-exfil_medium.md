![image](/FilesForLabs/images/blueantisyphon.png)

# Medium CTF – Hidden Data in Traffic

You are analyzing network captures from a web server that was recently compromised.

Most traffic looks normal, but you notice a series of requests like this:

```
GET /track?id=6d795f646174615f7061727431 HTTP/1.1
GET /track?id=6d795f646174615f7061727432 HTTP/1.1
GET /track?id=6d795f646174615f7061727433 HTTP/1.1
```

The destination domain is unknown and not part of the company's infrastructure.

---

## Question

What technique is most likely being used here?

---

## Flags (Choose One)

- **A)** Web analytics tracking from a third‑party service
- **B)** Data split into chunks and exfiltrated via URL parameters
- **C)** Normal session identifiers used by the application
- **D)** A denial‑of‑service test

---

Correct Flag: **B**

---

# Finished?

[Next Question](http-exfil_hard.md)

[Back to Card's Main Page](/Decks/CORE_v3.1/C2E/HTTP_As_Exfil.md)
