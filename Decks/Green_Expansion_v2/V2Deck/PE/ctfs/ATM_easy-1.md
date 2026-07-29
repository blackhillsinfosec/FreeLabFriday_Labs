![image](/FilesForLabs/images/blueantisyphon.png)

# Easy CTF 1 - Weak JWT Secret

A developer built a login system that issues JWTs to authenticated users. You intercept the following token during testing:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Impva2VyIiwicm9sZSI6InVzZXIifQ.s5cQ2c5tVxZzMkKlT8gHqLpWnY0eJdR3oXvBuCfAiKs
```

You decode the payload and get:

```json
{
  "username": "joker",
  "role": "user"
}
```

You run the token through a JWT cracking tool and recover the signing secret: `secret123`.

---

## Question

Given that you now know the signing secret, what is the most effective next step an attacker would take?

---

## Flags (Choose One)

- **A)** Log out and report the weak secret to the developer
- **B)** Decode the token again to read more fields
- **C)** Forge a new token with `"role": "admin"` signed using the same secret
- **D)** Replay the original token from a different IP address

---

Correct Flag: **C**

---

# Finished?
[Next Question](ATM_easy-2.md)
[Back to Card's Main Page](../Access_Token_Manipulation.md)
