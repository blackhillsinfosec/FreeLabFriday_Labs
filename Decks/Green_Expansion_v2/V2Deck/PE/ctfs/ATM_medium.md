![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Medium CTF - OAuth Token Abuse

A company uses OAuth 2.0 to allow a third-party reporting tool to access employee data. During a security review, you capture the following authorization request being sent to the OAuth server:

```
GET /oauth/authorize
  ?response_type=code
  &client_id=reporting-tool
  &redirect_uri=https://reporting.internal/callback
  &scope=read:all
  &state=abc123
```

The OAuth server responds with a code, which the reporting tool then exchanges for an access token. You also notice the following:

- The `redirect_uri` parameter is not validated server-side
- The `scope=read:all` grants access to every employee record
- The access token has no expiry set and is logged in plaintext in the app's debug logs

---

## Question

An attacker with access to the debug logs wants to impersonate the reporting tool and pull all employee records. Which combination of weaknesses makes this directly possible?

---

## Flags (Choose One)

- **A)** The weak state parameter and the broad scope together allow CSRF into the OAuth flow
- **B)** The unvalidated redirect_uri and the missing token expiry - the attacker can redirect the code to their own server, exchange it for a long-lived token, and use the read:all scope indefinitely
- **C)** The plaintext log storage alone is enough - the attacker reads the token from the logs and replays it before it expires in 60 seconds
- **D)** The attacker modifies the client_id to impersonate a different application and gets issued a new token automatically

---

Correct Flag: **B**

---

# Finished?
[Next Question](ATM_hard.md)
[Back to Card's Main Page](../Access_Token_Manipulation.md)
