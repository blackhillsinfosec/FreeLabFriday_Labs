![image](https://github.com/user-attachments/assets/068fae26-6e8f-402f-ad69-63a4e6a1f59e)

# Easy CTF 2 - Token from Local Storage

You are reviewing the source code of a web application. You notice the following JavaScript running on the login page after a successful authentication:

```javascript
localStorage.setItem("auth_token", response.token);
```

Later in the app, every API request is built like this:

```javascript
fetch("/api/profile", {
  headers: {
    "Authorization": "Bearer " + localStorage.getItem("auth_token")
  }
});
```

A separate finding in the same app shows it is vulnerable to stored XSS on the comments section.

---

## Question

How would an attacker most likely abuse this combination of findings?

---

## Flags (Choose One)

- **A)** Steal the token by injecting a script that reads localStorage and sends it to an attacker-controlled server
- **B)** Modify the fetch() call to remove the Authorization header
- **C)** Brute force the token value since it is stored client-side
- **D)** Disable JavaScript in the browser to prevent the token from loading

---

Correct Flag: **A**

---

# Finished?
[Next Question](ATM_medium.md)
[Back to Card's Main Page](../Access_Token_Manipulation.md)
