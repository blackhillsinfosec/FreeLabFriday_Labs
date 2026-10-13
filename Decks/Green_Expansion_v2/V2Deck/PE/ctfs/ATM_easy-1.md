![image](/FilesForLabs/images/blueantisyphon.png)

## Weak JWT Secret

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
